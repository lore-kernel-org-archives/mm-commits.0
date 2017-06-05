From: akpm@linux-foundation.org
Subject: + signal-avoid-undefined-behaviour-in-kill_something_info.patch
 added to -mm tree
Date: Mon, 05 Jun 2017 14:55:53 -0700
Message-ID: <5935d369.eJxJ2Iu8e8LJyFy7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdFEVzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 17:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mhocko@kernel.org, oleg@redhat.com, qiuxishi@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: avoid undefined behaviour in kill_something_info
has been added to the -mm tree.  Its filename is
     signal-avoid-undefined-behaviour-in-kill_something_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-avoid-undefined-behaviour-in-kill_something_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-avoid-undefined-behaviour-in-kill_something_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhongjiang <zhongjiang@huawei.com>
Subject: kernel/signal.c: avoid undefined behaviour in kill_something_info

When running kill(72057458746458112, 0) in userspace I hit the following
issue.

[  304.606353] UBSAN: Undefined behaviour in kernel/signal.c:1462:11
[  304.612622] negation of -2147483648 cannot be represented in type 'int':
[  304.619516] CPU: 226 PID: 9849 Comm: test Tainted: G    B          ---- -------   3.10.0-327.53.58.70.x86_64_ubsan+ #116
[  304.630692] Hardware name: Huawei Technologies Co., Ltd. RH8100 V3/BC61PBIA, BIOS BLHSV028 11/11/2014
[  304.640168]  ffffffff825ded30 000000005dc276fa ffff883c3a4b7ce0 ffffffff81d6eb06
[  304.647870]  ffff883c3a4b7cf8 ffffffff81d6ebb9 ffffffff825ded20 ffff883c3a4b7de8
[  304.655584]  ffffffff81d6fc89 0000000041b58ab3 ffffffff8228d6d8 ffffffff81d6fb80
[  304.663299] Call Trace:
[  304.665827]  [<ffffffff81d6eb06>] dump_stack+0x19/0x1b
[  304.671115]  [<ffffffff81d6ebb9>] ubsan_epilogue+0xd/0x50
[  304.676668]  [<ffffffff81d6fc89>] __ubsan_handle_negate_overflow+0x109/0x14e
[  304.683917]  [<ffffffff81d6fb80>] ? __ubsan_handle_divrem_overflow+0x1df/0x1df
[  304.691353]  [<ffffffff8134a129>] ? __inc_zone_state+0x29/0xf0
[  304.697358]  [<ffffffff813272df>] ? __lru_cache_add+0x8f/0xe0
[  304.703272]  [<ffffffff8132764e>] ? lru_cache_add+0xe/0x10
[  304.708921]  [<ffffffff812263bd>] ? map_id_up+0xad/0xe0
[  304.714306]  [<ffffffff8113126e>] SYSC_kill+0x43e/0x4d0
[  304.725359]  [<ffffffff8116e630>] ? lg_local_unlock+0x20/0xd0
[  304.736978]  [<ffffffff81130e30>] ? kill_pid+0x20/0x20
[  304.747928]  [<ffffffff81366f90>] ? __pmd_alloc+0x180/0x180
[  304.759273]  [<ffffffff8143f80b>] ? mntput+0x3b/0x70
[  304.769919]  [<ffffffff81d85c3c>] ? __do_page_fault+0x2bc/0x650
[  304.781462]  [<ffffffff8123bb47>] ? __audit_syscall_entry+0x1f7/0x2a0
[  304.793476]  [<ffffffff8113535e>] SyS_kill+0xe/0x10
[  304.803859]  [<ffffffff81d91109>] system_call_fastpath+0x16/0x1b

Add code to avoid the UBSAN detection.

Link: http://lkml.kernel.org/r/1496670008-59084-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhongjiang <zhongjiang@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/signal.c~signal-avoid-undefined-behaviour-in-kill_something_info kernel/signal.c
--- a/kernel/signal.c~signal-avoid-undefined-behaviour-in-kill_something_info
+++ a/kernel/signal.c
@@ -1393,6 +1393,13 @@ static int kill_something_info(int sig,
 		return ret;
 	}
 
+	/*
+	 * -INT_MIN is undefined, it need to exclude following case to
+	 * avoid the UBSAN detection.
+	 */
+	if (pid == INT_MIN)
+		return -ESRCH;
+
 	read_lock(&tasklist_lock);
 	if (pid != -1) {
 		ret = __kill_pgrp_info(sig, info,
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
signal-avoid-undefined-behaviour-in-kill_something_info.patch

