From: akpm@linux-foundation.org
Subject: + exit-avoid-undefined-behaviour-when-call-wait4.patch added to
 -mm tree
Date: Thu, 15 Jun 2017 13:51:34 -0700
Message-ID: <5942f356.+a0RI+wSGxHKQEd3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdFOUvf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, oleg@redhat.com, qiuxishi@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: avoid undefined behaviour when calling wait4()
has been added to the -mm tree.  Its filename is
     exit-avoid-undefined-behaviour-when-call-wait4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-avoid-undefined-behaviour-when-call-wait4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit-avoid-undefined-behaviour-when-call-wait4.patch

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
Subject: kernel/exit.c: avoid undefined behaviour when calling wait4()

wait4(-2147483648, 0x20, 0, 0xdd0000) triggers:
UBSAN: Undefined behaviour in kernel/exit.c:1651:9

The related calltrace is as follows:

[518871.435738] negation of -2147483648 cannot be represented in type 'int':
[518871.442618] CPU: 9 PID: 16482 Comm: zj Tainted: G    B          ---- -------   3.10.0-327.53.58.71.x86_64+ #66
[518871.452874] Hardware name: Huawei Technologies Co., Ltd. Tecal RH2285          /BC11BTSA              , BIOS CTSAV036 04/27/2011
[518871.464690]  ffffffff82599190 000000008b740a25 ffff880112447d90 ffffffff81d6eb16
[518871.472395]  ffff880112447da8 ffffffff81d6ebc9 ffffffff82599180 ffff880112447e98
[518871.480101]  ffffffff81d6fc99 0000000041b58ab3 ffffffff8228d698 ffffffff81d6fb90
[518871.487801] Call Trace:
[518871.490435]  [<ffffffff81d6eb16>] dump_stack+0x19/0x1b
[518871.495751]  [<ffffffff81d6ebc9>] ubsan_epilogue+0xd/0x50
[518871.501328]  [<ffffffff81d6fc99>] __ubsan_handle_negate_overflow+0x109/0x14e
[518871.508548]  [<ffffffff81d6fb90>] ? __ubsan_handle_divrem_overflow+0x1df/0x1df
[518871.516041]  [<ffffffff8116e0d4>] ? lg_local_lock+0x24/0xb0
[518871.521785]  [<ffffffff8116e640>] ? lg_local_unlock+0x20/0xd0
[518871.527708]  [<ffffffff81366fa0>] ? __pmd_alloc+0x180/0x180
[518871.533458]  [<ffffffff8143f81b>] ? mntput+0x3b/0x70
[518871.538598]  [<ffffffff8110d7bb>] SyS_wait4+0x1cb/0x1e0
[518871.543999]  [<ffffffff8110d5f0>] ? SyS_waitid+0x220/0x220
[518871.549661]  [<ffffffff8123bb57>] ? __audit_syscall_entry+0x1f7/0x2a0
[518871.556278]  [<ffffffff81d91109>] system_call_fastpath+0x16/0x1b

Exclude the overflow to avoid the UBSAN warning.

Link: http://lkml.kernel.org/r/1497264618-20212-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhongjiang <zhongjiang@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/exit.c~exit-avoid-undefined-behaviour-when-call-wait4 kernel/exit.c
--- a/kernel/exit.c~exit-avoid-undefined-behaviour-when-call-wait4
+++ a/kernel/exit.c
@@ -1697,6 +1697,10 @@ SYSCALL_DEFINE4(wait4, pid_t, upid, int
 			__WNOTHREAD|__WCLONE|__WALL))
 		return -EINVAL;
 
+	/* -INT_MIN is not defined */
+	if (upid == INT_MIN)
+		return -ESRCH;
+
 	if (upid == -1)
 		type = PIDTYPE_MAX;
 	else if (upid < 0) {
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
signal-avoid-undefined-behaviour-in-kill_something_info.patch
exit-avoid-undefined-behaviour-when-call-wait4.patch

