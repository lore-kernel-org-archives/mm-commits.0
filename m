From: akpm@linux-foundation.org
Subject: + audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record.patch added to -mm tree
Date: Thu, 09 May 2013 11:14:14 -0700
Message-ID: <20130509181414.93F7231C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:38459 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3EISOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:14:15 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so316699qec.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:14:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, eparis@redhat.com, jjaburek@redhat.com, sgrubb@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: audit: fix mq_open and mq_unlink to add the MQ root as a hidden parent audit_names record
has been added to the -mm tree.  Its filename is
     audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: audit: fix mq_open and mq_unlink to add the MQ root as a hidden parent audit_names record

The old audit PATH records for mq_open looked like this:

type=PATH msg=audit(1366282323.982:869): item=1 name=(null) inode=6777
dev=00:0c mode=041777 ouid=0 ogid=0 rdev=00:00
obj=system_u:object_r:tmpfs_t:s15:c0.c1023
type=PATH msg=audit(1366282323.982:869): item=0 name="test_mq" inode=26732
dev=00:0c mode=0100700 ouid=0 ogid=0 rdev=00:00
obj=staff_u:object_r:user_tmpfs_t:s15:c0.c1023

...with the audit related changes that went into 3.7, they now look like this:

type=PATH msg=audit(1366282236.776:3606): item=2 name=(null) inode=66655
dev=00:0c mode=0100700 ouid=0 ogid=0 rdev=00:00
obj=staff_u:object_r:user_tmpfs_t:s15:c0.c1023
type=PATH msg=audit(1366282236.776:3606): item=1 name=(null) inode=6926
dev=00:0c mode=041777 ouid=0 ogid=0 rdev=00:00
obj=system_u:object_r:tmpfs_t:s15:c0.c1023
type=PATH msg=audit(1366282236.776:3606): item=0 name="test_mq"

Both of these look wrong to me.  As Steve Grubb pointed out:

"What we need is 1 PATH record that identifies the MQ. The other PATH
 records probably should not be there."

Fix it to record the mq root as a parent, and flag it such that it should
be hidden from view when the names are logged, since the root of the mq
filesystem isn't terribly interesting.  With this change, we get a single
PATH record that looks more like this:

type=PATH msg=audit(1368021604.836:484): item=0 name="test_mq" inode=16914
dev=00:0c mode=0100644 ouid=0 ogid=0 rdev=00:00
obj=unconfined_u:object_r:user_tmpfs_t:s0

In order to do this, a new audit_inode_parent_hidden() function is added. 
If we do it this way, then we avoid having the existing callers of
audit_inode needing to do any sort of flag conversion if auditing is
inactive.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reported-by: Jiri Jaburek <jjaburek@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h |   26 ++++++++++++++++++++++----
 ipc/mqueue.c          |    2 ++
 kernel/auditsc.c      |   13 ++++++++++---
 3 files changed, 34 insertions(+), 7 deletions(-)

diff -puN include/linux/audit.h~audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record include/linux/audit.h
--- a/include/linux/audit.h~audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record
+++ a/include/linux/audit.h
@@ -98,8 +98,11 @@ extern void __audit_syscall_exit(int ret
 extern struct filename *__audit_reusename(const __user char *uptr);
 extern void __audit_getname(struct filename *name);
 extern void audit_putname(struct filename *name);
+
+#define AUDIT_INODE_PARENT	1	/* dentry represents the parent */
+#define AUDIT_INODE_HIDDEN	2	/* audit record should be hidden */
 extern void __audit_inode(struct filename *name, const struct dentry *dentry,
-				unsigned int parent);
+				unsigned int flags);
 extern void __audit_inode_child(const struct inode *parent,
 				const struct dentry *dentry,
 				const unsigned char type);
@@ -143,10 +146,22 @@ static inline void audit_getname(struct
 	if (unlikely(!audit_dummy_context()))
 		__audit_getname(name);
 }
