From: akpm@linux-foundation.org
Subject: [merged] mm-ia64-fix-a-memory-block-size-bug.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:04:45 -0700
Message-ID: <20120918190446.6E8AC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57839 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2IRTEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:04:49 -0400
Received: by eekd4 with SMTP id d4so8526eek.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:04:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wujianguo@huawei.com, jiang.liu@huawei.com, mhocko@suse.cz, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ia64: fix a memory block size bug
has been removed from the -mm tree.  Its filename was
     mm-ia64-fix-a-memory-block-size-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/ia64: fix a memory block size bug

I found following definition in include/linux/memory.h, in my IA64
platform, SECTION_SIZE_BITS is equal to 32, and MIN_MEMORY_BLOCK_SIZE will be 0.

#define MIN_MEMORY_BLOCK_SIZE     (1 << SECTION_SIZE_BITS)

Because MIN_MEMORY_BLOCK_SIZE is int type and length of 32bits,
so MIN_MEMORY_BLOCK_SIZE(1 << 32) will will equal to 0.
Actually when SECTION_SIZE_BITS >= 31, MIN_MEMORY_BLOCK_SIZE will be wrong.
This will cause wrong system memory infomation in sysfs.
I think it should be:

#define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)

And "echo offline > memory0/state" will cause following call trace:

kernel BUG at mm/memory_hotplug.c:885!
sh[6455]: bugcheck! 0 [1]

Pid: 6455, CPU 0, comm:                   sh
psr : 0000101008526030 ifs : 8000000000000fa4 ip  : [<a0000001008c40f0>]    Not tainted (3.6.0-rc1)
ip is at offline_pages+0x210/0xee0
unat: 0000000000000000 pfs : 0000000000000fa4 rsc : 0000000000000003
rnat: a0000001008f2d50 bsps: 0000000000000000 pr  : 65519a96659a9565
ldrs: 0000000000000000 ccv : 0000010b9263f310 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001008c40f0 b6  : a000000100473980 b7  : a0000001000106d0
f6  : 000000000000000000000 f7  : 1003e0000000085c9354c
f8  : 1003e0044b82fa09b5a53 f9  : 1003e000000d65cd62abf
f10 : 1003efd02efdec682803d f11 : 1003e0000000000000042
r1  : a00000010152c2e0 r2  : 0000000000006ada r3  : 000000000000fffe
r8  : 0000000000000026 r9  : a00000010121cc18 r10 : a0000001013309f0
r11 : 65519a96659a19e9 r12 : e00000070a91fdf0 r13 : e00000070a910000
r14 : 0000000000006ada r15 : 0000000000004000 r16 : 000000006ad8356c
r17 : a0000001019a525e r18 : 0000000000007fff r19 : 0000000000000000
r20 : 0000000000006ad6 r21 : 0000000000006ad6 r22 : a00000010133bec8
r23 : 0000000000006ad4 r24 : 0000000000000002 r25 : 8200000000260038
r26 : 00000000000004f9 r27 : 00000000000004f8 r28 : 000000000001cf98
r29 : 0000000000000038 r30 : a0000001019a5ae0 r31 : 000000000001cf60

Call Trace:
 [<a0000001000163e0>] show_stack+0x80/0xa0
                                sp=e00000070a91f9b0 bsp=e00000070a9115e0
 [<a000000100016a40>] show_regs+0x640/0x920
                                sp=e00000070a91fb80 bsp=e00000070a911588
 [<a000000100040590>] die+0x190/0x2c0
                                sp=e00000070a91fb90 bsp=e00000070a911548
 [<a000000100040710>] die_if_kernel+0x50/0x80
                                sp=e00000070a91fb90 bsp=e00000070a911518
 [<a0000001008f8030>] ia64_bad_break+0x3d0/0x6e0
                                sp=e00000070a91fb90 bsp=e00000070a9114f0
 [<a00000010000c0c0>] ia64_native_leave_kernel+0x0/0x270
                                sp=e00000070a91fc20 bsp=e00000070a9114f0
 [<a0000001008c40f0>] offline_pages+0x210/0xee0
                                sp=e00000070a91fdf0 bsp=e00000070a9113c8
 [<a00000010022d580>] alloc_pages_current+0x180/0x2a0
                                sp=e00000070a91fe20 bsp=e00000070a9113a

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memory.h~mm-ia64-fix-a-memory-block-size-bug include/linux/memory.h
--- a/include/linux/memory.h~mm-ia64-fix-a-memory-block-size-bug
+++ a/include/linux/memory.h
@@ -19,7 +19,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 
-#define MIN_MEMORY_BLOCK_SIZE     (1 << SECTION_SIZE_BITS)
+#define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
 struct memory_block {
 	unsigned long start_section_nr;
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch
linux-next.patch
mm-fix-up-zone-present-pages.patch

