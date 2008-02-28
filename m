From: akpm@linux-foundation.org
Subject: - make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it.patch removed from -mm tree
Date: Wed, 27 Feb 2008 16:33:59 -0800
Message-ID: <200802280034.m1S0Y03p006929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757540AbYB1Afe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:35:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, James.Bottomley@HansenPartnership.com, ben-linux@fluff.org, jesper.nilsson@axis.com, lethal@linux-sh.org, mikael.starvik@axis.com, mingo@elte.hu, samuel@sortiz.org, tglx@l


The patch titled
     Make all drivers that use dma_declare_coherent_memory depend on it
has been removed from the -mm tree.  Its filename was
     make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Make all drivers that use dma_declare_coherent_memory depend on it
From: Andi Kleen <ak@suse.de>

There are two users of dma_declare_coherent_memory in tree.  Make them
dependent on the architectures who actually implement that instead of falling
at runtime.  All cases I checked fail fataly (no recovery) so these drivers
will never work on these architectures.

I'm also a little puzzled why x86-64 allyesconfig worked with CONFIG_MFD_SM501
without this patch anyways.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig    |    5 +++++
 arch/sh/Kconfig      |    3 +++
 arch/x86/Kconfig     |    4 ++++
 drivers/mfd/Kconfig  |    1 +
 drivers/scsi/Kconfig |    2 +-
 5 files changed, 14 insertions(+), 1 deletion(-)

diff -puN arch/cris/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it arch/cris/Kconfig
--- a/arch/cris/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it
+++ a/arch/cris/Kconfig
@@ -47,6 +47,11 @@ config GENERIC_CALIBRATE_DELAY
 config NO_IOPORT
 	def_bool y
 
+config HAS_DMA_DECLARE_COHERENT
+	# looks weird, but it really depends on that
+	depends on ETRAX_CARDBUS
+	def_bool y
+
 config FORCE_MAX_ZONEORDER
 	int
 	default 6
diff -puN arch/sh/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it arch/sh/Kconfig
--- a/arch/sh/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it
+++ a/arch/sh/Kconfig
@@ -90,6 +90,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config HAS_DMA_DECLARE_COHERENT
+	def_boot y
+
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
diff -puN arch/x86/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it arch/x86/Kconfig
--- a/arch/x86/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it
+++ a/arch/x86/Kconfig
@@ -159,6 +159,10 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
+config HAS_DMA_DECLARE_COHERENT
+	def_bool y
+	depends on X86_32
+
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
diff -puN drivers/mfd/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it
+++ a/drivers/mfd/Kconfig
@@ -7,6 +7,7 @@ menu "Multifunction device drivers"
 
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
+	depends on HAS_DMA_DECLARE_COHERENT
 	 ---help---
 	  This is the core driver for the Silicon Motion SM501 multimedia
 	  companion chip. This device is a multifunction device which may
diff -puN drivers/scsi/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it
+++ a/drivers/scsi/Kconfig
@@ -1173,7 +1173,7 @@ config SCSI_ZALON
 
 config SCSI_NCR_Q720
 	tristate "NCR Quad 720 MCA SCSI support"
-	depends on MCA && SCSI
+	depends on MCA && SCSI && HAS_DMA_DECLARE_COHERENT
 	select SCSI_SPI_ATTRS
 	help
 	  This is a driver for the MicroChannel Quad 720 card produced by
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
update-checkpatchpl-to-version-015.patch
git-x86.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-ocfs2.patch
git-xfs.patch
make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it.patch
cris-remove-dma_declare_coherent_memory-etc.patch
remove-dmam_declarerelease_coherent_memory.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3-fix.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
profile-likely-unlikely-macros.patch
