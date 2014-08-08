From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
 removed from -mm tree
Date: Fri, 08 Aug 2014 14:00:20 -0700
Message-ID: <53e53a64.jPdvcEoa0s2+7pES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:51106 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbaHHVAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:00:21 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so812107qap.0
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:00:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, fengguang.wu@intel.com, jdike@addtoit.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: use asm-generic/scatterlist.h
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch

This patch was dropped because it was folded into lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: um: use asm-generic/scatterlist.h

commit ff35bd54456e18878c361a8a2deeb41c9688458f
(lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig) changed
some architectures to use the generic scatterlist.h but this broke
um:

In file included from init/main.c:75:0:
include/linux/blkdev.h:25:29: fatal error: asm/scatterlist.h:
        No such file or directory

Make um use the generic scatterlist.h as well

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild test robot <fengguang.wu@intel.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2 arch/um/include/asm/Kbuild
--- a/arch/um/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2
+++ a/arch/um/include/asm/Kbuild
@@ -21,6 +21,7 @@ generic-y += param.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += preempt.h
+generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += switch_to.h
 generic-y += topology.h
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch

