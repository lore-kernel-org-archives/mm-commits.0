From: akpm@linux-foundation.org
Subject: [merged] kernel-replace-strict_strto-with-kstrto.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 13:03:06 -0700
Message-ID: <52336f7a.feQyjx/AnBvgqsux%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:03:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] kernel-replace-strict_strto-with-kstrto.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:03:06 -0700


The patch titled
     Subject: kernel: replace strict_strto*() with kstrto*()
has been removed from the -mm tree.  Its filename was
     kernel-replace-strict_strto-with-kstrto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -253,13 +253,13 @@ int parse_args(const char *doing,
 	EXPORT_SYMBOL(param_ops_##name)
 
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtoul);
+STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(int, int, "%i", long, kstrtoul);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(long, long, "%li", long, kstrtoul);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

