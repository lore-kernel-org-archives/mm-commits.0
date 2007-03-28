From: akpm@linux-foundation.org
Subject: + x86_64-fix-vtime-vsyscall.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:48:57 -0700
Message-ID: <200703282348.l2SNmvgB023031@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965814AbXC1Xt2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, ak@suse.de


The patch titled
     x86_64: fix vtime() vsyscall
has been added to the -mm tree.  Its filename is
     x86_64-fix-vtime-vsyscall.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fix vtime() vsyscall
From: Eric Dumazet <dada1@cosmosbay.com>

There is a tiny probability that the return value from vtime(time_t *t) is
different from the value stored in *t.

Using a temporary variable solves the problem and gives a faster code.

   17:   48 85 ff                test   %rdi,%rdi
   1a:   48 8b 05 00 00 00 00    mov    0(%rip),%rax        #
__vsyscall_gtod_data.wall_time_tv.tv_sec
   21:   74 03                   je     26
   23:   48 89 07                mov    %rax,(%rdi)
   26:   c9                      leaveq
   27:   c3                      retq

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vsyscall.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86_64/kernel/vsyscall.c~x86_64-fix-vtime-vsyscall arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~x86_64-fix-vtime-vsyscall
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -147,15 +147,15 @@ int __vsyscall(0) vgettimeofday(struct t
 	return 0;
 }
 
-/* This will break when the xtime seconds get inaccurate, but that is
- * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
+	time_t result;
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
-	else if (t)
-		*t = __vsyscall_gtod_data.wall_time_tv.tv_sec;
-	return __vsyscall_gtod_data.wall_time_tv.tv_sec;
+	result = __vsyscall_gtod_data.wall_time_tv.tv_sec;
+	if (t)
+		*t = result;
+	return result;
 }
 
 /* Fast way to get current CPU and node.
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch
x86_64-fix-vtime-vsyscall.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
