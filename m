From: akpm@linux-foundation.org
Subject: + kernel-params-fix-handling-of-signed-integer-types.patch added
 to -mm tree
Date: Thu, 26 Sep 2013 13:18:48 -0700
Message-ID: <524496a8.5+11UGAMA3NlDi9e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3IZUSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 16:18:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lists@nerdbynature.de, jg1.han@samsung.com, khali@linux-fr.org

Subject: + kernel-params-fix-handling-of-signed-integer-types.patch added to -mm tree
To: khali@linux-fr.org,jg1.han@samsung.com,lists@nerdbynature.de
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 13:18:48 -0700


The patch titled
     Subject: kernel/params: fix handling of signed integer types
has been added to the -mm tree.  Its filename is
     kernel-params-fix-handling-of-signed-integer-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-params-fix-handling-of-signed-integer-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-params-fix-handling-of-signed-integer-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-params-fix-handling-of-signed-integer-types.patch
linux-next.patch

