Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7E0C77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbjDFCy0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbjDFCxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5B093D6
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96D816422A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F052DC433D2;
        Thu,  6 Apr 2023 02:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749601;
        bh=BV2w7i00/caurhRAchYR1WfyGKSII/VPywALXd+Hk7U=;
        h=Date:To:From:Subject:From;
        b=2RxxYeNNffmT3SbJMkBQ/D2ofyEfRx19p7KB/at8SkIldda52Dp/VkitcuxGvRBXI
         A8ea+JWElolw6LRavdu8eDx2iYYu9BqpupjvmS1EAr7P2MD43r2lnJotO9ED4DQjV0
         P2b5AxlUPF1w2VMbPjlfZSkRqn8eD9/SYo2sICPw=
Date:   Wed, 05 Apr 2023 19:53:20 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org,
        leonard.crestez@nxp.com, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-bail-early-if-there-are-no-clocks.patch removed from -mm tree
Message-Id: <20230406025320.F052DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: bail early if there are no clocks
has been removed from the -mm tree.  Its filename was
     scripts-gdb-bail-early-if-there-are-no-clocks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


