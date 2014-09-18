From: akpm@linux-foundation.org
Subject: +
 frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error.patch
 added to -mm tree
Date: Thu, 18 Sep 2014 14:48:59 -0700
Message-ID: <541b534b.QDcA5Ca8rCd6rtD3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbaIRVtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, dhowells@redhat.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: remove unused cpuinfo_frv and friends to fix future build error
has been added to the -mm tree.  Its filename is
     frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: frv: remove unused cpuinfo_frv and friends to fix future build error

Frv has a macro named cpu_data, interfering with variables and struct
members with the same name:

include/linux/pm_domain.h:75:24: error: expected identifier or '('
before '&' token
  struct gpd_cpu_data *cpu_data;

As struct cpuinfo_frv, boot_cpu_data, cpu_data, and current_cpu_data are
not used, removed them to fix this.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/processor.h |   16 ----------------
 arch/frv/kernel/setup.c          |    2 --
 2 files changed, 18 deletions(-)

diff -puN arch/frv/include/asm/processor.h~frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error arch/frv/include/asm/processor.h
--- a/arch/frv/include/asm/processor.h~frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error
+++ a/arch/frv/include/asm/processor.h
@@ -35,22 +35,6 @@
 struct task_struct;
 
 /*
- *  CPU type and hardware bug flags. Kept separately for each CPU.
- */
-struct cpuinfo_frv {
-#ifdef CONFIG_MMU
-	unsigned long	*pgd_quick;
-	unsigned long	*pte_quick;
-	unsigned long	pgtable_cache_sz;
-#endif
-} __cacheline_aligned;
-
-extern struct cpuinfo_frv __nongprelbss boot_cpu_data;
-
-#define cpu_data		(&boot_cpu_data)
-#define current_cpu_data	boot_cpu_data
-
-/*
  * Bus types
  */
 #define EISA_bus 0
diff -puN arch/frv/kernel/setup.c~frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error
+++ a/arch/frv/kernel/setup.c
@@ -104,8 +104,6 @@ unsigned long __nongprelbss dma_coherent
 unsigned long __initdata __sdram_old_base;
 unsigned long __initdata num_mappedpages;
 
-struct cpuinfo_frv __nongprelbss boot_cpu_data;
