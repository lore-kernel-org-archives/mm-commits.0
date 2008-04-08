From: akpm@linux-foundation.org
Subject: + mempolicy-rework-shmem-mpol-parsing-and-display.patch added to -mm tree
Date: Mon, 07 Apr 2008 20:27:04 -0700
Message-ID: <200804080327.m383R43J006046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbYDHD1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 23:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mempolicy: rework shmem mpol parsing and display
has been added to the -mm tree.  Its filename is
     mempolicy-rework-shmem-mpol-parsing-and-display.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: rework shmem mpol parsing and display
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

mm/shmem.c currently contains functions to parse and display memory policy
strings for the tmpfs 'mpol' mount option.  Move this to mm/mempolicy.c with
the rest of the mempolicy support.  With subsequent patches, we'll be able to
remove knowledge of the details [mode, flags, policy, ...] completely from
shmem.c

1) replace shmem_parse_mpol() in mm/shmem.c with mpol_parse_str() in
   mm/mempolicy.c.  Rework to use the policy_types[] array [used by
   mpol_to_str()] to look up mode by name.

2) use mpol_to_str() to format policy for shmem_show_mpol().  mpol_to_str()
   expects a pointer to a struct mempolicy, so temporarily construct one. 
   This will be replaced with a reference to a struct mempolicy in the tmpfs
   superblock in a subsequent patch.

   NOTE 1: I changed mpol_to_str() to use a colon ':' rather than an equal
   sign '=' as the nodemask delimiter to match mpol_parse_str() and the
   tmpfs/shmem mpol mount option formatting that now uses mpol_to_str().  This
   is a user visible change to numa_maps, but then the addition of the mode
   flags already changed the display.  It makes sense to me to have the mounts
   and numa_maps display the policy in the same format.  However, if anyone
   objects strongly, I can pass the desired nodemask delimeter as an arg to
   mpol_to_str().

   Note 2: Like show_numa_map(), I don't check the return code from
   mpol_to_str().  I do use a longer buffer than the one provided by
   show_numa_map(), which seems to have sufficed so far.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   21 ++++++
 mm/mempolicy.c            |  104 ++++++++++++++++++++++++++++++-
 mm/shmem.c                |  120 ++++--------------------------------
 3 files changed, 137 insertions(+), 108 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-rework-shmem-mpol-parsing-and-display include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-rework-shmem-mpol-parsing-and-display
+++ a/include/linux/mempolicy.h
@@ -214,6 +214,13 @@ static inline void check_highest_zone(en
 int do_migrate_pages(struct mm_struct *mm,
 	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags);
 
+
+#ifdef CONFIG_TMPFS
+extern int mpol_parse_str(char *str, unsigned short *mode,
+			unsigned short *mode_flags, nodemask_t *policy_nodes);
+
+extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol);
+#endif
 #else
 
 struct mempolicy {};
@@ -313,6 +320,20 @@ static inline int do_migrate_pages(struc
 static inline void check_highest_zone(int k)
 {
 }
+
+#ifdef CONFIG_TMPFS
+static inline int mpol_parse_str(char *value, unsigned short *policy,
+				unsigned short flags, nodemask_t *policy_nodes)
+{
+	return 1;
+}
+
+static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
+{
+	return 0;
+}
+#endif
+
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
 
diff -puN mm/mempolicy.c~mempolicy-rework-shmem-mpol-parsing-and-display mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-rework-shmem-mpol-parsing-and-display
+++ a/mm/mempolicy.c
@@ -88,6 +88,7 @@
 #include <linux/rmap.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/ctype.h>
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
@@ -1946,6 +1947,10 @@ void numa_default_policy(void)
 }
 
 /*
+ * Parse and format mempolicy from/to strings
+ */
+
+/*
  * "local" is pseudo-policy:  MPOL_PREFERRED with MPOL_F_LOCAL flag
  * Used only for mpol_to_str()
  */
@@ -1953,12 +1958,107 @@ void numa_default_policy(void)
 static const char * const policy_types[] =
 	{ "default", "prefer", "bind", "interleave", "local" };
 
