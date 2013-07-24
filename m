From: akpm@linux-foundation.org
Subject: + kernel-replace-strict_strto-with-kstrto.patch added to -mm tree
Date: Wed, 24 Jul 2013 14:05:00 -0700
Message-ID: <51f0417c.H4xgLuZbnh6SEezt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3GXVFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 17:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + kernel-replace-strict_strto-with-kstrto.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 14:05:00 -0700


The patch titled
     Subject: kernel: replace strict_strto*() with kstrto*()
has been added to the -mm tree.  Its filename is
     kernel-replace-strict_strto-with-kstrto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-replace-strict_strto-with-kstrto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-replace-strict_strto-with-kstrto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: kernel: replace strict_strto*() with kstrto*()

The usage of strict_strto*() is not preferred, because strict_strto*() is
obsolete.  Thus, kstrto*() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |    2 +-
 kernel/ksysfs.c  |    2 +-
 kernel/params.c  |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/gcov/fs.c~kernel-replace-strict_strto-with-kstrto kernel/gcov/fs.c
--- a/kernel/gcov/fs.c~kernel-replace-strict_strto-with-kstrto
+++ a/kernel/gcov/fs.c
@@ -74,7 +74,7 @@ static int __init gcov_persist_setup(cha
 {
 	unsigned long val;
 
-	if (strict_strtoul(str, 0, &val)) {
+	if (kstrtoul(str, 0, &val)) {
 		pr_warning("invalid gcov_persist parameter '%s'\n", str);
 		return 0;
 	}
diff -puN kernel/ksysfs.c~kernel-replace-strict_strto-with-kstrto kernel/ksysfs.c
--- a/kernel/ksysfs.c~kernel-replace-strict_strto-with-kstrto
+++ a/kernel/ksysfs.c
@@ -113,7 +113,7 @@ static ssize_t kexec_crash_size_store(st
 	unsigned long cnt;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &cnt))
+	if (kstrtoul(buf, 0, &cnt))
 		return -EINVAL;
 
 	ret = crash_shrink_memory(cnt);
diff -puN kernel/params.c~kernel-replace-strict_strto-with-kstrto kernel/params.c
--- a/kernel/params.c~kernel-replace-strict_strto-with-kstrto
+++ a/kernel/params.c
@@ -252,13 +252,13 @@ int parse_args(const char *doing,
 	EXPORT_SYMBOL(param_ops_##name)
 
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtol);
+STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(long, long, "%li", long, kstrtol);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

block-replace-strict_strtoul-with-kstrtoul.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
kernel-replace-strict_strto-with-kstrto.patch
linux-next.patch

