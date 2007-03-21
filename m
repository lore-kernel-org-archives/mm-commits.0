From: akpm@linux-foundation.org
Subject: + nommu-make-sysv-shm-nattch-work-correctly.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:38:57 -0700
Message-ID: <200703212338.l2LNcvYF007128@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbXCUXjK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     NOMMU: make SYSV SHM nattch work correctly
has been added to the -mm tree.  Its filename is
     nommu-make-sysv-shm-nattch-work-correctly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NOMMU: make SYSV SHM nattch work correctly
From: David Howells <dhowells@redhat.com>

Make the SYSV SHM nattch counter work correctly by forcing multiple VMAs to
be produced to represent MAP_SHARED segments, even if they overlap exactly.

Using this test program:

	http://people.redhat.com/~dhowells/doshm.c

Run as:

	doshm sysv

I can see nattch going from one before the patch:

	# /doshm sysv
	Command: sysv
	shmid: 65536
	memory: 0xc3700000
	c0b00000-c0b04000 rw-p 00000000 00:00 0
	c0bb0000-c0bba788 r-xs 00000000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3180000-c31dede4 r-xs 00000000 00:0b 14582179  /lib/libuClibc-0.9.28.so
	c3520000-c352278c rw-p 00000000 00:0b 13763417  /doshm
	c3584000-c35865e8 r-xs 00000000 00:0b 13763417  /doshm
	c3588000-c358aa00 rw-p 00008000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3590000-c359b6c0 rw-p 00000000 00:00 0
	c3620000-c3640000 rwxp 00000000 00:00 0
	c3700000-c37fa000 rw-S 00000000 00:06 1411      /SYSV00000000 (deleted)
	c3700000-c37fa000 rw-S 00000000 00:06 1411      /SYSV00000000 (deleted)
	nattch 1

To two after the patch:

	# /doshm sysv
	Command: sysv
	shmid: 0
	memory: 0xc3700000
	c0bb0000-c0bba788 r-xs 00000000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3180000-c31dede4 r-xs 00000000 00:0b 14582179  /lib/libuClibc-0.9.28.so
	c3320000-c3340000 rwxp 00000000 00:00 0
	c3530000-c35325e8 r-xs 00000000 00:0b 13763417  /doshm
	c3534000-c353678c rw-p 00000000 00:0b 13763417  /doshm
	c3538000-c353aa00 rw-p 00008000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3590000-c359b6c0 rw-p 00000000 00:00 0
	c35a4000-c35a8000 rw-p 00000000 00:00 0
	c3700000-c37fa000 rw-S 00000000 00:06 1369      /SYSV00000000 (deleted)
	c3700000-c37fa000 rw-S 00000000 00:06 1369      /SYSV00000000 (deleted)
	nattch 2

That's +1 to nattch for each shmat() made.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN mm/nommu.c~nommu-make-sysv-shm-nattch-work-correctly mm/nommu.c
--- a/mm/nommu.c~nommu-make-sysv-shm-nattch-work-correctly
+++ a/mm/nommu.c
@@ -826,6 +826,11 @@ unsigned long do_mmap_pgoff(struct file 
 		unsigned long pglen = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		unsigned long vmpglen;
 
+		/* suppress VMA sharing for shared regions */
+		if (vm_flags & VM_SHARED &&
+		    capabilities & BDI_CAP_MAP_DIRECT)
+			goto dont_share_VMAs;
+
 		for (rb = rb_first(&nommu_vma_tree); rb; rb = rb_next(rb)) {
 			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
 
@@ -859,6 +864,7 @@ unsigned long do_mmap_pgoff(struct file 
 			goto shared;
 		}
 
+	dont_share_VMAs:
 		vma = NULL;
 
 		/* obtain the address at which to make a shared mapping
_

Patches currently in -mm which might be from dhowells@redhat.com are

frv-fix-unannotated-variable-declarations.patch
nommu-supply-get_unmapped_area-to-fix-nommu-sysv-shm.patch
nommu-make-sysv-shm-nattch-work-correctly.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
nommu-hide-vm_mm-in-nommu-mode.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
mutex-subsystem-synchro-test-module.patch
