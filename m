From: akpm@linux-foundation.org
Subject: + hfsplus-add-implementation-of-the-acls-support.patch added to -mm tree
Date: Wed, 20 Feb 2013 15:02:20 -0800
Message-ID: <20130220230221.088465A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:56721 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3BTXCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 18:02:22 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so856759vea.4
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 15:02:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de


The patch titled
     Subject: hfsplus: add implementation of the ACLs support
has been added to the -mm tree.  Its filename is
     hfsplus-add-implementation-of-the-acls-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: add implementation of the ACLs support

Add implementation of the ACLs support for hfsplus driver.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/acl.c | 1491 +++++++++++++++++++++++++++++++++++++++++++++
 fs/hfsplus/acl.h |   90 ++
 2 files changed, 1581 insertions(+)

diff -puN /dev/null fs/hfsplus/acl.c
--- /dev/null
+++ a/fs/hfsplus/acl.c
@@ -0,0 +1,1491 @@
+/*
+ * linux/fs/hfsplus/acl.c
+ *
+ * Vyacheslav Dubeyko <slava@dubeyko.com>
+ *
+ * Handler for Posix Access Control Lists (ACLs) support.
+ */
+
+#include <linux/uuid.h>
+
+#include "hfsplus_fs.h"
+#include "xattr.h"
+#include "acl.h"
+
+#define HFSPLUS_ACE_ID_MASK 0xFFFFFFFF
+
+static unsigned char hfsplus_group_fingerprint[] = {0xab, 0xcd, 0xef,
+						    0xab, 0xcd, 0xef,
+						    0xab, 0xcd, 0xef,
+						    0xab, 0xcd, 0xef};
+
+static unsigned char hfsplus_user_fingerprint[] = {0xff, 0xff,
+						   0xee, 0xee,
+						   0xdd, 0xdd,
+						   0xcc, 0xcc,
+						   0xbb, 0xbb,
+						   0xaa, 0xaa};
+
+#define HFSPLUS_FINGERPRINT_SIZE \
+	(HFSPLUS_GUID_SIZE - sizeof(HFSPLUS_ACE_ID_MASK))
+
+#define HFSPLUS_EVERYBODY_ID 0xc
+
+struct posix_ace_state {
+	u32 allow;
+	u32 deny;
+};
+
+struct posix_user_ace_state {
+	uid_t uid;
+	struct posix_ace_state perms;
+};
+
+struct posix_ace_state_array {
+	int n;
+	struct posix_user_ace_state aces[];
+};
+
+struct posix_acl_state {
+	int empty;
+	struct posix_ace_state owner;
+	struct posix_ace_state group;
+	struct posix_ace_state other;
+	struct posix_ace_state everyone;
+	struct posix_ace_state mask; /* Deny unused in this case */
+	struct posix_ace_state_array *users;
+	struct posix_ace_state_array *groups;
+};
+
+static inline void free_state(struct posix_acl_state *state)
+{
+	kfree(state->users);
+	kfree(state->groups);
+}
+
+static int init_state(struct posix_acl_state *state, int cnt)
+{
+	int alloc_size;
+
+	memset(state, 0, sizeof(struct posix_acl_state));
+	state->empty = 1;
+
+	alloc_size = sizeof(struct posix_ace_state_array) +
+			(cnt * sizeof(struct posix_user_ace_state));
+
+	state->users = kzalloc(alloc_size, GFP_KERNEL);
+	if (!state->users)
+		return -ENOMEM;
+
+	state->groups = kzalloc(alloc_size, GFP_KERNEL);
+	if (!state->groups)
+		goto init_state_failed;
+
+	return 0;
+
+init_state_failed:
+	free_state(state);
+	return -ENOMEM;
+}
+
+static const struct hfsplus_acl_record *hfsplus_acl_record_from_xattr(
+							const void *value,
+							size_t size)
+{
+	const struct hfsplus_filesec *filesec_ptr =
+			(const struct hfsplus_filesec *)value;
+	const struct hfsplus_acl_record *acl_record_ptr = NULL;
+	size_t filesec_hdr_size = offsetof(struct hfsplus_filesec, fsec_acl);
+	size_t acl_record_hdr_size =
+		offsetof(struct hfsplus_acl_record, acl_ace);
+	size_t known_size = filesec_hdr_size;
+	u32 acl_entries_count = 0;
+	u32 acl_entries_size = 0;
+
+	if (unlikely(size < known_size)) {
+		printk(KERN_ERR "hfs: filesec hdr corrupted\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (unlikely(be32_to_cpu(filesec_ptr->fsec_magic) !=
+				HFSPLUS_FILESEC_MAGIC)) {
+		printk(KERN_ERR "hfs: invalid fsec_magic\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	known_size += acl_record_hdr_size;
+
+	if (unlikely(size < known_size)) {
+		printk(KERN_ERR "hfs: acl record hdr corrupted\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	acl_record_ptr = &(filesec_ptr->fsec_acl);
+	acl_entries_count = be32_to_cpu(acl_record_ptr->acl_entrycount);
+	acl_entries_size =
+		acl_entries_count * sizeof(struct hfsplus_acl_entry);
+	known_size += acl_entries_size;
+
+	if (unlikely(size < known_size)) {
+		printk(KERN_ERR "hfs: acl entries array corrupted\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return acl_record_ptr;
+}
+
+static unsigned char empty_guid[HFSPLUS_GUID_SIZE] = {0};
+
+static inline int empty_ace(const struct hfsplus_acl_entry *ace)
+{
+	return memcmp(empty_guid, ace->ace_applicable, HFSPLUS_GUID_SIZE) == 0;
+}
+
+#define IS_GROUP_FINGERPRINT(ace_applicable) \
+	(memcmp(ace_applicable, \
+		hfsplus_group_fingerprint, HFSPLUS_FINGERPRINT_SIZE) == 0)
+
+#define IS_USER_FINGERPRINT(ace_applicable) \
+	(memcmp(ace_applicable, \
+		hfsplus_user_fingerprint, HFSPLUS_FINGERPRINT_SIZE) == 0)
+
+static inline int is_acl_user_obj(const struct hfsplus_acl_entry *ace)
+{
+	if (!IS_GROUP_FINGERPRINT(ace->ace_applicable) &&
+			!IS_USER_FINGERPRINT(ace->ace_applicable) &&
+			!empty_ace(ace)) {
+		dprint(DBG_ACL_MOD, "[%s]: found user obj\n", __func__);
+		return 1;
+	} else
+		return 0;
+}
+
+static int is_acl_group_obj(struct inode *inode,
+				const struct hfsplus_acl_entry *ace)
+{
+	int size = HFSPLUS_FINGERPRINT_SIZE;
+	__be32 *raw_gid_ptr;
+
+	if (IS_GROUP_FINGERPRINT(ace->ace_applicable)) {
+		raw_gid_ptr = (__be32 *)&ace->ace_applicable[size];
+		if (be32_to_cpu(*raw_gid_ptr) == i_gid_read(inode)) {
+			dprint(DBG_ACL_MOD, "[%s]: found group obj\n",
+								__func__);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int is_acl_other(struct inode *inode,
+				const struct hfsplus_acl_entry *ace)
+{
+	int size = HFSPLUS_FINGERPRINT_SIZE;
+	__be32 *raw_id_ptr;
+
+	if (IS_GROUP_FINGERPRINT(ace->ace_applicable)) {
+		raw_id_ptr = (__be32 *)&ace->ace_applicable[size];
+		if (be32_to_cpu(*raw_id_ptr) == HFSPLUS_EVERYBODY_ID) {
+			dprint(DBG_ACL_MOD, "[%s]: found other\n", __func__);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int is_acl_user(const struct hfsplus_acl_entry *ace)
+{
+	int size = HFSPLUS_FINGERPRINT_SIZE;
+	__be32 *raw_id_ptr;
+
+	if (IS_USER_FINGERPRINT(ace->ace_applicable)) {
+		raw_id_ptr = (__be32 *)&ace->ace_applicable[size];
+		if (be32_to_cpu(*raw_id_ptr) != HFSPLUS_EVERYBODY_ID) {
+			dprint(DBG_ACL_MOD, "[%s]: %#x\n", __func__,
+						be32_to_cpu(*raw_id_ptr));
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int is_acl_group(const struct hfsplus_acl_entry *ace)
+{
+	int size = HFSPLUS_FINGERPRINT_SIZE;
+	__be32 *raw_id_ptr;
+
+	if (IS_GROUP_FINGERPRINT(ace->ace_applicable)) {
+		raw_id_ptr = (__be32 *)&ace->ace_applicable[size];
+		if (be32_to_cpu(*raw_id_ptr) != HFSPLUS_EVERYBODY_ID) {
+			dprint(DBG_ACL_MOD, "[%s]: %#x\n", __func__,
+						be32_to_cpu(*raw_id_ptr));
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static inline void allow_bits(struct posix_ace_state *astate, u32 rights)
+{
+	astate->allow |= rights & ~astate->deny;
+}
+
+static inline void deny_bits(struct posix_ace_state *astate, u32 rights)
+{
+	astate->deny |= rights & ~astate->allow;
+}
+
+static void allow_bits_array(struct posix_ace_state_array *a, u32 rights)
+{
+	int i;
+
+	for (i = 0; i < a->n; i++)
+		allow_bits(&a->aces[i].perms, rights);
+}
+
+static void deny_bits_array(struct posix_ace_state_array *a, u32 rights)
+{
+	int i;
+
+	for (i = 0; i < a->n; i++)
+		deny_bits(&a->aces[i].perms, rights);
+}
+
+static int find_uid(struct posix_acl_state *state,
+			struct posix_ace_state_array *a,
+			const struct hfsplus_acl_entry *ace)
+{
+	int size = HFSPLUS_FINGERPRINT_SIZE;
+	__be32 *raw_id_ptr;
+	uid_t uid;
+	int i;
+
+	if (IS_GROUP_FINGERPRINT(ace->ace_applicable) ||
+			IS_USER_FINGERPRINT(ace->ace_applicable)) {
+		raw_id_ptr = (__be32 *)&ace->ace_applicable[size];
+		uid = be32_to_cpu(*raw_id_ptr);
+		dprint(DBG_ACL_MOD, "[%s]: uid %#x\n", __func__, uid);
+	} else {
+		dprint(DBG_ACL_MOD, "[%s]: can't convert uid\n", __func__);
+		return -1;
+	}
+
+	for (i = 0; i < a->n; i++) {
+		if (a->aces[i].uid == uid) {
+			dprint(DBG_ACL_MOD, "[%s]: index %d\n", __func__, i);
+			return i;
+		}
+	}
+	/* Not found: */
+	a->n++;
+	a->aces[i].uid = uid;
+	a->aces[i].perms.allow = state->everyone.allow;
+	a->aces[i].perms.deny  = state->everyone.deny;
+
+	dprint(DBG_ACL_MOD, "[%s]: index %d\n", __func__, i);
+	return i;
+}
+
+static void hfsplus_process_one_ace(struct inode *inode,
+					struct posix_acl_state *state,
+					const struct hfsplus_acl_entry *ace)
+{
+	u32 ace_flags = be32_to_cpu(ace->ace_flags);
+	u32 ace_type = ace_flags & HFSPLUS_ACE_KINDMASK;
+	u32 rights = be32_to_cpu(ace->ace_rights);
+	int i;
+
+	dprint_hexdump(DBG_ACL_MOD, "ace_applicable: ",
+			ace->ace_applicable, HFSPLUS_GUID_SIZE);
+	dprint(DBG_ACL_MOD, "[%s]: ace_flags %#x, ace_rights %#x\n",
+			__func__, ace_flags, rights);
+
+	state->empty = 0;
+
+	if (is_acl_user_obj(ace)) {
+		if (ace_type == HFSPLUS_ACE_PERMIT)
+			allow_bits(&state->owner, rights);
+		else
+			deny_bits(&state->owner, rights);
+	} else if (is_acl_group_obj(inode, ace)) {
+		if (ace_type == HFSPLUS_ACE_PERMIT)
+			allow_bits(&state->group, rights);
+		else {
+			deny_bits(&state->group, rights);
+			rights = state->group.deny;
+			deny_bits(&state->owner, rights);
+			deny_bits(&state->everyone, rights);
+			deny_bits_array(state->users, rights);
+			deny_bits_array(state->groups, rights);
+		}
+	} else if (is_acl_other(inode, ace)) {
+		if (ace_type == HFSPLUS_ACE_PERMIT) {
+			allow_bits(&state->owner, rights);
+			allow_bits(&state->group, rights);
+			allow_bits(&state->other, rights);
+			allow_bits(&state->everyone, rights);
+			allow_bits_array(state->users, rights);
+			allow_bits_array(state->groups, rights);
+		} else {
+			deny_bits(&state->owner, rights);
+			deny_bits(&state->group, rights);
+			deny_bits(&state->other, rights);
+			deny_bits(&state->everyone, rights);
+			deny_bits_array(state->users, rights);
+			deny_bits_array(state->groups, rights);
+		}
+	} else if (is_acl_user(ace)) {
+		i = find_uid(state, state->users, ace);
+		if (i >= 0) {
+			/* ACL_USER */
+			if (ace_type == HFSPLUS_ACE_PERMIT)
+				allow_bits(&state->users->aces[i].perms,
+						rights);
+			else {
+				deny_bits(&state->users->aces[i].perms, rights);
+				rights = state->users->aces[i].perms.deny;
+				deny_bits(&state->owner, rights);
+			}
+		}
+	} else if (is_acl_group(ace)) {
+		i = find_uid(state, state->groups, ace);
+		if (i >= 0) {
+			/* ACL_GROUP */
+			if (ace_type == HFSPLUS_ACE_PERMIT)
+				allow_bits(&state->groups->aces[i].perms,
+						rights);
+			else {
+				deny_bits(&state->groups->aces[i].perms,
+						rights);
+				rights = state->groups->aces[i].perms.deny;
+				deny_bits(&state->owner, rights);
+				deny_bits(&state->group, rights);
+				deny_bits(&state->everyone, rights);
+				deny_bits_array(state->users, rights);
+				deny_bits_array(state->groups, rights);
+			}
+		}
+	}
+}
+
+static inline int check_deny(u32 rights, int isowner)
+{
+	if (rights & (HFSPLUS_VNODE_READ_ATTRIBUTES |
+			HFSPLUS_VNODE_READ_EXTATTRIBUTES |
+			HFSPLUS_VNODE_READ_SECURITY)) {
+		if (rights & HFSPLUS_VNODE_READ_ATTRIBUTES)
+			printk(KERN_WARNING "hfs: can't deny read attr\n");
+		if (rights & HFSPLUS_VNODE_READ_EXTATTRIBUTES)
+			printk(KERN_WARNING "hfs: can't deny read xattr\n");
+		if (rights & HFSPLUS_VNODE_READ_SECURITY)
+			printk(KERN_WARNING "hfs: can't deny read security\n");
+		return -EINVAL;
+	}
+	if (!isowner)
+		return 0;
+	if (rights & (HFSPLUS_VNODE_WRITE_ATTRIBUTES |
+			HFSPLUS_VNODE_WRITE_EXTATTRIBUTES |
+			HFSPLUS_VNODE_WRITE_SECURITY)) {
+		if (rights & HFSPLUS_VNODE_WRITE_ATTRIBUTES)
+			printk(KERN_WARNING "hfs: can't deny write attr\n");
+		if (rights & HFSPLUS_VNODE_WRITE_EXTATTRIBUTES)
+			printk(KERN_WARNING "hfs: can't deny write xattr\n");
+		if (rights & HFSPLUS_VNODE_WRITE_SECURITY)
+			printk(KERN_WARNING "hfs: can't deny write security\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void low_mode_from_hfsplus(struct inode *inode,
+					u32 perm,
+					unsigned short *mode)
+{
+	u32 write_mode = HFSPLUS_VNODE_WRITE_DATA;
+
+	if (S_ISDIR(inode->i_mode))
+		write_mode |= HFSPLUS_VNODE_DELETE_CHILD;
+	*mode = 0;
+	if ((perm & HFSPLUS_VNODE_READ_DATA) == HFSPLUS_VNODE_READ_DATA)
+		*mode |= ACL_READ;
+	if ((perm & write_mode) == write_mode)
+		*mode |= ACL_WRITE;
+	if ((perm & HFSPLUS_VNODE_EXECUTE) == HFSPLUS_VNODE_EXECUTE)
+		*mode |= ACL_EXECUTE;
+
+	dprint(DBG_ACL_MOD, "[%s]: perm %#x, mode %#x\n",
+					__func__, perm, *mode);
+}
+
+static inline void add_to_mask(struct posix_acl_state *state,
+				struct posix_ace_state *astate)
+{
+	state->mask.allow |= astate->allow;
+}
+
+static struct posix_acl *hfsplus_posix_state_to_acl(struct inode *inode,
+					struct user_namespace *user_ns,
+					struct posix_acl_state *state,
+					int type)
+{
+	int err = 0;
+	struct posix_acl_entry *pace;
+	struct posix_acl *pacl;
+	int nace;
+	int i = 0;
+
+	/*
+	 * ACLs with no ACEs are treated differently in the inheritable
+	 * and effective cases: when there are no inheritable ACEs, we
+	 * set a zero-length default posix acl.
+	 */
+	if (state->empty && (type == ACL_TYPE_DEFAULT)) {
+		pacl = posix_acl_alloc(0, GFP_KERNEL);
+		return pacl ? pacl : ERR_PTR(-ENOMEM);
+	}
+
+	/*
+	 * When there are no effective ACEs, the following will end
+	 * up setting a 3-element effective posix ACL with all
+	 * permissions zero.
+	 */
+	nace = 4 + state->users->n + state->groups->n;
+	pacl = posix_acl_alloc(nace, GFP_KERNEL);
+	if (unlikely(!pacl))
+		return ERR_PTR(-ENOMEM);
+
+	pace = pacl->a_entries;
+	pace->e_tag = ACL_USER_OBJ;
+	err = check_deny(state->owner.deny, 1);
+	if (err)
+		goto out_err;
+	low_mode_from_hfsplus(inode, state->owner.allow, &pace->e_perm);
+	pace->e_id = ACL_UNDEFINED_ID;
+
+	for (i = 0; i < state->users->n; i++) {
+		pace++;
+		pace->e_tag = ACL_USER;
+		err = check_deny(state->users->aces[i].perms.deny, 0);
+		if (err)
+			goto out_err;
+		low_mode_from_hfsplus(inode,
+					state->users->aces[i].perms.allow,
+					&pace->e_perm);
+		pace->e_uid = make_kuid(user_ns, state->users->aces[i].uid);
+		if (!uid_valid(pace->e_uid))
+			goto out_err;
+		add_to_mask(state, &state->users->aces[i].perms);
+	}
+
+	pace++;
+	pace->e_tag = ACL_GROUP_OBJ;
+	err = check_deny(state->group.deny, 0);
+	if (err)
+		goto out_err;
+	low_mode_from_hfsplus(inode, state->group.allow, &pace->e_perm);
+	pace->e_id = ACL_UNDEFINED_ID;
+	add_to_mask(state, &state->group);
+
+	for (i = 0; i < state->groups->n; i++) {
+		pace++;
+		pace->e_tag = ACL_GROUP;
+		err = check_deny(state->groups->aces[i].perms.deny, 0);
+		if (err)
+			goto out_err;
+		low_mode_from_hfsplus(inode,
+					state->groups->aces[i].perms.allow,
+					&pace->e_perm);
+		pace->e_gid = make_kgid(user_ns, state->groups->aces[i].uid);
+		if (!gid_valid(pace->e_gid))
+			goto out_err;
+		add_to_mask(state, &state->groups->aces[i].perms);
+	}
+
+	pace++;
+	pace->e_tag = ACL_MASK;
+	low_mode_from_hfsplus(inode, state->mask.allow, &pace->e_perm);
+	pace->e_id = ACL_UNDEFINED_ID;
+
+	pace++;
+	pace->e_tag = ACL_OTHER;
+	err = check_deny(state->other.deny, 0);
+	if (err)
+		goto out_err;
+	low_mode_from_hfsplus(inode, state->other.allow, &pace->e_perm);
+	pace->e_id = ACL_UNDEFINED_ID;
+
+	return pacl;
+
+out_err:
+	posix_acl_release(pacl);
+	return ERR_PTR(err);
+}
+
+static void sort_pacl_range(struct posix_acl *pacl, int start, int end)
+{
+	int sorted = 0, i;
+	struct posix_acl_entry tmp;
+
+	/*
+	 * We just do a bubble sort; easy to do in place, and we're not
+	 * expecting acl's to be long enough to justify anything more.
+	 */
+	while (!sorted) {
+		sorted = 1;
+		for (i = start; i < end; i++) {
+			if (pacl->a_entries[i].e_id
+					> pacl->a_entries[i+1].e_id) {
+				sorted = 0;
+				tmp = pacl->a_entries[i];
+				pacl->a_entries[i] = pacl->a_entries[i+1];
+				pacl->a_entries[i+1] = tmp;
+			}
+		}
+	}
+}
+
+static void sort_pacl(struct posix_acl *pacl)
+{
+	/*
+	 * The posix_acl_valid requires that users and groups be in order
+	 * by uid/gid.
+	 */
+	int i, j;
+
+	if (pacl->a_count <= 4)
+		return; /* no users or groups */
+	i = 1;
+	while (pacl->a_entries[i].e_tag == ACL_USER)
+		i++;
+	sort_pacl_range(pacl, 1, i-1);
+
+	BUG_ON(pacl->a_entries[i].e_tag != ACL_GROUP_OBJ);
+	j = ++i;
+	while (pacl->a_entries[j].e_tag == ACL_GROUP)
+		j++;
+	sort_pacl_range(pacl, i, j-1);
+	return;
+}
+
+static uid_t extract_uid_from_ace(struct hfsplus_acl_entry *ace)
+{
+	int size = HFSPLUS_FINGERPRINT_SIZE;
+	__be32 *raw_id_ptr;
+	uid_t uid;
+
+	if (IS_GROUP_FINGERPRINT(ace->ace_applicable) ||
+			IS_USER_FINGERPRINT(ace->ace_applicable)) {
+		raw_id_ptr = (__be32 *)&ace->ace_applicable[size];
+		uid = be32_to_cpu(*raw_id_ptr);
+	} else
+		return ACL_UNDEFINED_ID;
+
+	return uid;
+}
+
+/* It is expected that ace is not empty */
+static int compare_ace_type(struct hfsplus_acl_entry *left_ace,
+				struct hfsplus_acl_entry *right_ace)
+{
+	u32 left_ace_flags = be32_to_cpu(left_ace->ace_flags);
+	u32 left_ace_type = left_ace_flags & HFSPLUS_ACE_KINDMASK;
+	u32 right_ace_flags = be32_to_cpu(right_ace->ace_flags);
+	u32 right_ace_type = right_ace_flags & HFSPLUS_ACE_KINDMASK;
+
+	if (left_ace_type == HFSPLUS_ACE_DENY &&
+			right_ace_type == HFSPLUS_ACE_DENY)
+		return 0;
+	else if (left_ace_type == HFSPLUS_ACE_PERMIT &&
+			right_ace_type == HFSPLUS_ACE_PERMIT)
+		return 0;
+	else if (left_ace_type == HFSPLUS_ACE_DENY)
+		return -1;
+	else if (left_ace_type == HFSPLUS_ACE_PERMIT) {
+		if (right_ace_type == HFSPLUS_ACE_DENY)
+			return 1;
+		else
+			return -1;
+	} else if (right_ace_type == HFSPLUS_ACE_DENY ||
+			right_ace_type == HFSPLUS_ACE_PERMIT)
+		return -1;
+
+	return 0;
+}
+
+static int compare_ace(struct inode *inode,
+			struct hfsplus_acl_entry *left_ace,
+			struct hfsplus_acl_entry *right_ace)
+{
+	uid_t left_uid, right_uid;
+
+	if (empty_ace(left_ace) && empty_ace(right_ace))
+		return 0;
+
+	if (is_acl_user_obj(left_ace)) {
+		if (is_acl_user_obj(right_ace))
+			return compare_ace_type(left_ace, right_ace);
+		else
+			return -1;
+	} else if (is_acl_user_obj(right_ace))
+		return 1;
+
+	if (is_acl_group_obj(inode, left_ace)) {
+		if (is_acl_group_obj(inode, right_ace))
+			return compare_ace_type(left_ace, right_ace);
+		else
+			return -1;
+	} else if (is_acl_group_obj(inode, right_ace))
+		return 1;
+
+	if (is_acl_other(inode, left_ace)) {
+		if (is_acl_other(inode, right_ace))
+			return compare_ace_type(left_ace, right_ace);
+		else
+			return -1;
+	} else if (is_acl_other(inode, right_ace))
+		return 1;
+
+	left_uid = extract_uid_from_ace(left_ace);
+	right_uid = extract_uid_from_ace(right_ace);
+
+	/* ACL_UNDEFINED_ID is greater always */
+	if (left_uid == ACL_UNDEFINED_ID) {
+		if (right_uid == ACL_UNDEFINED_ID)
+			return 0;
+		else
+			return 1;
+	} else if (right_uid == ACL_UNDEFINED_ID)
+		return 1;
+
+	if (left_uid == right_uid)
+		return compare_ace_type(left_ace, right_ace);
+
+	return left_uid < right_uid ? -1 : 1;
+}
+
+/*
+ * Insertion sort.
+ * Algorithm of the method is based on psevdocode from:
+ * http://en.wikipedia.org/wiki/Insertion_sort
+ */
+static int sort_hfsplus_ace(struct inode *inode,
+				struct hfsplus_filesec *filesec,
+				ssize_t size)
+{
+	struct hfsplus_acl_entry *ace = filesec->fsec_acl.acl_ace;
+	struct hfsplus_acl_entry temp_buf;
+	int entries_count = be32_to_cpu(filesec->fsec_acl.acl_entrycount);
+	ssize_t calculated_size = sizeof(struct hfsplus_filesec) +
+			(entries_count * sizeof(struct hfsplus_acl_entry));
+	int i;
+
+	if (be32_to_cpu(filesec->fsec_magic) != HFSPLUS_FILESEC_MAGIC)
+		return -EINVAL;
+
+	if (entries_count == 0)
+		return 0;
+
+	if (calculated_size != size)
+		return -EINVAL;
+
+	for (i = 1; i < entries_count; i++) {
+		int hole_index = i;
+		memcpy(&temp_buf, &ace[i], sizeof(struct hfsplus_acl_entry));
+
+		while (hole_index > 0 &&
+				(compare_ace(inode,
+						&ace[hole_index - 1],
+						&temp_buf) > 0)) {
+			/* move hole to next smaller index */
+			memcpy(&ace[hole_index], &ace[hole_index - 1],
+					sizeof(struct hfsplus_acl_entry));
+			hole_index -= 1;
+		}
+
+		memcpy(&ace[hole_index], &temp_buf,
+				sizeof(struct hfsplus_acl_entry));
+	}
+
+	return 0;
+}
+
+struct posix_acl *hfsplus_posix_acl_from_xattr(struct inode *inode,
+					struct user_namespace *user_ns,
+					void *value,
+					size_t size,
+					int type)
+{
+	int err;
+	struct posix_acl *pacl = NULL, *dpacl = NULL;
+	struct hfsplus_filesec *filesec =
+			(struct hfsplus_filesec *)value;
+	const struct hfsplus_acl_record *raw_acl_rec;
+	struct posix_acl_state effective_acl_state, default_acl_state;
+	const struct hfsplus_acl_entry *ace;
+	u32 acl_entries_count = 0;
+	ssize_t calculated_size = 0;
+
+	if (!value)
+		return NULL;
+
+	if (type != ACL_TYPE_ACCESS && type != ACL_TYPE_DEFAULT)
+		return NULL;
+
+	raw_acl_rec = hfsplus_acl_record_from_xattr(value, size);
+	if (unlikely(IS_ERR(raw_acl_rec)))
+		return NULL;
+
+	acl_entries_count = be32_to_cpu(raw_acl_rec->acl_entrycount);
+
+	calculated_size = sizeof(struct hfsplus_filesec) +
+		(acl_entries_count * sizeof(struct hfsplus_acl_entry));
+	err = sort_hfsplus_ace(inode, filesec, calculated_size);
+	if (unlikely(err))
+		return ERR_PTR(err);
+
+	err = init_state(&effective_acl_state, acl_entries_count);
+	if (unlikely(err))
+		return ERR_PTR(err);
+	err = init_state(&default_acl_state, acl_entries_count);
+	if (unlikely(err))
+		goto free_effective_acl_state;
+
+	err = -EINVAL;
+	for (ace = raw_acl_rec->acl_ace;
+			ace < raw_acl_rec->acl_ace + acl_entries_count;
+					ace++) {
+		u32 ace_flags = be32_to_cpu(ace->ace_flags);
+		u32 ace_type = ace_flags & HFSPLUS_ACE_KINDMASK;
+		ace_flags &= ~HFSPLUS_ACE_KINDMASK;
+
+		if (ace_type != HFSPLUS_ACE_PERMIT &&
+				ace_type != HFSPLUS_ACE_DENY)
+			goto free_default_acl_state;
+
+		if (ace_flags & ~HFSPLUS_ACE_INHERIT_CONTROL_FLAGS)
+			goto free_default_acl_state;
+
+		if ((ace_flags & HFSPLUS_ACE_INHERIT_CONTROL_FLAGS) == 0) {
+			hfsplus_process_one_ace(inode,
+						&effective_acl_state, ace);
+			continue;
+		}
+
+		if (!S_ISDIR(inode->i_mode))
+			goto free_default_acl_state;
+
+		hfsplus_process_one_ace(inode, &default_acl_state, ace);
+
+		if (!(ace_flags & HFSPLUS_ACE_ONLY_INHERIT))
+			hfsplus_process_one_ace(inode,
+						&effective_acl_state, ace);
+	}
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		pacl = hfsplus_posix_state_to_acl(inode,
+						  user_ns,
+						  &effective_acl_state,
+						  type);
+		if (unlikely(IS_ERR(pacl))) {
+			err = PTR_ERR(pacl);
+			pacl = NULL;
+			goto free_default_acl_state;
+		}
+		sort_pacl(pacl);
+		break;
+
+	case ACL_TYPE_DEFAULT:
+		dpacl = hfsplus_posix_state_to_acl(inode,
+						   user_ns,
+						   &default_acl_state,
+						   type);
+		if (unlikely(IS_ERR(dpacl))) {
+			err = PTR_ERR(dpacl);
+			dpacl = NULL;
+			goto free_default_acl_state;
+		}
+		sort_pacl(dpacl);
+		break;
+	}
+
+	err = 0;
+
+free_default_acl_state:
+	free_state(&effective_acl_state);
+
+free_effective_acl_state:
+	free_state(&default_acl_state);
+
+	if (err)
+		goto failed_conversion;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		return pacl;
+
+	case ACL_TYPE_DEFAULT:
+		return dpacl;
+	}
+
+failed_conversion:
+	return ERR_PTR(err);
+}
+
+struct posix_acl_summary {
+	unsigned short owner;
+	unsigned short users;
+	unsigned short group;
+	unsigned short groups;
+	unsigned short other;
+	unsigned short mask;
+};
+
+static void summarize_posix_acl(struct posix_acl *acl,
+				struct posix_acl_summary *pas)
+{
+	struct posix_acl_entry *pa, *pe;
+
+	memset(pas, 0, sizeof(*pas));
+	pas->mask = 07;
+
+	FOREACH_ACL_ENTRY(pa, acl, pe) {
+		switch (pa->e_tag) {
+		case ACL_USER_OBJ:
+			pas->owner = pa->e_perm;
+			break;
+		case ACL_GROUP_OBJ:
+			pas->group = pa->e_perm;
+			break;
+		case ACL_USER:
+			pas->users |= pa->e_perm;
+			break;
+		case ACL_GROUP:
+			pas->groups |= pa->e_perm;
+			break;
+		case ACL_OTHER:
+			pas->other = pa->e_perm;
+			break;
+		case ACL_MASK:
+			pas->mask = pa->e_perm;
+			break;
+		}
+	}
+	/* We'll only care about effective permissions */
+	pas->users &= pas->mask;
+	pas->group &= pas->mask;
+	pas->groups &= pas->mask;
+
+	dprint(DBG_ACL_MOD, "[%s]: owner %#x\n", __func__, pas->owner);
+	dprint(DBG_ACL_MOD, "[%s]: users %#x\n", __func__, pas->users);
+	dprint(DBG_ACL_MOD, "[%s]: group %#x\n", __func__, pas->group);
+	dprint(DBG_ACL_MOD, "[%s]: groups %#x\n", __func__, pas->groups);
+	dprint(DBG_ACL_MOD, "[%s]: other %#x\n", __func__, pas->other);
+	dprint(DBG_ACL_MOD, "[%s]: mask %#x\n", __func__, pas->mask);
+}
+
+static u32 mask_from_posix(struct inode *inode,
+				unsigned short perm,
+				int is_owner)
+{
+	int mask = HFSPLUS_VNODE_ANYONE_MODE;
+
+	if (is_owner)
+		mask |= HFSPLUS_VNODE_OWNER_MODE;
+	if (perm & ACL_READ)
+		mask |= HFSPLUS_VNODE_READ_DATA;
+	if (perm & ACL_WRITE)
+		mask |= HFSPLUS_VNODE_WRITE_MODE;
+	if ((perm & ACL_WRITE) && S_ISDIR(inode->i_mode))
+		mask |= HFSPLUS_VNODE_DELETE_CHILD;
+	if (perm & ACL_EXECUTE)
+		mask |= HFSPLUS_VNODE_EXECUTE;
+
+	dprint(DBG_ACL_MOD, "[%s]: perm %#x, mask %#x\n", __func__, perm, mask);
+
+	return mask;
+}
+
+static u32 deny_mask_from_posix(struct inode *inode,
+				unsigned short perm)
+{
+	u32 mask = 0;
+
+	if (perm & ACL_READ)
+		mask |= HFSPLUS_VNODE_READ_DATA;
+	if (perm & ACL_WRITE)
+		mask |= HFSPLUS_VNODE_WRITE_MODE;
+	if ((perm & ACL_WRITE) && S_ISDIR(inode->i_mode))
+		mask |= HFSPLUS_VNODE_DELETE_CHILD;
+	if (perm & ACL_EXECUTE)
+		mask |= HFSPLUS_VNODE_EXECUTE;
+
+	dprint(DBG_ACL_MOD, "[%s]: perm %#x, mask %#x\n", __func__, perm, mask);
+
+	return mask;
+}
+
+#define HFSPLUS_ACE_SET_OWNER_USER_ID(ace_applicable) \
+	do { \
+		uuid_be generated_uuid; \
+		uuid_be_gen(&generated_uuid); \
+		memcpy(ace_applicable, \
+			generated_uuid.b, sizeof(generated_uuid)); \
+	} while (0)
+
+#define HFSPLUS_ACE_SET_USER_ID(ace_applicable, id) \
+	do { \
+		memset(ace_applicable, 0, HFSPLUS_GUID_SIZE); \
+		memcpy(&ace_applicable[0], \
+			&hfsplus_user_fingerprint[0], \
+			HFSPLUS_FINGERPRINT_SIZE); \
+		(*((__be32 *)&ace_applicable[HFSPLUS_FINGERPRINT_SIZE]) = \
+			cpu_to_be32(id)); \
+	} while (0)
+
+#define HFSPLUS_ACE_SET_GROUP_ID(ace_applicable, id) \
+	do { \
+		memset(ace_applicable, 0, HFSPLUS_GUID_SIZE); \
+		memcpy(&ace_applicable[0], \
+			&hfsplus_group_fingerprint[0], \
+			HFSPLUS_FINGERPRINT_SIZE); \
+		(*((__be32 *)&ace_applicable[HFSPLUS_FINGERPRINT_SIZE]) = \
+			cpu_to_be32(id)); \
+	} while (0)
+
+#define HFSPLUS_COMPOSE_DENY_ACE(ace, ace_applicable, eflag, rights) \
+	do { \
+		memcpy(ace->ace_applicable, \
+				ace_applicable, HFSPLUS_GUID_SIZE); \
+		ace->ace_flags = cpu_to_be32(HFSPLUS_ACE_DENY | eflag); \
+		ace->ace_rights = cpu_to_be32(rights); \
+		dprint_hexdump(DBG_ACL_MOD, "ace_applicable: ", \
+				ace->ace_applicable, HFSPLUS_GUID_SIZE); \
+		dprint(DBG_ACL_MOD, \
+			"[%s]: ace_flags %#x, ace_rights %#x\n", \
+				__func__, be32_to_cpu(ace->ace_flags), \
+				rights); \
+	} while (0)
+
+#define HFSPLUS_COMPOSE_PERMIT_ACE(ace, ace_applicable, eflag, rights) \
+	do { \
+		memcpy(ace->ace_applicable, \
+				ace_applicable, HFSPLUS_GUID_SIZE); \
+		ace->ace_flags = cpu_to_be32(HFSPLUS_ACE_PERMIT | eflag); \
+		ace->ace_rights = cpu_to_be32(rights); \
+		dprint_hexdump(DBG_ACL_MOD, "ace_applicable: ", \
+				ace->ace_applicable, HFSPLUS_GUID_SIZE); \
+		dprint(DBG_ACL_MOD, \
+			"[%s]: ace_flags %#x, ace_rights %#x\n", \
+				__func__, be32_to_cpu(ace->ace_flags), \
+				rights); \
+	} while (0)
+
+static int hfsplus_compose_filesec_from_posix_acl(struct inode *inode,
+						struct user_namespace *user_ns,
+						struct posix_acl *acl,
+						struct hfsplus_filesec *filesec,
+						size_t allocated_size,
+						int type)
+{
+	int err;
+	struct posix_acl_entry *pa, *group_owner_entry;
+	struct hfsplus_acl_record *fsec_acl = &(filesec->fsec_acl);
+	struct hfsplus_acl_entry *ace = fsec_acl->acl_ace;
+	struct posix_acl_summary pas;
+	unsigned short deny;
+	int eflag = ((type == ACL_TYPE_DEFAULT) ?
+			HFSPLUS_ACE_INHERIT_CONTROL_FLAGS : 0);
+	u32 ace_entries = 0;
+	u8 ace_applicable[HFSPLUS_GUID_SIZE];
+	size_t calculated_size = 0;
+	size_t filesec_hdr_size = sizeof(struct hfsplus_filesec);
+	size_t ace_size = sizeof(struct hfsplus_acl_entry);
+
+	BUG_ON(acl->a_count < 3);
+	summarize_posix_acl(acl, &pas);
+	pa = acl->a_entries;
+
+	if ((calculated_size + filesec_hdr_size) > allocated_size)
+		return -ENOMEM;
+
+	memset(filesec, 0, sizeof(struct hfsplus_filesec));
+	filesec->fsec_magic = cpu_to_be32(HFSPLUS_FILESEC_MAGIC);
+	calculated_size += filesec_hdr_size;
+
+	/* We could deny everything not granted by the owner */
+	deny = ~pas.owner;
+	/*
+	 * but it is equivalent (and simpler) to deny only what is not
+	 * granted by later entries
+	 */
+	deny &= pas.users | pas.group | pas.groups | pas.other;
+
+	HFSPLUS_ACE_SET_OWNER_USER_ID(ace_applicable);
+
+	if (deny) {
+		dprint(DBG_ACL_MOD,
+			"[%s]: compose owner (%#x) deny ACE\n",
+			__func__, i_uid_read(inode));
+
+		if ((calculated_size + ace_size) > allocated_size)
+			return -ENOMEM;
+		HFSPLUS_COMPOSE_DENY_ACE(ace, ace_applicable, eflag,
+				deny_mask_from_posix(inode, deny));
+		ace++;
+		ace_entries++;
+		calculated_size += ace_size;
+	}
+
+	dprint(DBG_ACL_MOD,
+		"[%s]: compose owner (%#x) permit ACE\n",
+		__func__, i_uid_read(inode));
+
+	if ((calculated_size + ace_size) > allocated_size)
+		return -ENOMEM;
+	HFSPLUS_COMPOSE_PERMIT_ACE(ace, ace_applicable, eflag,
+				mask_from_posix(inode, pa->e_perm, 1));
+	ace++;
+	ace_entries++;
+	pa++;
+	calculated_size += ace_size;
+
+	while (pa->e_tag == ACL_USER) {
+		deny = ~(pa->e_perm & pas.mask);
+		deny &= pas.groups | pas.group | pas.other;
+
+		HFSPLUS_ACE_SET_USER_ID(ace_applicable,
+				from_kuid_munged(user_ns, pa->e_id));
+
+		if (deny) {
+			dprint(DBG_ACL_MOD,
+				"[%s]: compose user (%#x) deny ACE\n",
+				__func__, from_kuid_munged(user_ns, pa->e_id));
+
+			if ((calculated_size + ace_size) > allocated_size)
+				return -ENOMEM;
+			HFSPLUS_COMPOSE_DENY_ACE(ace, ace_applicable, eflag,
+					deny_mask_from_posix(inode, deny));
+			ace++;
+			ace_entries++;
+			calculated_size += ace_size;
+		}
+
+		dprint(DBG_ACL_MOD,
+				"[%s]: compose user (%#x) permit ACE\n",
+				__func__, from_kuid_munged(user_ns, pa->e_id));
+
+		if ((calculated_size + ace_size) > allocated_size)
+			return -ENOMEM;
+		HFSPLUS_COMPOSE_PERMIT_ACE(ace, ace_applicable, eflag,
+			mask_from_posix(inode, pa->e_perm & pas.mask, 0));
+		ace++;
+		ace_entries++;
+		pa++;
+		calculated_size += ace_size;
+	}
+
+	/* In the case of groups, we apply allow ACEs first, then deny ACEs,
+	 * since a user can be in more than one group.  */
+
+	/* allow ACEs */
+
+	group_owner_entry = pa;
+
+	HFSPLUS_ACE_SET_GROUP_ID(ace_applicable, i_gid_read(inode));
+
+	dprint(DBG_ACL_MOD,
+		"[%s]: compose group of owner (%#x) permit ACE\n",
+		__func__, i_gid_read(inode));
+
+	if ((calculated_size + ace_size) > allocated_size)
+		return -ENOMEM;
+	HFSPLUS_COMPOSE_PERMIT_ACE(ace, ace_applicable, eflag,
+			mask_from_posix(inode, pas.group, 0));
+	ace++;
+	ace_entries++;
+	pa++;
+	calculated_size += ace_size;
+
+	while (pa->e_tag == ACL_GROUP) {
+		HFSPLUS_ACE_SET_GROUP_ID(ace_applicable,
+					from_kgid_munged(user_ns, pa->e_id));
+
+		dprint(DBG_ACL_MOD,
+			"[%s]: compose group (%#x) permit ACE\n",
+			__func__, from_kgid_munged(user_ns, pa->e_id));
+
+		if ((calculated_size + ace_size) > allocated_size)
+			return -ENOMEM;
+		HFSPLUS_COMPOSE_PERMIT_ACE(ace, ace_applicable, eflag,
+			mask_from_posix(inode, pa->e_perm & pas.mask, 0));
+		ace++;
+		ace_entries++;
+		pa++;
+		calculated_size += ace_size;
+	}
+
+	/* deny ACEs */
+
+	pa = group_owner_entry;
+
+	deny = ~pas.group & pas.other;
+	if (deny) {
+		HFSPLUS_ACE_SET_GROUP_ID(ace_applicable, i_gid_read(inode));
+
+		dprint(DBG_ACL_MOD,
+			"[%s]: compose group of owner (%#x) deny ACE\n",
+			__func__, i_gid_read(inode));
+
+		if ((calculated_size + ace_size) > allocated_size)
+			return -ENOMEM;
+		HFSPLUS_COMPOSE_DENY_ACE(ace, ace_applicable, eflag,
+				deny_mask_from_posix(inode, deny));
+		ace++;
+		ace_entries++;
+		calculated_size += ace_size;
+	}
+	pa++;
+
+	while (pa->e_tag == ACL_GROUP) {
+		deny = ~(pa->e_perm & pas.mask);
+		deny &= pas.other;
+		if (deny) {
+			HFSPLUS_ACE_SET_GROUP_ID(ace_applicable,
+				from_kgid_munged(user_ns, pa->e_id));
+
+		dprint(DBG_ACL_MOD,
+			"[%s]: compose group (%#x) deny ACE\n",
+			__func__, from_kgid_munged(user_ns, pa->e_id));
+
+			if ((calculated_size + ace_size) > allocated_size)
+				return -ENOMEM;
+			HFSPLUS_COMPOSE_DENY_ACE(ace, ace_applicable, eflag,
+					deny_mask_from_posix(inode, deny));
+			ace++;
+			ace_entries++;
+			calculated_size += ace_size;
+		}
+		pa++;
+	}
+
+	if (pa->e_tag == ACL_MASK)
+		pa++;
+
+	HFSPLUS_ACE_SET_GROUP_ID(ace_applicable, HFSPLUS_EVERYBODY_ID);
+
+	dprint(DBG_ACL_MOD, "[%s]: compose EVERYBODY permit ACE\n", __func__);
+
+	if ((calculated_size + ace_size) > allocated_size)
+		return -ENOMEM;
+	HFSPLUS_COMPOSE_PERMIT_ACE(ace, ace_applicable, eflag,
+			mask_from_posix(inode, pa->e_perm, 0));
+	ace_entries++;
+	calculated_size += ace_size;
+
+	fsec_acl->acl_entrycount = cpu_to_be32(ace_entries);
+
+	err = sort_hfsplus_ace(inode, filesec, calculated_size);
+	if (err)
+		return err;
+
+	dprint_hexdump(DBG_ACL_MOD, "composed_filesec: ",
+				filesec, calculated_size);
+
+	return 0;
+}
+
+static struct hfsplus_filesec *hfsplus_posix_acl_to_filesec(struct inode *inode,
+						struct user_namespace *user_ns,
+						struct posix_acl *acl,
+						int type)
+{
+	int err = 0;
+	struct hfsplus_filesec *composed_filesec = NULL;
+
+	if (posix_acl_valid(acl) < 0)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * Mac OS X supports only inline xattr.
+	 * The online xattr can't be greater than
+	 * HFSPLUS_MAX_INLINE_DATA_SIZE (3802) bytes
+	 * in size.
+	 */
+	composed_filesec = kzalloc(HFSPLUS_MAX_INLINE_DATA_SIZE, GFP_KERNEL);
+	if (unlikely(!composed_filesec))
+		return ERR_PTR(-ENOMEM);
+
+	err = hfsplus_compose_filesec_from_posix_acl(inode, user_ns,
+						acl, composed_filesec,
+						HFSPLUS_MAX_INLINE_DATA_SIZE,
+						type);
+	if (err)
+		goto failed_conversion;
+
+	return composed_filesec;
+
+failed_conversion:
+	kfree(composed_filesec);
+	return ERR_PTR(err);
+}
+
+struct posix_acl *hfsplus_get_acl(struct inode *inode, int type)
+{
+	struct posix_acl *acl;
+	char *xattr_name;
+	char *value = NULL;
+	ssize_t size;
+
+	acl = get_cached_acl(inode, type);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+	case ACL_TYPE_DEFAULT:
+		xattr_name = HFSPLUS_XATTR_ACL_NAME;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	size = __hfsplus_getxattr(inode, xattr_name, NULL, 0);
+
+	if (size > 0) {
+		value = kzalloc(size, GFP_NOFS);
+		if (unlikely(!value))
+			return ERR_PTR(-ENOMEM);
+		size = __hfsplus_getxattr(inode, xattr_name, value, size);
+	}
+
+	if (size > 0)
+		acl = hfsplus_posix_acl_from_xattr(inode, &init_user_ns,
+							value, size, type);
+	else if (size == -ENODATA)
+		acl = NULL;
+	else
+		acl = ERR_PTR(size);
+
+	kfree(value);
+
+	if (!IS_ERR(acl))
+		set_cached_acl(inode, type, acl);
+
+	return acl;
+}
+
+static int hfsplus_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+{
+	int err;
+	char *xattr_name = HFSPLUS_XATTR_ACL_NAME;
+	struct hfsplus_filesec *filesec = NULL;
+	size_t size = 0;
+	size_t ace_size = sizeof(struct hfsplus_acl_entry);
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		if (acl) {
+			err = posix_acl_equiv_mode(acl, &inode->i_mode);
+			if (err < 0)
+				return err;
+		}
+		err = 0;
+		break;
+
+	case ACL_TYPE_DEFAULT:
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EACCES : 0;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (acl) {
+		filesec = hfsplus_posix_acl_to_filesec(inode, &init_user_ns,
+							acl, type);
+		if (unlikely(!filesec)) {
+			err = -ENOMEM;
+			goto end_set_acl;
+		} else if (IS_ERR(filesec)) {
+			err = PTR_ERR(filesec);
+			goto end_set_acl;
+		}
+
+		size = sizeof(struct hfsplus_filesec) +
+			(be32_to_cpu(filesec->fsec_acl.acl_entrycount) *
+				ace_size);
+		if (unlikely(size > HFSPLUS_MAX_INLINE_DATA_SIZE)) {
+			err = -ENOMEM;
+			goto end_set_acl;
+		}
+	}
+
+	err = __hfsplus_setxattr(inode, xattr_name, filesec, size, 0);
+
+end_set_acl:
+	kfree(filesec);
+
+	if (!err)
+		set_cached_acl(inode, type, acl);
+
+	return err;
+}
+
+int hfsplus_init_acl(struct inode *inode, struct inode *dir)
+{
+	int err = 0;
+	struct posix_acl *acl = NULL;
+
+	dprint(DBG_ACL_MOD, "[%s]: %ld, %ld\n",
+		__func__, inode->i_ino, dir->i_ino);
+
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
+	acl = hfsplus_get_acl(dir, ACL_TYPE_DEFAULT);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+
+	if (acl) {
+		if (S_ISDIR(inode->i_mode)) {
+			err = hfsplus_set_acl(inode, ACL_TYPE_DEFAULT, acl);
+			if (unlikely(err))
+				goto init_acl_cleanup;
+		}
+
+		err = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
+		if (unlikely(err < 0))
+			return err;
+
+		if (err > 0)
+			err = hfsplus_set_acl(inode, ACL_TYPE_ACCESS, acl);
+	} else
+		inode->i_mode &= ~current_umask();
+
+init_acl_cleanup:
+	posix_acl_release(acl);
+	return err;
+}
+
+int hfsplus_acl_chmod(struct inode *inode)
+{
+	int err;
+	struct posix_acl *acl;
+
+	dprint(DBG_ACL_MOD, "[%s]: %ld\n", __func__, inode->i_ino);
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	acl = hfsplus_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+
+	err = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	if (unlikely(err))
+		return err;
+
+	err = hfsplus_set_acl(inode, ACL_TYPE_ACCESS, acl);
+	posix_acl_release(acl);
+	return err;
+}
+
+static int hfsplus_xattr_get_acl(struct dentry *dentry,
+					const char *name,
+					void *buffer,
+					size_t size,
+					int type)
+{
+	int res = 0;
+	struct posix_acl *acl;
+
+	dprint(DBG_ACL_MOD, "[%s]: %ld, %p, %ld\n",
+		__func__, dentry->d_inode->i_ino, buffer, size);
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+
+	acl = hfsplus_get_acl(dentry->d_inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+
+	res = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
+	posix_acl_release(acl);
+
+	return res;
+}
+
+static int hfsplus_xattr_set_acl(struct dentry *dentry,
+					const char *name,
+					const void *value,
+					size_t size,
+					int flags,
+					int type)
+{
+	int err = 0;
+	struct inode *inode = dentry->d_inode;
+	struct posix_acl *acl = NULL;
+
+	dprint(DBG_ACL_MOD, "[%s]: %ld, %p, %ld\n",
+		__func__, inode->i_ino, value, size);
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
+	if (value) {
+		acl = posix_acl_from_xattr(&init_user_ns, value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		else if (acl) {
+			err = posix_acl_valid(acl);
+			if (err)
+				goto end_xattr_set_acl;
+		}
+	}
+
+	err = hfsplus_set_acl(inode, type, acl);
+
+end_xattr_set_acl:
+	posix_acl_release(acl);
+	return err;
+}
+
+static size_t hfsplus_xattr_list_acl(struct dentry *dentry, char *list,
+		size_t list_size, const char *name, size_t name_len, int type)
+{
+	/*
+	 * This method is not used.
+	 * It is used hfsplus_listxattr() instead of generic_listxattr().
+	 */
+	return -EOPNOTSUPP;
+}
+
+const struct xattr_handler hfsplus_xattr_acl_access_handler = {
+	.prefix	= POSIX_ACL_XATTR_ACCESS,
+	.flags	= ACL_TYPE_ACCESS,
+	.list	= hfsplus_xattr_list_acl,
+	.get	= hfsplus_xattr_get_acl,
+	.set	= hfsplus_xattr_set_acl,
+};
+
+const struct xattr_handler hfsplus_xattr_acl_default_handler = {
+	.prefix	= POSIX_ACL_XATTR_DEFAULT,
+	.flags	= ACL_TYPE_DEFAULT,
+	.list	= hfsplus_xattr_list_acl,
+	.get	= hfsplus_xattr_get_acl,
+	.set	= hfsplus_xattr_set_acl,
+};
diff -puN /dev/null fs/hfsplus/acl.h
--- /dev/null
+++ a/fs/hfsplus/acl.h
@@ -0,0 +1,90 @@
+/*
+ * linux/fs/hfsplus/acl.h
+ *
+ * Vyacheslav Dubeyko <slava@dubeyko.com>
+ *
+ * Handler for Posix Access Control Lists (ACLs) support.
+ */
+
+#include <linux/posix_acl_xattr.h>
+
+/* HFS+ Access Control List Entry (ACE) flags */
+#define HFSPLUS_ACE_KINDMASK		0xf
+#define HFSPLUS_ACE_PERMIT		1
+#define HFSPLUS_ACE_DENY		2
+#define HFSPLUS_ACE_AUDIT		3
+#define HFSPLUS_ACE_ALARM		4
+#define HFSPLUS_ACE_INHERITED		(1<<4)
+#define HFSPLUS_ACE_FILE_INHERIT	(1<<5)
+#define HFSPLUS_ACE_DIRECTORY_INHERIT	(1<<6)
+#define HFSPLUS_ACE_LIMIT_INHERIT	(1<<7)
+#define HFSPLUS_ACE_ONLY_INHERIT	(1<<8)
+#define HFSPLUS_ACE_SUCCESS		(1<<9)
+#define HFSPLUS_ACE_FAILURE		(1<<10)
+
+/* All flag bits controlling ACE inheritance */
+#define HFSPLUS_ACE_INHERIT_CONTROL_FLAGS \
+		(HFSPLUS_ACE_FILE_INHERIT | \
+		 HFSPLUS_ACE_DIRECTORY_INHERIT | \
+		 HFSPLUS_ACE_LIMIT_INHERIT | \
+		 HFSPLUS_ACE_ONLY_INHERIT)
+
+/* HFS+ Access Control List Entry (ACE) rights */
+#define HFSPLUS_VNODE_READ_DATA			(1<<1)
+#define HFSPLUS_VNODE_LIST_DIRECTORY		HFSPLUS_VNODE_READ_DATA
+#define HFSPLUS_VNODE_WRITE_DATA		(1<<2)
+#define HFSPLUS_VNODE_ADD_FILE			HFSPLUS_VNODE_WRITE_DATA
+#define HFSPLUS_VNODE_EXECUTE			(1<<3)
+#define HFSPLUS_VNODE_SEARCH			HFSPLUS_VNODE_EXECUTE
+#define HFSPLUS_VNODE_DELETE			(1<<4)
+#define HFSPLUS_VNODE_APPEND_DATA		(1<<5)
+#define HFSPLUS_VNODE_ADD_SUBDIRECTORY		HFSPLUS_VNODE_APPEND_DATA
+#define HFSPLUS_VNODE_DELETE_CHILD		(1<<6)
+#define HFSPLUS_VNODE_READ_ATTRIBUTES		(1<<7)
+#define HFSPLUS_VNODE_WRITE_ATTRIBUTES		(1<<8)
+#define HFSPLUS_VNODE_READ_EXTATTRIBUTES	(1<<9)
+#define HFSPLUS_VNODE_WRITE_EXTATTRIBUTES	(1<<10)
+#define HFSPLUS_VNODE_READ_SECURITY		(1<<11)
+#define HFSPLUS_VNODE_WRITE_SECURITY		(1<<12)
+#define HFSPLUS_VNODE_TAKE_OWNERSHIP		(1<<13)
+
+#define HFSPLUS_ACE_GENERIC_ALL			(1<<21)
+#define HFSPLUS_ACE_GENERIC_EXECUTE		(1<<22)
+#define HFSPLUS_ACE_GENERIC_WRITE		(1<<23)
+#define HFSPLUS_ACE_GENERIC_READ		(1<<24)
+
+#define HFSPLUS_VNODE_ANYONE_MODE (HFSPLUS_VNODE_READ_ATTRIBUTES | \
+					 HFSPLUS_VNODE_READ_EXTATTRIBUTES | \
+					 HFSPLUS_VNODE_READ_SECURITY)
+
+#define HFSPLUS_VNODE_GENERIC_READ_BITS (HFSPLUS_VNODE_READ_DATA | \
+					 HFSPLUS_VNODE_READ_ATTRIBUTES | \
+					 HFSPLUS_VNODE_READ_EXTATTRIBUTES | \
+					 HFSPLUS_VNODE_READ_SECURITY)
+
+#define HFSPLUS_VNODE_OWNER_MODE (HFSPLUS_VNODE_WRITE_ATTRIBUTES | \
+					 HFSPLUS_VNODE_WRITE_EXTATTRIBUTES | \
+					 HFSPLUS_VNODE_WRITE_SECURITY)
+
+#define HFSPLUS_VNODE_WRITE_MODE (HFSPLUS_VNODE_WRITE_DATA | \
+					  HFSPLUS_VNODE_APPEND_DATA | \
+					  HFSPLUS_VNODE_DELETE)
+
+#define HFSPLUS_VNODE_GENERIC_WRITE_BITS (HFSPLUS_VNODE_WRITE_DATA | \
+					  HFSPLUS_VNODE_APPEND_DATA | \
+					  HFSPLUS_VNODE_DELETE | \
+					  HFSPLUS_VNODE_DELETE_CHILD | \
+					  HFSPLUS_VNODE_WRITE_ATTRIBUTES | \
+					  HFSPLUS_VNODE_WRITE_EXTATTRIBUTES | \
+					  HFSPLUS_VNODE_WRITE_SECURITY)
+
+#define HFSPLUS_VNODE_GENERIC_EXECUTE_BITS (HFSPLUS_VNODE_EXECUTE)
+
+#define HFSPLUS_VNODE_GENERIC_ALL_BITS	(HFSPLUS_VNODE_GENERIC_READ_BITS | \
+					 HFSPLUS_VNODE_GENERIC_WRITE_BITS | \
+					 HFSPLUS_VNODE_GENERIC_EXECUTE_BITS)
+
+/* acl.c */
+struct posix_acl *hfsplus_get_acl(struct inode *inode, int type);
+int hfsplus_acl_chmod(struct inode *inode);
+int hfsplus_init_acl(struct inode *, struct inode *);
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch
hfsplus-add-all-necessary-declarations-for-acls-support.patch
hfsplus-add-implementation-of-the-acls-support.patch
hfsplus-integrate-of-implemented-acls-support-into-driver.patch

