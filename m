From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-cleanups.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:45 -0700
Message-ID: <200710180701.l9I71jC0031203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763704AbXJRHQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     spin_lock_unlocked cleanups
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spin_lock_unlocked cleanups
From: roel <12o3l@tiscali.nl>

Replace some SPIN_LOCK_UNLOCKED with DEFINE_SPINLOCK

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/pci/ops-pmcmsp.c |    2 +-
 arch/powerpc/mm/slice.c    |    2 +-
 fs/sysfs/dir.c             |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/mips/pci/ops-pmcmsp.c~spin_lock_unlocked-cleanups arch/mips/pci/ops-pmcmsp.c
--- a/arch/mips/pci/ops-pmcmsp.c~spin_lock_unlocked-cleanups
+++ a/arch/mips/pci/ops-pmcmsp.c
@@ -206,7 +206,7 @@ static void pci_proc_init(void)
 }
 #endif /* CONFIG_PROC_FS && PCI_COUNTERS */
 
-spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(bpci_lock);
 
 /*****************************************************************************
  *
diff -puN arch/powerpc/mm/slice.c~spin_lock_unlocked-cleanups arch/powerpc/mm/slice.c
--- a/arch/powerpc/mm/slice.c~spin_lock_unlocked-cleanups
+++ a/arch/powerpc/mm/slice.c
@@ -34,7 +34,7 @@
 #include <asm/mmu.h>
 #include <asm/spu.h>
 
-static spinlock_t slice_convert_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(slice_convert_lock);
 
 
 #ifdef DEBUG
diff -puN fs/sysfs/dir.c~spin_lock_unlocked-cleanups fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~spin_lock_unlocked-cleanups
+++ a/fs/sysfs/dir.c
@@ -24,9 +24,9 @@
 
 DEFINE_MUTEX(sysfs_mutex);
 DEFINE_MUTEX(sysfs_rename_mutex);
-spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(sysfs_assoc_lock);
 
-static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sysfs_ino_lock);
 static DEFINE_IDA(sysfs_ino_ida);
 
 /**
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
