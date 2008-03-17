From: akpm@linux-foundation.org
Subject: - ioc3-fix-section-missmatch.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:46 -0700
Message-ID: <200803172100.m2HL0k3V030881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773AbYCQVBM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:01:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     ioc3: fix section missmatch
has been removed from the -mm tree.  Its filename was
     ioc3-fix-section-missmatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ioc3: fix section missmatch
From: Ralf Baechle <ralf@linux-mips.org>

  LD      drivers/net/built-in.o
WARNING: drivers/net/built-in.o(.text+0x3468): Section mismatch in reference fro
m the function ioc3_probe() to the function .devinit.text:ioc3_serial_probe()
The function ioc3_probe() references
the function __devinit ioc3_serial_probe().
This is often because ioc3_probe lacks a __devinit
annotation or the annotation of ioc3_serial_probe is wrong.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ioc3-eth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/ioc3-eth.c~ioc3-fix-section-missmatch drivers/net/ioc3-eth.c
--- a/drivers/net/ioc3-eth.c~ioc3-fix-section-missmatch
+++ a/drivers/net/ioc3-eth.c
@@ -1221,7 +1221,8 @@ static void __devinit ioc3_serial_probe(
 }
 #endif
 
-static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit ioc3_probe(struct pci_dev *pdev,
+	const struct pci_device_id *ent)
 {
 	unsigned int sw_physid1, sw_physid2;
 	struct net_device *dev = NULL;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

pm-remove-legacy-pm.patch
mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls.patch
git-mips.patch
git-mips-git-rejects.patch
mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch
mips-replace-remaining-__function__-occurences.patch
git-net.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
mm-try-both-endianess-when-checking-for-endianess.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
asm-futexh-should-include-linux-uaccessh.patch
rename-div64_64-to-div64_u64.patch
remove-div_long_long_rem.patch

