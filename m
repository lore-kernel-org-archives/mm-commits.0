Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28AFC76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 19:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjC0TJA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 15:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjC0TI7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 15:08:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291411FEC
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 12:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B77346147F
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 19:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12307C433EF;
        Mon, 27 Mar 2023 19:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679944137;
        bh=z7vaTTXXeLr0L9eyj1fBRE6NSQqChR5c0Z4SttI6dLg=;
        h=Date:To:From:Subject:From;
        b=lY0fXc50TSu80ng/DvJ5TKtCaIC/4xyzMpFRL4qqTinyyTrAvvOxcRiyE9XqA1B9s
         aQOQvtwRebNGrEK1UbUfvazqFY1vSFQT0MVqQ7reYEVk4NU9XC+x94F+odCKt/mYMj
         GCG6cDvQQ2/HLmwIbgEXzc93q8GHsbkB3Wn8uK54=
Date:   Mon, 27 Mar 2023 12:08:56 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org,
        leonard.crestez@nxp.com, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-bail-early-if-there-are-no-clocks.patch added to mm-nonmm-unstable branch
Message-Id: <20230327190857.12307C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: bail early if there are no clocks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-bail-early-if-there-are-no-clocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-bail-early-if-there-are-no-clocks.patch

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
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: scripts/gdb: bail early if there are no clocks
Date: Thu, 23 Mar 2023 15:52:45 -0700

Avoid generating an exception if there are no clocks registered:

(gdb) lx-clk-summary
                                 enable  prepare  protect
   clock                          count    count    count        rate
------------------------------------------------------------------------
Python Exception <class 'gdb.error'>: No symbol "clk_root_list" in
current context.
Error occurred in Python: No symbol "clk_root_list" in current context.

Link: https://lkml.kernel.org/r/20230323225246.3302977-1-f.fainelli@gmail.com
Fixes: d1e9710b63d8 ("scripts/gdb: initial clk support: lx-clk-summary")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/clk.py |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/gdb/linux/clk.py~scripts-gdb-bail-early-if-there-are-no-clocks
+++ a/scripts/gdb/linux/clk.py
@@ -41,6 +41,8 @@ are cached and potentially out of date""
             self.show_subtree(child, level + 1)
 
     def invoke(self, arg, from_tty):
+        if utils.gdb_eval_or_none("clk_root_list") is None:
+            raise gdb.GdbError("No clocks registered")
         gdb.write("                                 enable  prepare  protect               \n")
         gdb.write("   clock                          count    count    count        rate   \n")
         gdb.write("------------------------------------------------------------------------\n")
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

mailmap-add-an-entry-for-leonard-crestez.patch
scripts-gdb-bail-early-if-there-are-no-clocks.patch
scripts-gdb-bail-early-if-there-are-no-generic-pd.patch
scripts-gdb-bail-early-if-there-are-no-generic-pd-v2.patch

