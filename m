From: akpm@linux-foundation.org
Subject: + mm-declare-mpol_to_str-when-config_tmpfs=n.patch added to -mm tree
Date: Wed, 18 May 2011 14:37:23 -0700
Message-ID: <201105182137.p4ILbO4a025431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292Ab1ERVhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rdunlap@xenotime.net, rientjes@google.com


The patch titled
     mm: declare mpol_to_str() when CONFIG_TMPFS=n
has been added to the -mm tree.  Its filename is
     mm-declare-mpol_to_str-when-config_tmpfs=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-declare-mpol_to_str-when-config_tmpfs=n.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch

