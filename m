From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-build-failure.patch removed from -mm tree
Date: Wed, 30 Dec 2015 12:40:17 -0800
Message-ID: <56844131.9k5EAQs1jjg17qAx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbbL3UkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Dec 2015 15:40:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix build failure
has been removed from the -mm tree.  Its filename was
     m32r-fix-build-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: fix build failure

m32r allmodconfig is failing with:
In file included from ../include/linux/kvm_para.h:4:0,
                 from ../kernel/watchdog.c:26:
../include/uapi/linux/kvm_para.h:30:26: fatal error: asm/kvm_para.h: No such file or directory

kvm_para.h was not included in the build.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/include/asm/Kbuild~m32r-fix-build-failure arch/m32r/include/asm/Kbuild
--- a/arch/m32r/include/asm/Kbuild~m32r-fix-build-failure
+++ a/arch/m32r/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += irq_work.h
+generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
 generic-y += module.h
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4.patch

