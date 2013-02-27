From: akpm@linux-foundation.org
Subject: + kexec-use-min_t-to-simplify-logic.patch added to -mm tree
Date: Wed, 27 Feb 2013 14:38:01 -0800
Message-ID: <20130227223801.CAE7B31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:58147 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3B0WiF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 17:38:05 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so125162ghb.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 14:38:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, horms@verge.net.au, joe@perches.com


The patch titled
     Subject: kexec: Use min() and min_t() to simplify logic
has been added to the -mm tree.  Its filename is
     kexec-use-min_t-to-simplify-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: kexec: Use min() and min_t() to simplify logic

Simplify the logic of variable assignments.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff -puN kernel/kexec.c~kexec-use-min_t-to-simplify-logic kernel/kexec.c
--- a/kernel/kexec.c~kexec-use-min_t-to-simplify-logic
+++ a/kernel/kexec.c
@@ -819,13 +819,9 @@ static int kimage_load_normal_segment(st
 		/* Start with a clear page */
 		clear_page(ptr);
 		ptr += maddr & ~PAGE_MASK;
-		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
-		if (mchunk > mbytes)
-			mchunk = mbytes;
-
-		uchunk = mchunk;
-		if (uchunk > ubytes)
-			uchunk = ubytes;
+		mchunk = min_t(size_t, mbytes,
+			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
+		uchunk = min_t(size_t, ubytes, mchunk);
 
 		result = copy_from_user(ptr, buf, uchunk);
 		kunmap(page);
@@ -871,13 +867,10 @@ static int kimage_load_crash_segment(str
 		}
 		ptr = kmap(page);
 		ptr += maddr & ~PAGE_MASK;
-		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
-		if (mchunk > mbytes)
-			mchunk = mbytes;
-
-		uchunk = mchunk;
-		if (uchunk > ubytes) {
-			uchunk = ubytes;
+		mchunk = min_t(size_t, mbytes,
+			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
+		uchunk = min_t(size_t, ubytes, mchunk);
+		if (mchunk > uchunk) {
 			/* Zero the trailing part of the page */
 			memset(ptr + uchunk, 0, mchunk - uchunk);
 		}
@@ -1458,8 +1451,7 @@ void vmcoreinfo_append_str(const char *f
 	r = vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	if (r + vmcoreinfo_size > vmcoreinfo_max_size)
-		r = vmcoreinfo_max_size - vmcoreinfo_size;
+	r = min_t(size_t, r, vmcoreinfo_max_size - vmcoreinfo_size);
 
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch
kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

