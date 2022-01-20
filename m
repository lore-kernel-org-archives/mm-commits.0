Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933B7C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244107AbiATVaa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377923AbiATVa3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52400C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07C7FB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94424C340E0;
        Thu, 20 Jan 2022 21:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714226;
        bh=/2hCIiBTjTlXriI+/wUIZ9e2bYAitROsPXpn4Lrvt3s=;
        h=Date:From:To:Subject:From;
        b=upgzXWUVFn1GAWucexmVN3OXi8sPHaWlvXtTGZBB+1DBeC9FndCl66hMdbzgkJuyw
         j5IWfK5JOS1fMp6zbxs5IfRuzxXBn5+AOJ2xBb5QUDZ2K4Pv3CkAH+8KiGcR7QcOH0
         N53blHGzsR49UZ1LQw5h/teg5YwILGC3txHBfOng=
Date:   Thu, 20 Jan 2022 13:30:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        thunder.leizhen@huawei.com
Subject:  [merged]
 =?US-ASCII?Q?lib-list=5Fdebugc-print-more-list-debugging-context-in-?=
 =?US-ASCII?Q?=5F=5Flist=5Fdel=5Fentry=5Fvalid.patch?= removed from -mm
 tree
Message-ID: <20220120213026.JkMSKc8Gd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_debug.c: print more list debugging context in __list_del_entry_valid()
has been removed from the -mm tree.  Its filename was
     lib-list_debugc-print-more-list-debugging-context-in-__list_del_entry_valid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib/list_debug.c: print more list debugging context in __list_del_entry_valid()

Currently, the entry->prev and entry->next are considered to be valid as
long as they are not LIST_POISON{1|2}.  However, the memory may be
corrupted.  The prev->next is invalid probably because 'prev' is invalid,
not because prev->next's content is illegal.

Unfortunately, the printk and its subfunctions will modify the registers
that hold the 'prev' and 'next', and we don't see this valuable
information in the BUG context.

So print the contents of 'entry->prev' and 'entry->next'.

Here's an example:
list_del corruption. prev->next should be c0ecbf74, but was c08410dc
kernel BUG at lib/list_debug.c:53!
... ...
PC is at __list_del_entry_valid+0x58/0x98
LR is at __list_del_entry_valid+0x58/0x98
psr: 60000093
sp : c0ecbf30  ip : 00000000  fp : 00000001
r10: c08410d0  r9 : 00000001  r8 : c0825e0c
r7 : 20000013  r6 : c08410d0  r5 : c0ecbf74  r4 : c0ecbf74
r3 : c0825d08  r2 : 00000000  r1 : df7ce6f4  r0 : 00000044
... ...
Stack: (0xc0ecbf30 to 0xc0ecc000)
bf20:                                     c0ecbf74 c0164fd0 c0ecbf70 c0165170
bf40: c0eca000 c0840c00 c0840c00 c0824500 c0825e0c c0189bbc c088f404 60000013
bf60: 60000013 c0e85100 000004ec 00000000 c0ebcdc0 c0ecbf74 c0ecbf74 c0825d08
bf80: c0e807c0 c018965c 00000000 c013f2a0 c0e807c0 c013f154 00000000 00000000
bfa0: 00000000 00000000 00000000 c01001b0 00000000 00000000 00000000 00000000
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
(__list_del_entry_valid) from (__list_del_entry+0xc/0x20)
(__list_del_entry) from (finish_swait+0x60/0x7c)
(finish_swait) from (rcu_gp_kthread+0x560/0xa20)
(rcu_gp_kthread) from (kthread+0x14c/0x15c)
(kthread) from (ret_from_fork+0x14/0x24)

At first, I thought prev->next was overwritten.  Later, I carefully
analyzed the RCU code and the disassembly code.  The error occurred when
deleting a node from the list rcu_state.gp_wq.  The System.map shows that
the address of rcu_state is c0840c00.  Then I use gdb to obtain the offset
of rcu_state.gp_wq.task_list.

(gdb) p &((struct rcu_state *)0)->gp_wq.task_list
$1 = (struct list_head *) 0x4dc

Again:
list_del corruption. prev->next should be c0ecbf74, but was c08410dc

c08410dc = c0840c00 + 0x4dc = &rcu_state.gp_wq.task_list

Because rcu_state.gp_wq has at most one node, so I can guess that "prev =
&rcu_state.gp_wq.task_list".  But for other scenes, maybe I wasn't so
lucky, I cannot figure out the value of 'prev'.

Link: https://lkml.kernel.org/r/20211207025835.1909-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/list_debug.c~lib-list_debugc-print-more-list-debugging-context-in-__list_del_entry_valid
+++ a/lib/list_debug.c
@@ -49,11 +49,11 @@ bool __list_del_entry_valid(struct list_
 			"list_del corruption, %px->prev is LIST_POISON2 (%px)\n",
 			entry, LIST_POISON2) ||
 	    CHECK_DATA_CORRUPTION(prev->next != entry,
-			"list_del corruption. prev->next should be %px, but was %px\n",
-			entry, prev->next) ||
+			"list_del corruption. prev->next should be %px, but was %px. (prev=%px)\n",
+			entry, prev->next, prev) ||
 	    CHECK_DATA_CORRUPTION(next->prev != entry,
-			"list_del corruption. next->prev should be %px, but was %px\n",
-			entry, next->prev))
+			"list_del corruption. next->prev should be %px, but was %px. (next=%px)\n",
+			entry, next->prev, next))
 		return false;
 
 	return true;
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


