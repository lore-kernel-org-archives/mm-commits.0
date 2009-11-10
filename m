From: akpm@linux-foundation.org
Subject: + lib-introduce-strim.patch added to -mm tree
Date: Tue, 10 Nov 2009 12:31:09 -0800
Message-ID: <200911102031.nAAKV9IK003241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065AbZKJUbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 15:31:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, James.Bottomley@HansenPartnership.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Subject: Re: [PATCH] strstrip incorrectly marked __must_check
has been added to the -mm tree.  Its filename is
     lib-introduce-strim.patch

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
Subject: Subject: Re: [PATCH] strstrip incorrectly marked __must_check
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Recently, We marked strstrip() as must_check.  because it was frequently
misused and it should be checked.  However, we found one exception. 
scsi/ipr.c intentionally ignore return value of strstrip.  Because it
wishes to keep the whitespace at the beginning.

Thus we need to keep with and without checked whitespace trim function. 
This patch adds a new strim() and changes ipr.c to use it.

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/ipr.c~lib-introduce-strim drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~lib-introduce-strim
+++ a/drivers/scsi/ipr.c
@@ -1333,7 +1333,7 @@ static void ipr_log_enhanced_dual_ioa_er
 
 	error = &hostrcb->hcam.u.error.u.type_17_error;
 	error->failure_reason[sizeof(error->failure_reason) - 1] = '\0';
-	strstrip(error->failure_reason);
+	strim(error->failure_reason);
 
 	ipr_hcam_err(hostrcb, "%s [PRC: %08X]\n", error->failure_reason,
 		     be32_to_cpu(hostrcb->hcam.u.error.prc));
@@ -1359,7 +1359,7 @@ static void ipr_log_dual_ioa_error(struc
 
 	error = &hostrcb->hcam.u.error.u.type_07_error;
 	error->failure_reason[sizeof(error->failure_reason) - 1] = '\0';
-	strstrip(error->failure_reason);
+	strim(error->failure_reason);
 
 	ipr_hcam_err(hostrcb, "%s [PRC: %08X]\n", error->failure_reason,
 		     be32_to_cpu(hostrcb->hcam.u.error.prc));
diff -puN include/linux/string.h~lib-introduce-strim include/linux/string.h
--- a/include/linux/string.h~lib-introduce-strim
+++ a/include/linux/string.h
@@ -62,7 +62,14 @@ extern char * strnchr(const char *, size
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
-extern char * __must_check strstrip(char *);
+
+extern char * strim(char *);
+
+static inline __must_check char* strstrip(char *str)
+{
+	return strim(str);
+}
+
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
 #endif
diff -puN lib/string.c~lib-introduce-strim lib/string.c
--- a/lib/string.c~lib-introduce-strim
+++ a/lib/string.c
@@ -330,14 +330,14 @@ EXPORT_SYMBOL(strnchr);
 #endif
 
 /**
- * strstrip - Removes leading and trailing whitespace from @s.
+ * strim - Removes leading and trailing whitespace from @s.
  * @s: The string to be stripped.
  *
  * Note that the first trailing whitespace is replaced with a %NUL-terminator
  * in the given string @s. Returns a pointer to the first non-whitespace
  * character in @s.
  */
-char *strstrip(char *s)
+char *strim(char *s)
 {
 	size_t size;
 	char *end;
@@ -357,7 +357,7 @@ char *strstrip(char *s)
 
 	return s;
 }
-EXPORT_SYMBOL(strstrip);
+EXPORT_SYMBOL(strim);
 
 #ifndef __HAVE_ARCH_STRLEN
 /**
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
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
prctl-add-pr_set_proctitle_area-option.patch
lib-introduce-strim.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

