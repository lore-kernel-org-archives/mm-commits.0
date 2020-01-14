From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 07/11] mm/page-writeback.c: avoid potential division
 by zero in wb_min_max_ratio()
Date: Mon, 13 Jan 2020 16:29:23 -0800
Message-ID: <20200114002923.VHKO6%akpm__7406.92188717134$1578961880$gmane$org@linux-foundation.org>
References: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgANA3Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:24 -0500
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cai@lca.pw, axboe@kernel.dk, wenyang@linux.alibaba.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Wen Yang <wenyang@linux.alibaba.com>
Subject: mm/page-writeback.c: avoid potential division by zero in wb_min_max_ratio()

Patch series "use div64_ul() instead of div_u64() if the divisor is
unsigned long".

We were first inspired by commit b0ab99e7736a ("sched: Fix possible divide
by zero in avg_atom () calculation"), then refer to the recently analyzed
mm code, we found this suspicious place.

 201                 if (min) {
 202                         min *= this_bw;
 203                         do_div(min, tot_bw);
 204                 }

And we also disassembled and confirmed it:

/usr/src/debug/kernel-4.9.168-016.ali3000/linux-4.9.168-016.ali3000.alios7.x86_64/mm/page-writeback.c: 201
0xffffffff811c37da <__wb_calc_thresh+234>:      xor    %r10d,%r10d
0xffffffff811c37dd <__wb_calc_thresh+237>:      test   %rax,%rax
0xffffffff811c37e0 <__wb_calc_thresh+240>:      je 0xffffffff811c3800 <__wb_calc_thresh+272>
/usr/src/debug/kernel-4.9.168-016.ali3000/linux-4.9.168-016.ali3000.alios7.x86_64/mm/page-writeback.c: 202
0xffffffff811c37e2 <__wb_calc_thresh+242>:      imul   %r8,%rax
/usr/src/debug/kernel-4.9.168-016.ali3000/linux-4.9.168-016.ali3000.alios7.x86_64/mm/page-writeback.c: 203
0xffffffff811c37e6 <__wb_calc_thresh+246>:      mov    %r9d,%r10d    ---> truncates it to 32 bits here
0xffffffff811c37e9 <__wb_calc_thresh+249>:      xor    %edx,%edx
0xffffffff811c37eb <__wb_calc_thresh+251>:      div    %r10
0xffffffff811c37ee <__wb_calc_thresh+254>:      imul   %rbx,%rax
0xffffffff811c37f2 <__wb_calc_thresh+258>:      shr    $0x2,%rax
0xffffffff811c37f6 <__wb_calc_thresh+262>:      mul    %rcx
0xffffffff811c37f9 <__wb_calc_thresh+265>:      shr    $0x2,%rdx
0xffffffff811c37fd <__wb_calc_thresh+269>:      mov    %rdx,%r10

This series uses div64_ul() instead of div_u64() if the divisor is
unsigned long, to avoid truncation to 32-bit on 64-bit platforms.


This patch (of 3):

The variables 'min' and 'max' are unsigned long and do_div truncates them
to 32 bits, which means it can test non-zero and be truncated to zero for
division.  Fix this issue by using div64_ul() instead.

Link: http://lkml.kernel.org/r/20200102081442.8273-2-wenyang@linux.alibaba.com
Fixes: 693108a8a667 ("writeback: make bdi->min/max_ratio handling cgroup writeback aware")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page-writeback.c~mm-page-writebackc-avoid-potential-division-by-zero-in-wb_min_max_ratio
+++ a/mm/page-writeback.c
@@ -201,11 +201,11 @@ static void wb_min_max_ratio(struct bdi_
 	if (this_bw < tot_bw) {
 		if (min) {
 			min *= this_bw;
-			do_div(min, tot_bw);
+			min = div64_ul(min, tot_bw);
 		}
 		if (max < 100) {
 			max *= this_bw;
-			do_div(max, tot_bw);
+			max = div64_ul(max, tot_bw);
 		}
 	}
 
_
