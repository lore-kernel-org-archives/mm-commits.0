From: akpm@linux-foundation.org
Subject: + kexec-fix-wrong-types-of-some-local-variables.patch added to -mm tree
Date: Wed, 27 Feb 2013 14:25:07 -0800
Message-ID: <20130227222507.B1DC45A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:64760 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3B0WZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 17:25:09 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so140514qah.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 14:25:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, horms@verge.net.au, joe@perches.com


The patch titled
     Subject: kexec: fix wrong types of some local variables
has been added to the -mm tree.  Its filename is
     kexec-fix-wrong-types-of-some-local-variables.patch

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
Subject: kexec: fix wrong types of some local variables

The types of the following local variables:

- ubytes/mbytes in kimage_load_crash_segment()/kimage_load_normal_segment()

- r in vmcoreinfo_append_str()

are wrong, so fix them.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/kexec.c~kexec-fix-wrong-types-of-some-local-variables kernel/kexec.c
--- a/kernel/kexec.c~kexec-fix-wrong-types-of-some-local-variables
+++ a/kernel/kexec.c
@@ -786,7 +786,7 @@ static int kimage_load_normal_segment(st
 					 struct kexec_segment *segment)
 {
 	unsigned long maddr;
-	unsigned long ubytes, mbytes;
+	size_t ubytes, mbytes;
 	int result;
 	unsigned char __user *buf;
 
@@ -850,7 +850,7 @@ static int kimage_load_crash_segment(str
 	 * We do things a page at a time for the sake of kmap.
 	 */
 	unsigned long maddr;
-	unsigned long ubytes, mbytes;
+	size_t ubytes, mbytes;
 	int result;
 	unsigned char __user *buf;
 
@@ -1452,7 +1452,7 @@ void vmcoreinfo_append_str(const char *f
 {
 	va_list args;
 	char buf[0x50];
-	int r;
+	size_t r;
 
 	va_start(args, fmt);
 	r = vsnprintf(buf, sizeof(buf), fmt, args);
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

