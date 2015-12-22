From: akpm@linux-foundation.org
Subject: + m32r-fix-build-failure.patch added to -mm tree
Date: Tue, 22 Dec 2015 13:19:34 -0800
Message-ID: <5679be66.Wl+B2BTJPdx0OuIa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbbLVVTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2015 16:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix build failure
has been added to the -mm tree.  Its filename is
     m32r-fix-build-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-fix-build-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-fix-build-failure.patch

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

m32r-fix-build-failure.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4.patch

