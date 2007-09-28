From: akpm@linux-foundation.org
Subject: + spin_lock_unlocked-cleanups.patch added to -mm tree
Date: Fri, 28 Sep 2007 14:51:31 -0700
Message-ID: <200709282151.l8SLpVhS019241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbXI1VwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 17:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, tglx@linutronix.de


The patch titled
     spin_lock_unlocked cleanups
has been added to the -mm tree.  Its filename is
     spin_lock_unlocked-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spin_lock_unlocked cleanups
From: roel <12o3l@tiscali.nl>

Replace some SPIN_LOCK_UNLOCKED with DEFINE_SPINLOCK

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
diff -puN drivers/ieee1394/ieee1394_core.c~spin_lock_unlocked-cleanups drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c~spin_lock_unlocked-cleanups
+++ a/drivers/ieee1394/ieee1394_core.c
@@ -488,7 +488,7 @@ void hpsb_selfid_complete(struct hpsb_ho
 	highlevel_host_reset(host);
 }
 
-static spinlock_t pending_packets_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(pending_packets_lock);
 
 /**
  * hpsb_packet_sent - notify core of sending a packet
diff -puN fs/sysfs/dir.c~spin_lock_unlocked-cleanups fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~spin_lock_unlocked-cleanups
+++ a/fs/sysfs/dir.c
@@ -16,9 +16,9 @@
 
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

spin_lock_unlocked-cleanups.patch
