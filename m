From: akpm@linux-foundation.org
Subject: [merged] strstrip-mark-as-as-must_check.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:48:41 -0700
Message-ID: <200910302048.n9UKmfC3006422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757462AbZJ3UtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     strstrip(): mark as as must_check
has been removed from the -mm tree.  Its filename was
     strstrip-mark-as-as-must_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: strstrip(): mark as as must_check
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

strstrip() can return a modified value of its input argument, when
removing elading whitesapce.  So it is surely bug for this function's
return value to be ignored.  The caller is probably going to use the
incorrect original pointer.

So mark it __must_check to prevent this frm happening (as it has before).

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/string.h~strstrip-mark-as-as-must_check include/linux/string.h
--- a/include/linux/string.h~strstrip-mark-as-as-must_check
+++ a/include/linux/string.h
@@ -62,7 +62,7 @@ extern char * strnchr(const char *, size
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
-extern char * strstrip(char *);
+extern char * __must_check strstrip(char *);
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
 #endif
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

