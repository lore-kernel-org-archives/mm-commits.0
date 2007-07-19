From: akpm@linux-foundation.org
Subject: + anon_inodes-shouldnt-be-user-visible.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:54:20 -0700
Message-ID: <200707192354.l6JNsKok029446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934284AbXGSXzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, davidel@xmailserver.org


The patch titled
     ANON_INODES shouldn't be user visible
has been added to the -mm tree.  Its filename is
     anon_inodes-shouldnt-be-user-visible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ANON_INODES shouldn't be user visible
From: Adrian Bunk <bunk@stusta.de>

There doesn't seem to be a good reason for ANON_INODES being
an user visible option.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff -puN init/Kconfig~anon_inodes-shouldnt-be-user-visible init/Kconfig
--- a/init/Kconfig~anon_inodes-shouldnt-be-user-visible
+++ a/init/Kconfig
@@ -468,25 +468,19 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config ANON_INODES
-	bool "Enable anonymous inode source" if EMBEDDED
-	default y
-	help
-	  Anonymous inode source for pseudo-files like epoll, signalfd,
-	  timerfd and eventfd.
-
-	  If unsure, say Y.
+	bool
 
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
-	depends on ANON_INODES
+	select ANON_INODES
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
 
 config SIGNALFD
 	bool "Enable signalfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the signalfd() system call that allows to receive signals
@@ -496,7 +490,7 @@ config SIGNALFD
 
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer
@@ -506,7 +500,7 @@ config TIMERFD
 
 config EVENTFD
 	bool "Enable eventfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the eventfd() system call that allows to receive both
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
