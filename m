From: akpm@linux-foundation.org
Subject: [merged] kexec-use-min_t-to-simplify-logic.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:54 -0700
Message-ID: <20130507174954.8C45E5A43B1@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:41258 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3EGRt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:56 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so110277qab.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, horms@verge.net.au, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: Use min() and min_t() to simplify logic
has been removed from the -mm tree.  Its filename was
     kexec-use-min_t-to-simplify-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: kexec: Use min() and min_t() to simplify logic

Simplify the logic of variable assignments.

[akpm@linux-foundation.org: replace min_t with min, remove unneeded casts]
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
+				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		uchunk = min(ubytes, mchunk);
 
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
+				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		uchunk = min(ubytes, mchunk);
+		if (mchunk > uchunk) {
 			/* Zero the trailing part of the page */
 			memset(ptr + uchunk, 0, mchunk - uchunk);
 		}
@@ -1546,8 +1539,7 @@ void vmcoreinfo_append_str(const char *f
 	r = vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	if (r + vmcoreinfo_size > vmcoreinfo_max_size)
-		r = vmcoreinfo_max_size - vmcoreinfo_size;
+	r = min(r, vmcoreinfo_max_size - vmcoreinfo_size);
 
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch

