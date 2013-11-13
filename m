From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:38:15 -0800
Message-ID: <5283e337.fkubjSgtzzVvRZ/S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, gang.chen@asianux.com, davej@redhat.com, rientjes@google.com

Subject: [merged] mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch removed from -mm tree
To: rientjes@google.com,davej@redhat.com,gang.chen@asianux.com,kosaki.motohiro@jp.fujitsu.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:15 -0800


The patch titled
     Subject: mm, mempolicy: make mpol_to_str robust and always succeed
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: make mpol_to_str robust and always succeed

mpol_to_str() should not fail.  Currently, it either fails because the
string buffer is too small or because a string hasn't been defined for a
mempolicy mode.

If a new mempolicy mode is introduced and no string is defined for it,
just warn and return "unknown".

If the buffer is too small, just truncate the string and return, the same
behavior as snprintf().

This also fixes a bug where there was no NULL-byte termination when doing
*p++ = '=' and *p++ ':' and maxlen has been reached.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c        |   14 ++++-----
 include/linux/mempolicy.h |    5 +--
 mm/mempolicy.c            |   54 +++++++++++-------------------------
 3 files changed, 25 insertions(+), 48 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-mempolicy-make-mpol_to_str-robust-and-always-succeed fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-mempolicy-make-mpol_to_str-robust-and-always-succeed
+++ a/fs/proc/task_mmu.c
@@ -1387,8 +1387,8 @@ static int show_numa_map(struct seq_file
 	struct mm_struct *mm = vma->vm_mm;
 	struct mm_walk walk = {};
 	struct mempolicy *pol;
-	int n;
-	char buffer[50];
+	char buffer[64];
+	int nid;
 
 	if (!mm)
 		return 0;
@@ -1404,10 +1404,8 @@ static int show_numa_map(struct seq_file
 	walk.mm = mm;
 
 	pol = get_vma_policy(task, vma, vma->vm_start);
-	n = mpol_to_str(buffer, sizeof(buffer), pol);
+	mpol_to_str(buffer, sizeof(buffer), pol);
 	mpol_cond_put(pol);
-	if (n < 0)
-		return n;
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
@@ -1460,9 +1458,9 @@ static int show_numa_map(struct seq_file
 	if (md->writeback)
 		seq_printf(m, " writeback=%lu", md->writeback);
 
-	for_each_node_state(n, N_MEMORY)
-		if (md->node[n])
-			seq_printf(m, " N%d=%lu", n, md->node[n]);
+	for_each_node_state(nid, N_MEMORY)
+		if (md->node[nid])
+			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
 out:
 	seq_putc(m, '\n');
 
diff -puN include/linux/mempolicy.h~mm-mempolicy-make-mpol_to_str-robust-and-always-succeed include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-make-mpol_to_str-robust-and-always-succeed
+++ a/include/linux/mempolicy.h
@@ -169,7 +169,7 @@ int do_migrate_pages(struct mm_struct *m
 extern int mpol_parse_str(char *str, struct mempolicy **mpol);
 #endif
 
-extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol);
+extern void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol);
 
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
@@ -307,9 +307,8 @@ static inline int mpol_parse_str(char *s
 }
 #endif
 
-static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
+static inline void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 {
-	return 0;
 }
 
 static inline int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
diff -puN mm/mempolicy.c~mm-mempolicy-make-mpol_to_str-robust-and-always-succeed mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-make-mpol_to_str-robust-and-always-succeed
+++ a/mm/mempolicy.c
@@ -2914,62 +2914,45 @@ out:
  * @maxlen:  length of @buffer
  * @pol:  pointer to mempolicy to be formatted
  *
- * Convert a mempolicy into a string.
- * Returns the number of characters in buffer (if positive)
- * or an error (negative)
+ * Convert @pol into a string.  If @buffer is too short, truncate the string.
+ * Recommend a @maxlen of at least 32 for the longest mode, "interleave", the
+ * longest flag, "relative", and to display at least a few node ids.
  */
-int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
+void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 {
 	char *p = buffer;
-	int l;
-	nodemask_t nodes;
-	unsigned short mode;
-	unsigned short flags = pol ? pol->flags : 0;
-
-	/*
-	 * Sanity check:  room for longest mode, flag and some nodes
-	 */
-	VM_BUG_ON(maxlen < strlen("interleave") + strlen("relative") + 16);
-
-	if (!pol || pol == &default_policy)
-		mode = MPOL_DEFAULT;
-	else
+	nodemask_t nodes = NODE_MASK_NONE;
+	unsigned short mode = MPOL_DEFAULT;
+	unsigned short flags = 0;
+
+	if (pol && pol != &default_policy) {
 		mode = pol->mode;
+		flags = pol->flags;
+	}
 
 	switch (mode) {
 	case MPOL_DEFAULT:
-		nodes_clear(nodes);
 		break;
-
 	case MPOL_PREFERRED:
-		nodes_clear(nodes);
 		if (flags & MPOL_F_LOCAL)
 			mode = MPOL_LOCAL;
 		else
 			node_set(pol->v.preferred_node, nodes);
 		break;
-
 	case MPOL_BIND:
-		/* Fall through */
 	case MPOL_INTERLEAVE:
 		nodes = pol->v.nodes;
 		break;
-
 	default:
-		return -EINVAL;
+		WARN_ON_ONCE(1);
+		snprintf(p, maxlen, "unknown");
+		return;
 	}
 
-	l = strlen(policy_modes[mode]);
-	if (buffer + maxlen < p + l + 1)
-		return -ENOSPC;
-
-	strcpy(p, policy_modes[mode]);
-	p += l;
+	p += snprintf(p, maxlen, policy_modes[mode]);
 
 	if (flags & MPOL_MODE_FLAGS) {
-		if (buffer + maxlen < p + 2)
-			return -ENOSPC;
-		*p++ = '=';
+		p += snprintf(p, buffer + maxlen - p, "=");
 
 		/*
 		 * Currently, the only defined flags are mutually exclusive
@@ -2981,10 +2964,7 @@ int mpol_to_str(char *buffer, int maxlen
 	}
 
 	if (!nodes_empty(nodes)) {
-		if (buffer + maxlen < p + 2)
-			return -ENOSPC;
-		*p++ = ':';
+		p += snprintf(p, buffer + maxlen - p, ":");
 	 	p += nodelist_scnprintf(p, buffer + maxlen - p, nodes);
 	}
-	return p - buffer;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-srat-use-numa_no_node.patch
linux-next.patch

