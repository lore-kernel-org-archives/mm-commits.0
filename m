From: akpm@linux-foundation.org
Subject: [merged] mm-declare-mpol_to_str-when-config_tmpfs=n.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:21 -0700
Message-ID: <201105252028.p4PKSieB014772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059Ab1EYU3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rdunlap@xenotime.net, rientjes@google.comm


The patch titled
     mm: declare mpol_to_str() when CONFIG_TMPFS=n
has been removed from the -mm tree.  Its filename was
     mm-declare-mpol_to_str-when-config_tmpfs=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: declare mpol_to_str() when CONFIG_TMPFS=n
From: Stephen Wilson <wilsons@start.ca>

When CONFIG_TMPFS=n mpol_to_str() is not declared in mempolicy.h. 
However, in the NUMA case, the definition is always compiled.

Since it is not strictly true that tmpfs is the only client, and since the
symbol was always lurking around anyways, export mpol_to_str()
unconditionally.  Furthermore, this will allow us to move show_numa_map()
out of mempolicy.c and into the procfs subsystem.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mempolicy.h~mm-declare-mpol_to_str-when-config_tmpfs=n include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-declare-mpol_to_str-when-config_tmpfs=n
+++ a/include/linux/mempolicy.h
@@ -231,10 +231,10 @@ int do_migrate_pages(struct mm_struct *m
 
 #ifdef CONFIG_TMPFS
 extern int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context);
+#endif
 
 extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 			int no_context);
-#endif
 
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
@@ -371,13 +371,13 @@ static inline int mpol_parse_str(char *s
 {
 	return 1;	/* error */
 }
+#endif
 
 static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 				int no_context)
 {
 	return 0;
 }
-#endif
 
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from wilsons@start.ca are

origin.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch

