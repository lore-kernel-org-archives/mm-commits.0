Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B69C7619A
	for <mm-commits@archiver.kernel.org>; Sat,  8 Apr 2023 20:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjDHUtG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Apr 2023 16:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDHUtG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Apr 2023 16:49:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983D67D90
        for <mm-commits@vger.kernel.org>; Sat,  8 Apr 2023 13:49:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 300BE60AB4
        for <mm-commits@vger.kernel.org>; Sat,  8 Apr 2023 20:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AC5C433EF;
        Sat,  8 Apr 2023 20:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680986944;
        bh=Uv4HH3w/aWcu4hDkdOU9oK59li7d2Oti3jCLinqQ2Zk=;
        h=Date:To:From:Subject:From;
        b=agl3HCXniNFteuCiX99POPd/Hgj8TcAKbDUGhokrPdqEsmecMZu6T986vGy9oAnlv
         uttA9atT2F51Jg7ZmB/ks8FwuIjycbJIxyMyej4k2P22LndnXGTy4AeDL01xReLaKj
         KpgP2hMV8XQ1pIo9UOVmgHZoN430HYj/3dv7dj0M=
Date:   Sat, 08 Apr 2023 13:49:03 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch added to mm-nonmm-unstable branch
Message-Id: <20230408204904.77AC5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-timerlist for struct timequeue_head change
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peng Liu <liupeng17@lenovo.com>
Subject: scripts/gdb: fix lx-timerlist for struct timequeue_head change
Date: Tue, 21 Mar 2023 14:18:43 +0800

commit 511885d7061e ("lib/timerqueue: Rely on rbtree semantics for next
timer") changed struct timerqueue_head, and so print_active_timers()
should be changed accordingly with its way to interpret the structure.

Link: https://lkml.kernel.org/r/TYCP286MB21463BD277330B26DDC18903C6819@TYCP286MB2146.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/timerlist.py |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/gdb/linux/timerlist.py~scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change
+++ a/scripts/gdb/linux/timerlist.py
@@ -43,8 +43,7 @@ def print_timer(rb_node, idx):
 
 
 def print_active_timers(base):
-    curr = base['active']['next']['node']
-    curr = curr.address.cast(rbtree.rb_node_type.get_type().pointer())
+    curr = base['active']['rb_root']['rb_leftmost']
     idx = 0
     while curr:
         yield print_timer(curr, idx)
_

Patches currently in -mm which might be from liupeng17@lenovo.com are

scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch
scripts-gdb-fix-lx-timerlist-for-python3.patch
scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch

