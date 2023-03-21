Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C69C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 20:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCUUIq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 16:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCUUIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 16:08:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32627A8C
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 13:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A8E861DE3
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 20:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19FAC433EF;
        Tue, 21 Mar 2023 20:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679429321;
        bh=dkcBeA4QukGJo4U4M2iQMEQIPeB4edINdeASs6gOLic=;
        h=Date:To:From:Subject:From;
        b=ktroq3gtCayesjQ58hIqNabndC3ppkAhSDHpKjmXBLCAo3hqpT73ZEFtIM8+OVnYp
         nzwgzXEFkIK//+La5fU31CCaQ6BU/fAAC/emVhveBuUtyU+y8ten9PD5Whtzlj7USj
         f8HaQ8juHOFUe+yxImGHv4OubZeSeiwFf25IXOkc=
Date:   Tue, 21 Mar 2023 13:08:41 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch added to mm-nonmm-unstable branch
Message-Id: <20230321200841.A19FAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-timerlist for HRTIMER_MAX_CLOCK_BASES printing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch

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
Subject: scripts/gdb: fix lx-timerlist for HRTIMER_MAX_CLOCK_BASES printing
Date: Tue, 21 Mar 2023 14:20:04 +0800

HRTIMER_MAX_CLOCK_BASES is of enum type hrtimer_base_type.  To print it as
an integer, HRTIMER_MAX_CLOCK_BASES should be converted first.

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/timerlist.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/timerlist.py~scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing
+++ a/scripts/gdb/linux/timerlist.py
@@ -188,7 +188,8 @@ class LxTimerList(gdb.Command):
         max_clock_bases = gdb.parse_and_eval("HRTIMER_MAX_CLOCK_BASES")
 
         text = "Timer List Version: gdb scripts\n"
-        text += "HRTIMER_MAX_CLOCK_BASES: {}\n".format(max_clock_bases)
+        text += "HRTIMER_MAX_CLOCK_BASES: {}\n".format(
+            max_clock_bases.type.fields()[max_clock_bases].enumval)
         text += "now at {} nsecs\n".format(ktime_get())
 
         for cpu in cpus.each_online_cpu():
_

Patches currently in -mm which might be from liupeng17@lenovo.com are

scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch
scripts-gdb-fix-lx-timerlist-for-python3.patch
scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch

