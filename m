Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E88C77B61
	for <mm-commits@archiver.kernel.org>; Sat,  8 Apr 2023 20:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDHUtL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Apr 2023 16:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDHUtJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Apr 2023 16:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138C97EE9
        for <mm-commits@vger.kernel.org>; Sat,  8 Apr 2023 13:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A36AF60ED3
        for <mm-commits@vger.kernel.org>; Sat,  8 Apr 2023 20:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B4FC4339B;
        Sat,  8 Apr 2023 20:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680986948;
        bh=61vamxEZgFzqVthwYYzot6giyWiTL/NVq/sCZNPPLDA=;
        h=Date:To:From:Subject:From;
        b=hfp+8hTDfUGu/o7tYH63lTfeAPaFXyUZ+NEwPTm/rgE8G12M/weLH326HJMdwczGw
         W2rV8z7ty9UqtUkzm5H58M2vndNhPSSQVMApivtMVcWTHDGQBv/v1K87PzgDSINux7
         8Q1VA0iHl3opWrVfUKiCC0suC8PE/uBdu5gkrdBs=
Date:   Sat, 08 Apr 2023 13:49:07 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch added to mm-nonmm-unstable branch
Message-Id: <20230408204908.09B4FC4339B@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/TYCP286MB214640FF0E7F04AC3926A39EC6819@TYCP286MB2146.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
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