+
+#ifdef CONFIG_TMPFS
+/**
+ * mpol_parse_str - parse string to mempolicy
+ * @str:  string containing mempolicy to parse
+ * @mode:  pointer to returned policy mode
+ * @mode_flags:  pointer to returned flags
+ * @policy_nodes:  pointer to returned nodemask
+ *
+ * Format of input:
+ *	<mode>[=<flags>][:<nodelist>]
+ *
+ * Currently only used for tmpfs/shmem mount options
+ */
+int mpol_parse_str(char *str, unsigned short *mode, unsigned short *mode_flags,
+			nodemask_t *policy_nodes)
+{
+	char *nodelist = strchr(str, ':');
+	char *flags = strchr(str, '=');
+	int i;
+	int err = 1;
+
+	if (nodelist) {
+		/* NUL-terminate mode or flags string */
+		*nodelist++ = '\0';
+		if (nodelist_parse(nodelist, *policy_nodes))
+			goto out;
+		if (!nodes_subset(*policy_nodes, node_states[N_HIGH_MEMORY]))
+			goto out;
+	}
+	if (flags)
+		*flags++ = '\0';	/* terminate mode string */
+
+	for (i = 0; i < MPOL_MAX; i++) {
+		if (!strcmp(str, policy_types[i])) {
+			*mode = i;
+			break;
+		}
+	}
+	if (i == MPOL_MAX)
+		goto out;
+
+	switch (*mode) {
+	case MPOL_DEFAULT:
+		/* Don't allow a nodelist nor flags */
+		if (!nodelist && !flags)
+			err = 0;
+		break;
+	case MPOL_PREFERRED:
+		/* Insist on a nodelist of one node only */
+		if (nodelist) {
+			char *rest = nodelist;
+			while (isdigit(*rest))
+				rest++;
+			if (!*rest)
+				err = 0;
+		}
+		break;
+	case MPOL_BIND:
+		/* Insist on a nodelist */
+		if (nodelist)
+			err = 0;
+		break;
+	case MPOL_INTERLEAVE:
+		/*
+		 * Default to online nodes with memory if no nodelist
+		 */
+		if (!nodelist)
+			*policy_nodes = node_states[N_HIGH_MEMORY];
+		err = 0;
+	}
+
+	*mode_flags = 0;
+	if (flags) {
+		/*
+		 * Currently, we only support two mutually exclusive
+		 * mode flags.
+		 */
+		if (!strcmp(flags, "static"))
+			*mode_flags |= MPOL_F_STATIC_NODES;
+		else if (!strcmp(flags, "relative"))
+			*mode_flags |= MPOL_F_RELATIVE_NODES;
+		else
+			err = 1;
+	}
+out:
+	/* Restore string for error message */
+	if (nodelist)
+		*--nodelist = ':';
+	if (flags)
+		*--flags = '=';
+	return err;
+}
+#endif /* CONFIG_TMPFS */
+
 /*
  * Convert a mempolicy into a string.
  * Returns the number of characters in buffer (if positive)
  * or an error (negative)
  */
