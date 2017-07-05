From: akpm@linux-foundation.org
Subject: + ia64-sn-pci-move-inline-before-type.patch added to -mm tree
Date: Wed, 05 Jul 2017 13:45:16 -0700
Message-ID: <595d4fdc.yadh4YchZdXFetGK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753326AbdGEUpR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: sn: pci: move inline before type
has been added to the -mm tree.  Its filename is
     ia64-sn-pci-move-inline-before-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ia64-sn-pci-move-inline-before-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ia64-sn-pci-move-inline-before-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ia64: sn: pci: move inline before type

Make the use of inline like the rest of the kernel.

Link: http://lkml.kernel.org/r/f42b2202bd0d4e7ccf79ce5348bb255a035e67bb.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/pci/pcibr/pcibr_ate.c |    2 +-
 arch/ia64/sn/pci/tioce_provider.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/sn/pci/pcibr/pcibr_ate.c~ia64-sn-pci-move-inline-before-type arch/ia64/sn/pci/pcibr/pcibr_ate.c
--- a/arch/ia64/sn/pci/pcibr/pcibr_ate.c~ia64-sn-pci-move-inline-before-type
+++ a/arch/ia64/sn/pci/pcibr/pcibr_ate.c
@@ -140,7 +140,7 @@ static inline u64 __iomem *pcibr_ate_add
 /*
  * Update the ate.
  */
-void inline
+inline void
 ate_write(struct pcibus_info *pcibus_info, int ate_index, int count,
 	  volatile u64 ate)
 {
diff -puN arch/ia64/sn/pci/tioce_provider.c~ia64-sn-pci-move-inline-before-type arch/ia64/sn/pci/tioce_provider.c
--- a/arch/ia64/sn/pci/tioce_provider.c~ia64-sn-pci-move-inline-before-type
+++ a/arch/ia64/sn/pci/tioce_provider.c
@@ -52,7 +52,7 @@
  * All registers defined in struct tioce will meet that criteria.
  */
 
-static void inline
+static inline void
 tioce_mmr_war_pre(struct tioce_kernel *kern, void __iomem *mmr_addr)
 {
 	u64 mmr_base;
@@ -78,7 +78,7 @@ tioce_mmr_war_pre(struct tioce_kernel *k
 	}
 }
 
-static void inline
+static inline void
 tioce_mmr_war_post(struct tioce_kernel *kern, void __iomem *mmr_addr)
 {
 	u64 mmr_base;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

