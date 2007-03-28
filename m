From: akpm@linux-foundation.org
Subject: + x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch added to -mm tree
Date: Wed, 28 Mar 2007 15:37:09 -0700
Message-ID: <200703282237.l2SMb9go021764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34313 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933921AbXC1Whk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 18:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, ak@suse.de


The patch titled
     x86_64 : move __vgetcpu_mode & __jiffies  to the vsyscall_2 zone
has been added to the -mm tree.  Its filename is
     x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 : move __vgetcpu_mode & __jiffies  to the vsyscall_2 zone
From: Eric Dumazet <dada1@cosmosbay.com>

We apparently hit the 1024 limit of vsyscall_0 zone when some debugging
options are set, or if __vsyscall_gtod_data is 64 bytes larger.

In order to save 128 bytes from the vsyscall_0 zone, we move __vgetcpu_mode
& __jiffies to vsyscall_2 zone where they really belong, since they are
used only from vgetcpu() (which is in this vsyscall_2 area).

After patch is applied, new layout is :

ffffffffff600000 T vgettimeofday
ffffffffff60004e t vsysc2
ffffffffff600140 t vread_hpet
ffffffffff600150 t vread_tsc
ffffffffff600180 D __vsyscall_gtod_data
ffffffffff600400 T vtime
ffffffffff600413 t vsysc1
ffffffffff600800 T vgetcpu
ffffffffff600870 D __vgetcpu_mode
ffffffffff600880 D __jiffies
ffffffffff600c00 T venosys_1

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vmlinux.lds.S |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/vmlinux.lds.S~x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -95,6 +95,12 @@ SECTIONS
 		{ *(.vsyscall_gtod_data) }
   vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
 
+
+  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
+		{ *(.vsyscall_1) }
+  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
+		{ *(.vsyscall_2) }
+
   .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { *(.vgetcpu_mode) }
   vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
@@ -102,10 +108,6 @@ SECTIONS
   .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
   jiffies = VVIRT(.jiffies);
 
-  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
-		{ *(.vsyscall_1) }
-  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
-		{ *(.vsyscall_2) }
   .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3))
 		{ *(.vsyscall_3) }
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
