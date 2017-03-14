From: akpm@linux-foundation.org
Subject: +
 kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
 added to -mm tree
Date: Tue, 14 Mar 2017 14:06:51 -0700
Message-ID: <58c85b6b.avTM2K/IGHhODWbQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdCNVGx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2017 17:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, mark.rutland@arm.com, mingo@redhat.com, peterz@infradead.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: allow kasan_check_read/write() to accept pointers to volatiles
has been added to the -mm tree.  Its filename is
     kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: allow kasan_check_read/write() to accept pointers to volatiles

Patch series "x86, kasan: add KASAN checks to atomic operations".

KASAN uses compiler instrumentation to intercept all memory accesses.  But
it does not see memory accesses done in assembly code.  One notable user
of assembly code is atomic operations.  Frequently, for example, an atomic
reference decrement is the last access to an object and a good candidate
for a racy use-after-free.

Atomic operations are defined in arch files, but KASAN instrumentation is
required for several archs that support KASAN.  Later we will need similar
hooks for KMSAN (uninit use detector) and KTSAN (data race detector).

This change introduces wrappers around atomic operations that can be used
to add KASAN/KMSAN/KTSAN instrumentation across several archs, and adds
KASAN checks to them.

This patch uses the wrappers only for x86 arch.  Arm64 will be switched
later.  And we also plan to instrument bitops in a similar way.

Within a day it has found its first bug:

BUG: KASAN: use-after-free in atomic_dec_and_test
arch/x86/include/asm/atomic.h:123 [inline] at addr ffff880079c30158
Write of size 4 by task syz-executor6/25698
CPU: 2 PID: 25698 Comm: syz-executor6 Not tainted 4.10.0+ #302
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 kasan_check_write+0x14/0x20 mm/kasan/kasan.c:344
 atomic_dec_and_test arch/x86/include/asm/atomic.h:123 [inline]
 put_task_struct include/linux/sched/task.h:93 [inline]
 put_ctx+0xcf/0x110 kernel/events/core.c:1131
 perf_event_release_kernel+0x3ad/0xc90 kernel/events/core.c:4322
 perf_release+0x37/0x50 kernel/events/core.c:4338
 __fput+0x332/0x800 fs/file_table.c:209
 ____fput+0x15/0x20 fs/file_table.c:245
 task_work_run+0x197/0x260 kernel/task_work.c:116
 exit_task_work include/linux/task_work.h:21 [inline]
 do_exit+0xb38/0x29c0 kernel/exit.c:880
 do_group_exit+0x149/0x420 kernel/exit.c:984
 get_signal+0x7e0/0x1820 kernel/signal.c:2318
 do_signal+0xd2/0x2190 arch/x86/kernel/signal.c:808
 exit_to_usermode_loop+0x200/0x2a0 arch/x86/entry/common.c:157
 syscall_return_slowpath arch/x86/entry/common.c:191 [inline]
 do_syscall_64+0x6fc/0x930 arch/x86/entry/common.c:286
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x4458d9
RSP: 002b:00007f3f07187cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000007080c8 RCX: 00000000004458d9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000007080c8
RBP: 00000000007080a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f3f071889c0 R15: 00007f3f07188700
Object at ffff880079c30140, in cache task_struct size: 5376
Allocated:
PID = 25681
 kmem_cache_alloc_node+0x122/0x6f0 mm/slab.c:3662
 alloc_task_struct_node kernel/fork.c:153 [inline]
 dup_task_struct kernel/fork.c:495 [inline]
 copy_process.part.38+0x19c8/0x4aa0 kernel/fork.c:1560
 copy_process kernel/fork.c:1531 [inline]
 _do_fork+0x200/0x1010 kernel/fork.c:1994
 SYSC_clone kernel/fork.c:2104 [inline]
 SyS_clone+0x37/0x50 kernel/fork.c:2098
 do_syscall_64+0x2e8/0x930 arch/x86/entry/common.c:281
 return_from_SYSCALL_64+0x0/0x7a
Freed:
PID = 25681
 __cache_free mm/slab.c:3514 [inline]
 kmem_cache_free+0x71/0x240 mm/slab.c:3774
 free_task_struct kernel/fork.c:158 [inline]
 free_task+0x151/0x1d0 kernel/fork.c:370
 copy_process.part.38+0x18e5/0x4aa0 kernel/fork.c:1931
 copy_process kernel/fork.c:1531 [inline]
 _do_fork+0x200/0x1010 kernel/fork.c:1994
 SYSC_clone kernel/fork.c:2104 [inline]
 SyS_clone+0x37/0x50 kernel/fork.c:2098
 do_syscall_64+0x2e8/0x930 arch/x86/entry/common.c:281
 return_from_SYSCALL_64+0x0/0x7a


This patch (of 3):

Currently kasan_check_read/write() accept 'const void*', make them accept
'const volatile void*'.  This is required for instrumentation of atomic
operations and there is just no reason to not allow that.

Link: http://lkml.kernel.org/r/b47f7c2e3445cf48493a1504247e6794232cc073.1489519233.git.dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan-checks.h |   10 ++++++----
 mm/kasan/kasan.c             |    4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/kasan-checks.h~kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles include/linux/kasan-checks.h
--- a/include/linux/kasan-checks.h~kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles
+++ a/include/linux/kasan-checks.h
@@ -2,11 +2,13 @@
 #define _LINUX_KASAN_CHECKS_H
 
 #ifdef CONFIG_KASAN
-void kasan_check_read(const void *p, unsigned int size);
-void kasan_check_write(const void *p, unsigned int size);
+void kasan_check_read(const volatile void *p, unsigned int size);
+void kasan_check_write(const volatile void *p, unsigned int size);
 #else
-static inline void kasan_check_read(const void *p, unsigned int size) { }
-static inline void kasan_check_write(const void *p, unsigned int size) { }
+static inline void kasan_check_read(const volatile void *p, unsigned int size)
+{ }
+static inline void kasan_check_write(const volatile void *p, unsigned int size)
+{ }
 #endif
 
 #endif
diff -puN mm/kasan/kasan.c~kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles
+++ a/mm/kasan/kasan.c
@@ -333,13 +333,13 @@ static void check_memory_region(unsigned
 	check_memory_region_inline(addr, size, write, ret_ip);
 }
 
-void kasan_check_read(const void *p, unsigned int size)
+void kasan_check_read(const volatile void *p, unsigned int size)
 {
 	check_memory_region((unsigned long)p, size, false, _RET_IP_);
 }
 EXPORT_SYMBOL(kasan_check_read);
 
-void kasan_check_write(const void *p, unsigned int size)
+void kasan_check_write(const volatile void *p, unsigned int size)
 {
 	check_memory_region((unsigned long)p, size, true, _RET_IP_);
 }
_

Patches currently in -mm which might be from dvyukov@google.com are

mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal.patch
kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
asm-generic-x86-wrap-atomic-operations.patch
asm-generic-add-kasan-instrumentation-to-atomic-operations.patch

