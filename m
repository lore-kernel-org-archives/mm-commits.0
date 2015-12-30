From: akpm@linux-foundation.org
Subject: + m32r-fix-m32104ut_defconfig-build-fail.patch added to -mm tree
Date: Wed, 30 Dec 2015 13:18:08 -0800
Message-ID: <56844a10.xUGve+wkl7n6sTS8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbL3VSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Dec 2015 16:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, fengguang.wu@intel.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix m32104ut_defconfig build fail
has been added to the -mm tree.  Its filename is
     m32r-fix-m32104ut_defconfig-build-fail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-fix-m32104ut_defconfig-build-fail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-fix-m32104ut_defconfig-build-fail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: fix m32104ut_defconfig build fail

The build of m32104ut_defconfig for m32r arch was failing for long long
time with the error:
ERROR: "memory_start" [fs/udf/udf.ko] undefined!
ERROR: "memory_end" [fs/udf/udf.ko] undefined!
ERROR: "memory_end" [drivers/scsi/sg.ko] undefined!
ERROR: "memory_start" [drivers/scsi/sg.ko] undefined!
ERROR: "memory_end" [drivers/i2c/i2c-dev.ko] undefined!
ERROR: "memory_start" [drivers/i2c/i2c-dev.ko] undefined!

As done in other architectures export the symbols to fix the error.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/setup.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/m32r/kernel/setup.c~m32r-fix-m32104ut_defconfig-build-fail arch/m32r/kernel/setup.c
--- a/arch/m32r/kernel/setup.c~m32r-fix-m32104ut_defconfig-build-fail
+++ a/arch/m32r/kernel/setup.c
@@ -81,7 +81,10 @@ static struct resource code_resource = {
 };
 
 unsigned long memory_start;
+EXPORT_SYMBOL(memory_start);
+
 unsigned long memory_end;
+EXPORT_SYMBOL(memory_end);
 
 void __init setup_arch(char **);
 int get_cpuinfo(char *);
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-fix-m32104ut_defconfig-build-fail.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4.patch

