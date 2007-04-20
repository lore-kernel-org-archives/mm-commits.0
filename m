From: akpm@linux-foundation.org
Subject: + spin_lock_unlocked-cleanup-in-arch-m68k.patch added to -mm tree
Date: Thu, 19 Apr 2007 20:24:41 -0700
Message-ID: <200704200324.l3K3OftW005948@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbXDTDYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 23:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in arch/m68k
has been added to the -mm tree.  Its filename is
     spin_lock_unlocked-cleanup-in-arch-m68k.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in arch/m68k
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/amiints.c  |    2 +-
 arch/m68k/amiga/cia.c      |    4 ++--
 arch/m68k/apollo/dn_ints.c |    2 +-
 arch/m68k/atari/ataints.c  |    2 +-
 arch/m68k/kernel/ints.c    |    4 ++--
 arch/m68k/mac/macints.c    |    2 +-
 arch/m68k/q40/q40ints.c    |    2 +-
 arch/m68k/sun3/sun3ints.c  |    2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/m68k/amiga/amiints.c~spin_lock_unlocked-cleanup-in-arch-m68k arch/m68k/amiga/amiints.c
--- a/arch/m68k/amiga/amiints.c~spin_lock_unlocked-cleanup-in-arch-m68k
+++ a/arch/m68k/amiga/amiints.c
@@ -54,7 +54,7 @@ static irqreturn_t ami_int5(int irq, voi
 
 static struct irq_controller amiga_irq_controller = {
 	.name		= "amiga",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(amiga_irq_controller.lock),
 	.enable		= amiga_enable_irq,
 	.disable	= amiga_disable_irq,
 };
diff -puN arch/m68k/amiga/cia.c~spin_lock_unlocked-cleanup-in-arch-m68k arch/m68k/amiga/cia.c
--- a/arch/m68k/amiga/cia.c~spin_lock_unlocked-cleanup-in-arch-m68k
+++ a/arch/m68k/amiga/cia.c
@@ -123,7 +123,7 @@ static void cia_disable_irq(unsigned int
 
 static struct irq_controller cia_irq_controller = {
 	.name		= "cia",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(cia_irq_controller.lock),
 	.enable		= cia_enable_irq,
 	.disable	= cia_disable_irq,
 };
@@ -160,7 +160,7 @@ static void auto_disable_irq(unsigned in
 
 static struct irq_controller auto_irq_controller = {
 	.name		= "auto",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(auto_irq_controller.lock),
 	.enable		= auto_enable_irq,
 	.disable	= auto_disable_irq,
 };
diff -puN arch/m68k/apollo/dn_ints.c~spin_lock_unlocked-cleanup-in-arch-m68k arch/m68k/apollo/dn_ints.c
--- a/arch/m68k/apollo/dn_ints.c~spin_lock_unlocked-cleanup-in-arch-m68k
+++ a/arch/m68k/apollo/dn_ints.c
@@ -31,7 +31,7 @@ void apollo_irq_shutdown(unsigned int ir
 
 static struct irq_controller apollo_irq_controller = {
 	.name           = "apollo",
-	.lock           = SPIN_LOCK_UNLOCKED,
+	.lock           = __SPIN_LOCK_UNLOCKED(apollo_irq_controller.lock),
 	.startup        = apollo_irq_startup,
 	.shutdown       = apollo_irq_shutdown,
 };
diff -puN arch/m68k/atari/ataints.c~spin_lock_unlocked-cleanup-in-arch-m68k arch/m68k/atari/ataints.c
--- a/arch/m68k/atari/ataints.c~spin_lock_unlocked-cleanup-in-arch-m68k
+++ a/arch/m68k/atari/ataints.c
@@ -339,7 +339,7 @@ static void atari_shutdown_irq(unsigned 
 
 static struct irq_controller atari_irq_controller = {
 	.name		= "atari",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(atari_irq_controller.lock),
 	.startup	= atari_startup_irq,
 	.shutdown	= atari_shutdown_irq,
 	.enable		= atari_enable_irq,
diff -puN arch/m68k/kernel/ints.c~spin_lock_unlocked-cleanup-in-arch-m68k arch/m68k/kernel/ints.c
--- a/arch/m68k/kernel/ints.c~spin_lock_unlocked-cleanup-in-arch-m68k
+++ a/arch/m68k/kernel/ints.c
@@ -59,14 +59,14 @@ static int m68k_first_user_vec;
 
 static struct irq_controller auto_irq_controller = {
 	.name		= "auto",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(auto_irq_controller.lock),
 	.startup	= m68k_irq_startup,
 	.shutdown	= m68k_irq_shutdown,
 };
 
 static struct irq_controller user_irq_controller = {
 	.name		= "user",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(user_irq_controller.lock),
 	.startup	= m68k_irq_startup,
 	.shutdown	= m68k_irq_shutdown,
 };
diff -puN arch/m68k/mac/macints.c~spin_lock_unlocked-cleanup-in-arch-m68k arch/m68k/mac/macints.c
--- a/arch/m68k/mac/macints.c~spin_lock_unlocked-cleanup-in-arch-m68k
+++ a/arch/m68k/mac/macints.c
@@ -219,7 +219,7 @@ static void mac_disable_irq(unsigned int
 
 static struct irq_controller mac_irq_controller = {
 	.name		= "mac",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(mac_irq_controller.lock),
 	.enable		= mac_enable_irq,
 	.disable	= mac_disable_irq,
 };
diff -puN arch/m68k/q40/q40ints.c~spin_lock_unlocked-cleanup-in-arch-m68k arch/m68k/q40/q40ints.c
--- a/arch/m68k/q40/q40ints.c~spin_lock_unlocked-cleanup-in-arch-m68k
+++ a/arch/m68k/q40/q40ints.c
@@ -59,7 +59,7 @@ static void q40_irq_shutdown(unsigned in
 
 static struct irq_controller q40_irq_controller = {
 	.name		= "q40",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(q40_irq_controller.lock),
 	.startup	= q40_irq_startup,
 	.shutdown	= q40_irq_shutdown,
 	.enable		= q40_enable_irq,
diff -puN arch/m68k/sun3/sun3ints.c~spin_lock_unlocked-cleanup-in-arch-m68k arch/m68k/sun3/sun3ints.c
--- a/arch/m68k/sun3/sun3ints.c~spin_lock_unlocked-cleanup-in-arch-m68k
+++ a/arch/m68k/sun3/sun3ints.c
@@ -90,7 +90,7 @@ static void sun3_inthandle(unsigned int 
 
 static struct irq_controller sun3_irq_controller = {
 	.name		= "sun3",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(sun3_irq_controller.lock),
 	.startup	= m68k_irq_startup,
 	.shutdown	= m68k_irq_shutdown,
 	.enable		= sun3_enable_irq,
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
git-ieee1394.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
spin_lock_unlocked-cleanup-in-arch-mips.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
spin_lock_unlocked-cleanup-in-drivers-atm-net.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
spin_lock_unlocked-cleanup-in-drivers-s390.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
