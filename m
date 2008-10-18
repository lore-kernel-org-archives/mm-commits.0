From: akpm@linux-foundation.org
Subject: - mlock-make-mlock-error-return-posixly-correct-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:39:41 -0700
Message-ID: <200810182339.m9INdfuj032554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYJRXjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     mlock-make-mlock-error-return-posixly-correct-fix
has been removed from the -mm tree.  Its filename was
     mlock-make-mlock-error-return-posixly-correct-fix.patch

This patch was dropped because it was folded into mlock-make-mlock-error-return-posixly-correct.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock-make-mlock-error-return-posixly-correct-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/mlock.c: In function 'mlock_fixup':
mm/mlock.c:468: error: implicit declaration of function '__mlock_posix_error_return'

Documentation/SubmitChecklist considered useful...

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN mm/mlock.c~mlock-make-mlock-error-return-posixly-correct-fix mm/mlock.c
--- a/mm/mlock.c~mlock-make-mlock-error-return-posixly-correct-fix
+++ a/mm/mlock.c
@@ -143,18 +143,6 @@ static void munlock_vma_page(struct page
 	}
 }
 
-/*
- * convert get_user_pages() return value to posix mlock() error
- */
-static int __mlock_posix_error_return(long retval)
-{
-	if (retval == -EFAULT)
-		retval = -ENOMEM;
-	else if (retval == -ENOMEM)
-		retval = -EAGAIN;
-	return retval;
-}
-
 /**
  * __mlock_vma_pages_range() -  mlock/munlock a range of pages in the vma.
  * @vma:   target vma
@@ -268,6 +256,18 @@ static long __mlock_vma_pages_range(stru
 	return ret;	/* count entire vma as locked_vm */
 }
 
+/*
+ * convert get_user_pages() return value to posix mlock() error
+ */
+static int __mlock_posix_error_return(long retval)
+{
+	if (retval == -EFAULT)
+		retval = -ENOMEM;
+	else if (retval == -ENOMEM)
+		retval = -EAGAIN;
+	return retval;
+}
+
 #else /* CONFIG_UNEVICTABLE_LRU */
 
 /*
@@ -281,6 +281,12 @@ static long __mlock_vma_pages_range(stru
 		return make_pages_present(start, end);
 	return 0;
 }
+
+static inline int __mlock_posix_error_return(long retval)
+{
+	return 0;
+}
+
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

