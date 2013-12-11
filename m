From: akpm@linux-foundation.org
Subject: + futex-switch-to-user_ds-for-futex-test.patch added to -mm tree
Date: Wed, 11 Dec 2013 15:10:07 -0800
Message-ID: <52a8f0cf.j+jbb2xgrlIp7r9d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3LKXKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:10:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tuxist@tuxist.de, tglx@linutronix.de, stable@vger.kernel.org, schwab@linux-m68k.org, rusty@rustcorp.com.au, patrickjmc@gmail.com, fthain@telegraphics.com.au, dvhart@linux.intel.com, geert@linux-m68k.org

Subject: + futex-switch-to-user_ds-for-futex-test.patch added to -mm tree
To: geert@linux-m68k.org,dvhart@linux.intel.com,fthain@telegraphics.com.au,patrickjmc@gmail.com,rusty@rustcorp.com.au,schwab@linux-m68k.org,stable@vger.kernel.org,tglx@linutronix.de,tuxist@tuxist.de
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:10:07 -0800


The patch titled
     Subject: futex: switch to USER_DS for futex test
has been added to the -mm tree.  Its filename is
     futex-switch-to-user_ds-for-futex-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/futex-switch-to-user_ds-for-futex-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/futex-switch-to-user_ds-for-futex-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: futex: switch to USER_DS for futex test

Since e4f2dfbb5e92b ("m68k: implement futex.h to support userspace robust
futexes and PI mutexes"), the kernel crashes during boot up on MC68030:

Data read fault at 0x00000000 in Super Data (pc=0x3afec)
BAD KERNEL BUSERR
Oops: 00000000
Modules linked in:
PC: [<0003afec>] cmpxchg_futex_value_locked+0x14/0x4a
SR: 2004  SP: 0082fed4  a2: 0082c000
d0: 00000000    d1: 00000001    d2: 00000018    d3: 00000000
d4: 00000061    d5: 00001000    a0: 00000000    a1: 0082e000
Process swapper (pid: 1, task=0082c000)
Frame format=B ssw=074d isc=4a80 isb=661c daddr=00000000 dobuf=00000001
baddr=0003aff2 dibuf=00000000 ver=f
Stack from 0082ff5c:
        002b8cb8 0082ff70 00000000 00000000 00000000 00000000 00000000 000020ac
        00000018 00000007 00000061 00001000 00000000 00000000 002cab50 00002008
        002b3a56 002b8ca4 0082c3f0 00000000 0082c53c 001e316a 00000000 00000000
        001e3172 001e316a 000025d4 00000000 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 20000000
        00000000
Call Trace: [<002b8cb8>] futex_init+0x14/0x54
 [<000020ac>] do_one_initcall+0xa4/0x144
 [<00001000>] kernel_pg_dir+0x0/0x1000
 [<00002008>] do_one_initcall+0x0/0x144
 [<002b3a56>] kernel_init_freeable+0xca/0x152
 [<002b8ca4>] futex_init+0x0/0x54
 [<001e316a>] kernel_init+0x0/0xc8
 [<001e3172>] kernel_init+0x8/0xc8
 [<001e316a>] kernel_init+0x0/0xc8
 [<000025d4>] ret_from_kernel_thread+0xc/0x14

This happens because the futex test in futex_init() lacks a switch to the
USER_DS address space, while cmpxchg_futex_value_locked() and
futex_atomic_cmpxchg_inatomic() operate on userspace pointers (albeit NULL
for this particular test).

Fix this by switching to USER_DS before running the test, and restoring
the old address space afterwards.

Reported-by: Tuxist <tuxist@tuxist.de>
Reported-by: Patrick McCarthy <patrickjmc@gmail.com>
Bisected-by: Finn Thain <fthain@telegraphics.com.au>
Suggested-by: Andreas Schwab <schwab@linux-m68k.org>
Tested-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/futex.c~futex-switch-to-user_ds-for-futex-test kernel/futex.c
--- a/kernel/futex.c~futex-switch-to-user_ds-for-futex-test
+++ a/kernel/futex.c
@@ -63,6 +63,7 @@
 #include <linux/sched/rt.h>
 #include <linux/hugetlb.h>
 #include <linux/freezer.h>
+#include <linux/uaccess.h>
 
 #include <asm/futex.h>
 
@@ -2732,6 +2733,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
 
 static int __init futex_init(void)
 {
+	mm_segment_t fs;
 	u32 curval;
 	int i;
 
@@ -2745,8 +2747,11 @@ static int __init futex_init(void)
 	 * implementation, the non-functional ones will return
 	 * -ENOSYS.
 	 */
+	fs = get_fs();
+	set_fs(USER_DS);
 	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
 		futex_cmpxchg_enabled = 1;
+	set_fs(fs);
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
 		plist_head_init(&futex_queues[i].chain);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
rtc-s5m-enable-irq-wake-during-suspend.patch
mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
inith-add-missing-initcall-variants.patch
futex-switch-to-user_ds-for-futex-test.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

