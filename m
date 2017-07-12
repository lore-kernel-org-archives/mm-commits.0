From: akpm@linux-foundation.org
Subject: [patch 85/96] ia64: sn: pci: move inline before type
Date: Wed, 12 Jul 2017 14:37:19 -0700
Message-ID: <20170712213719.6i93NiVEc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55246 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVhZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fenghua.yu@intel.com, joe@perches.com, mm-commits@vger.kernel.org, tony.luck@intel.com, torvalds@linux-foundation.org

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
