From: akpm@linux-foundation.org
Subject: [merged] kexec-fix-wrong-types-of-some-local-variables.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:51 -0700
Message-ID: <20130507174951.889EE31C39C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:50067 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab3EGRtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:52 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so109919qae.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, horms@verge.net.au, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix wrong types of some local variables
has been removed from the -mm tree.  Its filename was
     kexec-fix-wrong-types-of-some-local-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -1540,7 +1540,7 @@ void vmcoreinfo_append_str(const char *f
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

