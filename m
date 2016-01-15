From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-m32104ut_defconfig-build-fail.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:31:09 -0800
Message-ID: <5699732d.Zf2PVMQPpZ8q690K%akpm__41231.329952325$1452897092$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbcAOWbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, fengguang.wu@intel.com, stable@vger.kernel.org, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix m32104ut_defconfig build fail
has been removed from the -mm tree.  Its filename was
     m32r-fix-m32104ut_defconfig-build-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
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

arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4.patch

