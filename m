From: akpm@linux-foundation.org
Subject: [merged] lib-introduce-strim.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:17 -0800
Message-ID: <200912152158.nBFLwH2G015798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761314AbZLOV7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:59:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, James.Bottomley@HansenPartnership.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: [PATCH] strstrip incorrectly marked __must_check
has been removed from the -mm tree.  Its filename was
     lib-introduce-strim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding-style fixes]
Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c     |    4 ++--
 include/linux/string.h |    9 ++++++++-
 lib/string.c           |    6 +++---
 3 files changed, 13 insertions(+), 6 deletions(-)

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
@@ -63,7 +63,14 @@ extern char * strnchr(const char *, size
 extern char * strrchr(const char *,int);
 #endif
 extern char * __must_check skip_spaces(const char *);
-extern char * __must_check strstrip(char *);
+
+extern char *strim(char *);
+
+static inline __must_check char *strstrip(char *str)
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
@@ -352,14 +352,14 @@ char *skip_spaces(const char *str)
 EXPORT_SYMBOL(skip_spaces);
 
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
@@ -376,7 +376,7 @@ char *strstrip(char *s)
 
 	return s;
 }
-EXPORT_SYMBOL(strstrip);
+EXPORT_SYMBOL(strim);
 
 #ifndef __HAVE_ARCH_STRLEN
 /**
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-introduce-coredump-parameter-structure.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