-static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
+int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 {
 	char *p = buffer;
 	int l;
@@ -2023,7 +2123,7 @@ static inline int mpol_to_str(char *buff
 	if (!nodes_empty(nodes)) {
 		if (buffer + maxlen < p + 2)
 			return -ENOSPC;
-		*p++ = '=';
+		*p++ = ':';
 	 	p += nodelist_scnprintf(p, buffer + maxlen - p, nodes);
 	}
 	return p - buffer;
diff -puN mm/shmem.c~mempolicy-rework-shmem-mpol-parsing-and-display mm/shmem.c
--- a/mm/shmem.c~mempolicy-rework-shmem-mpol-parsing-and-display
+++ a/mm/shmem.c
@@ -1079,108 +1079,22 @@ redirty:
 
 #ifdef CONFIG_NUMA
 #ifdef CONFIG_TMPFS
-static int shmem_parse_mpol(char *value, unsigned short *policy,
-			unsigned short *mode_flags, nodemask_t *policy_nodes)
+static void shmem_show_mpol(struct seq_file *seq, unsigned short mode,
+			unsigned short flags, const nodemask_t policy_nodes)
 {
-	char *nodelist = strchr(value, ':');
-	char *flags = strchr(value, '=');
-	int err = 1;
-
-	if (nodelist) {
-		/* NUL-terminate policy string */
-		*nodelist++ = '\0';
-		if (nodelist_parse(nodelist, *policy_nodes))
-			goto out;
-		if (!nodes_subset(*policy_nodes, node_states[N_HIGH_MEMORY]))
-			goto out;
-	}
-	if (flags)
-		*flags++ = '\0';
-	if (!strcmp(value, "default")) {
-		*policy = MPOL_DEFAULT;
-		/* Don't allow a nodelist */
-		if (!nodelist)
-			err = 0;
-	} else if (!strcmp(value, "prefer")) {
-		*policy = MPOL_PREFERRED;
-		/* Insist on a nodelist of one node only */
-		if (nodelist) {
-			char *rest = nodelist;
-			while (isdigit(*rest))
-				rest++;
-			if (!*rest)
-				err = 0;
-		}
-	} else if (!strcmp(value, "bind")) {
-		*policy = MPOL_BIND;
-		/* Insist on a nodelist */
-		if (nodelist)
-			err = 0;
-	} else if (!strcmp(value, "interleave")) {
-		*policy = MPOL_INTERLEAVE;
-		/*
-		 * Default to online nodes with memory if no nodelist
-		 */
-		if (!nodelist)
-			*policy_nodes = node_states[N_HIGH_MEMORY];
-		err = 0;
-	}
+	struct mempolicy temp;
+	char buffer[64];
 
-	*mode_flags = 0;
-	if (flags) {
-		/*
-		 * Currently, we only support two mutually exclusive
-		 * mode flags.
-		 */
-		if (!strcmp(flags, "static"))
-			*mode_flags |= MPOL_F_STATIC_NODES;
-		else if (!strcmp(flags, "relative"))
-			*mode_flags |= MPOL_F_RELATIVE_NODES;
-		else
-			err = 1;	/* unrecognized flag */
-	}
-out:
-	/* Restore string for error message */
-	if (nodelist)
-		*--nodelist = ':';
-	if (flags)
-		*--flags = '=';
-	return err;
-}
+	if (mode == MPOL_DEFAULT)
+		return;		/* show nothing */
 
-static void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
-			unsigned short flags, const nodemask_t policy_nodes)
-{
-	char *policy_string;
+	temp.mode = mode;
+	temp.flags = flags;
+	temp.v.nodes = policy_nodes;
 
-	switch (policy) {
-	case MPOL_PREFERRED:
-		policy_string = "prefer";
-		break;
-	case MPOL_BIND:
-		policy_string = "bind";
-		break;
-	case MPOL_INTERLEAVE:
-		policy_string = "interleave";
-		break;
-	default:
-		/* MPOL_DEFAULT */
-		return;
-	}
-
-	seq_printf(seq, ",mpol=%s", policy_string);
-
-	if (policy != MPOL_INTERLEAVE ||
-	    !nodes_equal(policy_nodes, node_states[N_HIGH_MEMORY])) {
-		char buffer[64];
-		int len;
-
-		len = nodelist_scnprintf(buffer, sizeof(buffer), policy_nodes);
-		if (len < sizeof(buffer))
-			seq_printf(seq, ":%s", buffer);
-		else
-			seq_printf(seq, ":?");
-	}
+	mpol_to_str(buffer, sizeof(buffer), &temp);
+
+	seq_printf(seq, ",mpol=%s", buffer);
 }
 #endif /* CONFIG_TMPFS */
 
@@ -1221,12 +1135,6 @@ static struct page *shmem_alloc_page(gfp
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
-static inline int shmem_parse_mpol(char *value, unsigned short *policy,
-			unsigned short *mode_flags, nodemask_t *policy_nodes)
-{
-	return 1;
-}
-
 static inline void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
 			unsigned short flags, const nodemask_t policy_nodes)
 {
@@ -2231,8 +2139,8 @@ static int shmem_parse_options(char *opt
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
-			if (shmem_parse_mpol(value, &sbinfo->policy,
-				&sbinfo->flags, &sbinfo->policy_nodes))
+			if (mpol_parse_str(value, &sbinfo->policy,
+					 &sbinfo->flags, &sbinfo->policy_nodes))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mempolicy-rename-mpol_free-to-mpol_put.patch
mempolicy-rename-mpol_copy-to-mpol_dup.patch
mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
mempolicy-fixup-fallback-for-default-shmem-policy.patch
mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
mempolicy-mark-shared-policies-for-unref.patch
mempolicy-document-setget_policy-vm_ops-apis.patch
mempolicy-rework-mempolicy-reference-counting.patch
mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
mempolicy-rework-shmem-mpol-parsing-and-display.patch
mempolicy-support-mpol=local-tmpfs-mount-option.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch

