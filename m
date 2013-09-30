From: akpm@linux-foundation.org
Subject: [merged] kernel-params-fix-handling-of-signed-integer-types.patch removed from -mm tree
Date: Mon, 30 Sep 2013 11:57:28 -0700
Message-ID: <5249c998.2OLkO74XgsNvz7r1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3I3S53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 14:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lists@nerdbynature.de, jg1.han@samsung.com, khali@linux-fr.org

Subject: [merged] kernel-params-fix-handling-of-signed-integer-types.patch removed from -mm tree
To: khali@linux-fr.org,jg1.han@samsung.com,lists@nerdbynature.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 11:57:28 -0700


The patch titled
     Subject: kernel/params: fix handling of signed integer types
has been removed from the -mm tree.  Its filename was
     kernel-params-fix-handling-of-signed-integer-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <khali@linux-fr.org>
Subject: kernel/params: fix handling of signed integer types

Commit 6072ddc8520b ("kernel: replace strict_strto*() with kstrto*()")
broke the handling of signed integer types, fix it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/params.c~kernel-params-fix-handling-of-signed-integer-types kernel/params.c
--- a/kernel/params.c~kernel-params-fix-handling-of-signed-integer-types
+++ a/kernel/params.c
@@ -254,11 +254,11 @@ int parse_args(const char *doing,
 
 
 STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtoul);
+STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtol);
 STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, kstrtoul);
+STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
 STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, kstrtoul);
+STANDARD_PARAM_DEF(long, long, "%li", long, kstrtol);
 STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch

