Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78343C6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 20:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCUUIp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 16:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCUUIn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 16:08:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20184C2D
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 13:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 697C5B8169F
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 20:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EF9C433EF;
        Tue, 21 Mar 2023 20:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679429318;
        bh=Bdm3pUJpq+XyOVzV5OnXunSpeq6hlU0kLHsTdpWxAvY=;
        h=Date:To:From:Subject:From;
        b=wJXonrskeg1BwjdpzzCtJ4D1QcBMar0b1ED9iPDiqFZnQU7PlbwKs5xTuP68JLiZZ
         4MlFv2q4eCLEexexKFioAgnnpP8DXn8+wTkdpOz+99ASrOJ98/x2oNkD6tOeZUlfH4
         aXJbHDFO3fneW/kR9Ekh8W/uYAgVv+SzlJH/mTEU=
Date:   Tue, 21 Mar 2023 13:08:37 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch added to mm-nonmm-unstable branch
Message-Id: <20230321200838.04EF9C433EF@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
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