-static inline void audit_inode(struct filename *name, const struct dentry *dentry,
+static inline void audit_inode(struct filename *name,
+				const struct dentry *dentry,
 				unsigned int parent) {
+	if (unlikely(!audit_dummy_context())) {
+		unsigned int flags = 0;
+		if (parent)
+			flags |= AUDIT_INODE_PARENT;
+		__audit_inode(name, dentry, flags);
+	}
+}
+static inline void audit_inode_parent_hidden(struct filename *name,
+						const struct dentry *dentry)
+{
 	if (unlikely(!audit_dummy_context()))
-		__audit_inode(name, dentry, parent);
+		__audit_inode(name, dentry,
+				AUDIT_INODE_PARENT | AUDIT_INODE_HIDDEN);
 }
 static inline void audit_inode_child(const struct inode *parent,
 				     const struct dentry *dentry,
@@ -307,7 +322,7 @@ static inline void audit_putname(struct
 { }
 static inline void __audit_inode(struct filename *name,
 					const struct dentry *dentry,
-					unsigned int parent)
+					unsigned int flags)
 { }
 static inline void __audit_inode_child(const struct inode *parent,
 					const struct dentry *dentry,
@@ -317,6 +332,9 @@ static inline void audit_inode(struct fi
 				const struct dentry *dentry,
 				unsigned int parent)
 { }
+static inline void audit_inode_parent_hidden(struct filename *name,
+				const struct dentry *dentry)
+{ }
 static inline void audit_inode_child(const struct inode *parent,
 				     const struct dentry *dentry,
 				     const unsigned char type)
diff -puN ipc/mqueue.c~audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record ipc/mqueue.c
--- a/ipc/mqueue.c~audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record
+++ a/ipc/mqueue.c
@@ -823,6 +823,7 @@ SYSCALL_DEFINE4(mq_open, const char __us
 				error = ro;
 				goto out;
 			}
+			audit_inode_parent_hidden(name, root);
 			filp = do_create(ipc_ns, root->d_inode,
 						&path, oflag, mode,
 						u_attr ? &attr : NULL);
@@ -868,6 +869,7 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
+	audit_inode_parent_hidden(name, mnt->mnt_root);
 	err = mnt_want_write(mnt);
 	if (err)
 		goto out_name;
diff -puN kernel/auditsc.c~audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record kernel/auditsc.c
--- a/kernel/auditsc.c~audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record
+++ a/kernel/auditsc.c
@@ -119,6 +119,7 @@ struct audit_names {
 	unsigned int		fcap_ver;
 	int			name_len;	/* number of name's characters to log */
 	unsigned char		type;		/* record type */
+	bool			hidden;		/* don't log this record */
 	bool			name_put;	/* call __putname() for this name */
 	/*
 	 * This was an allocated audit_names and not from the array of
@@ -1694,8 +1695,11 @@ static void audit_log_exit(struct audit_
 	}
 
 	i = 0;
-	list_for_each_entry(n, &context->names_list, list)
+	list_for_each_entry(n, &context->names_list, list) {
+		if (n->hidden)
+			continue;
 		audit_log_name(context, n, i++, &call_panic);
+	}
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
@@ -2099,14 +2103,15 @@ static void audit_copy_inode(struct audi
  * __audit_inode - store the inode and device from a lookup
  * @name: name being audited
  * @dentry: dentry being audited
- * @parent: does this dentry represent the parent?
+ * @flags: attributes for this particular entry
  */
 void __audit_inode(struct filename *name, const struct dentry *dentry,
-		   unsigned int parent)
+		   unsigned int flags)
 {
 	struct audit_context *context = current->audit_context;
 	const struct inode *inode = dentry->d_inode;
 	struct audit_names *n;
+	bool parent = flags & AUDIT_INODE_PARENT;
 
 	if (!context->in_syscall)
 		return;
@@ -2161,6 +2166,8 @@ out:
 	if (parent) {
 		n->name_len = n->name ? parent_len(n->name->name) : AUDIT_NAME_FULL;
 		n->type = AUDIT_TYPE_PARENT;
+		if (flags & AUDIT_INODE_HIDDEN)
+			n->hidden = true;
 	} else {
 		n->name_len = AUDIT_NAME_FULL;
 		n->type = AUDIT_TYPE_NORMAL;
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch
audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record.patch

