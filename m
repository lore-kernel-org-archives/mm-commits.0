Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C98DC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 04:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244187AbhLHEit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 23:38:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58588 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240064AbhLHEir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 23:38:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C9A1B81113
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 04:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7E9C00446;
        Wed,  8 Dec 2021 04:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638938114;
        bh=l61QaEUeVRYrTFvVFsPMei4Oioj4QxqxatRZAQxLYZU=;
        h=Date:From:To:Subject:From;
        b=xg2nfIUh3ASjGNaHDQRuQsmSSfhA/KJgFR0hSDBj7+i4LwaVO85puU3pE1R+RIITF
         aITrFPZTYZT2EP2TVFVgwe3FpWiKyfV9tgszt2WF+yhYFTrDE8AXSzdv7290Xo5VoQ
         NYebWoAQ6Iw4J69swdiF8IKOhk5uZk04eYHHplDQ=
Date:   Tue, 07 Dec 2021 20:35:13 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        thunder.leizhen@huawei.com
Subject:  +
 =?US-ASCII?Q?lib-list=5Fdebugc-print-more-list-debugging-context-in-?=
 =?US-ASCII?Q?=5F=5Flist=5Fdel=5Fentry=5Fvalid.patch?= added to -mm tree
Message-ID: <20211208043513.Z2--R9TbZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_debug.c: print more list debugging context in __list_del_entry_valid()
has been added to the -mm tree.  Its filename is
     lib-list_debugc-print-more-list-debugging-context-in-__list_del_entry_valid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-list_debugc-print-more-list-debugging-context-in-__list_del_entry_valid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-list_debugc-print-more-list-debugging-context-in-__list_del_entry_valid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-list_debugc-print-more-list-debugging-context-in-__list_del_entry_valid.patch

