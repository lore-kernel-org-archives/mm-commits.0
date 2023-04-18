Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF23CC77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjDRXlX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjDRXlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15A583FA
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D63663020
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA03C433EF;
        Tue, 18 Apr 2023 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861209;
        bh=4hd76rHIY7xvbRinWHn/DyIuHsqKs91v3tcdqNLfcIk=;
        h=Date:To:From:Subject:From;
        b=qdKvD7iMuIEOUsjIABaYEuKyOaYPg4k++QNhvClGQ5UqeozIFtw9XNHZG8wk83dCz
         tkT6vLJnYbsZ+qjDJLNauf8Wjfek/QAuxnnCyw07qgGmzsctq7nEVhB9ph/GldBdG2
         MuF9vmpkmB5Vg9N4CHvBRrxDdMJFIR/6RKtH8GHI=
Date:   Tue, 18 Apr 2023 16:40:09 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch removed from -mm tree
Message-Id: <20230418234009.ACA03C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix lx-timerlist for struct timequeue_head change
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


