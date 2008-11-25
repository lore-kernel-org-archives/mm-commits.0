From: akpm@linux-foundation.org
Subject: + mm-make-vread-and-vwrite-declaration.patch added to -mm tree
Date: Tue, 25 Nov 2008 15:56:12 -0800
Message-ID: <200811252356.mAPNuC3U026794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbYKYX4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 18:56:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: make vread() and vwrite() declaration
has been added to the -mm tree.  Its filename is
     mm-make-vread-and-vwrite-declaration.patch

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
Subject: mm: make vread() and vwrite() declaration
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Sparse output following warnings.

mm/vmalloc.c:1436:6: warning: symbol 'vread' was not declared. Should it be static?
mm/vmalloc.c:1474:6: warning: symbol 'vwrite' was not declared. Should it be static?

However, it is used by /dev/kmem. fixed here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c      |    3 ---
 include/linux/vmalloc.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/mem.c~mm-make-vread-and-vwrite-declaration drivers/char/mem.c
--- a/drivers/char/mem.c~mm-make-vread-and-vwrite-declaration
+++ a/drivers/char/mem.c
@@ -425,9 +425,6 @@ static ssize_t read_oldmem(struct file *
 }
 #endif
 
-extern long vread(char *buf, char *addr, unsigned long count);
-extern long vwrite(char *buf, char *addr, unsigned long count);
-
 #ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
diff -puN include/linux/vmalloc.h~mm-make-vread-and-vwrite-declaration include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-make-vread-and-vwrite-declaration
+++ a/include/linux/vmalloc.h
@@ -97,6 +97,10 @@ extern void unmap_kernel_range(unsigned 
 extern struct vm_struct *alloc_vm_area(size_t size);
 extern void free_vm_area(struct vm_struct *area);
 
+/* for /dev/kmem */
+extern long vread(char *buf, char *addr, unsigned long count);
+extern long vwrite(char *buf, char *addr, unsigned long count);
+
 /*
  *	Internals.  Dont't use..
  */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
vmscan-evict-streaming-io-first.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch

