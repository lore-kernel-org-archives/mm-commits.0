From: akpm@linux-foundation.org
Subject: +
 lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch added
 to -mm tree
Date: Wed, 16 Apr 2014 12:06:44 -0700
Message-ID: <534ed4c4.F9G1Hdf/UieeRKmT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbaDPTGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at, jdike@addtoit.com, fengguang.wu@intel.com, lauraa@codeaurora.org

Subject: + lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch added to -mm tree
To: lauraa@codeaurora.org,fengguang.wu@intel.com,jdike@addtoit.com,richard@nod.at
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:06:44 -0700


The patch titled
     Subject: um: use asm-generic/scatterlist.h
has been added to the -mm tree.  Its filename is
     lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-compactionc-isolate_freepages_block-small-tuneup.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch
debugging-keep-track-of-page-owners.patch

