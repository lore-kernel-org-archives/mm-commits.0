Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304E6C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbjDFCvp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbjDFCv1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272C0A26D
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7802636F7
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D2BC433D2;
        Thu,  6 Apr 2023 02:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749445;
        bh=04lJx1iqe1Gjjrk8jnq8bqj+llsJNkpHZOndqi7G74U=;
        h=Date:To:From:Subject:From;
        b=Z6DkZ0z5iESe0iBP53n+C7JNQsgBzKxNN7opeaG+WlBmKMOgFqMMShts/pppbUhZB
         GC1VwE/scZk5Oj50vfAb/xgGeMq4k1RxVw/G62fulH4VM29CJM8exib5yPpjUJheDJ
         YgVWjZuqTVCDYuJZUjsdobTYhgUOWXPUcqB0nEQY=
Date:   Wed, 05 Apr 2023 19:50:44 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org,
        leonard.crestez@nxp.com, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] scripts-gdb-bail-early-if-there-are-no-generic-pd-v2.patch removed from -mm tree
Message-Id: <20230406025045.11D2BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts-gdb-bail-early-if-there-are-no-generic-pd-v2
has been removed from the -mm tree.  Its filename was
     scripts-gdb-bail-early-if-there-are-no-generic-pd-v2.patch

This patch was dropped because it was folded into scripts-gdb-bail-early-if-there-are-no-generic-pd.patch

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: scripts-gdb-bail-early-if-there-are-no-generic-pd-v2
Date: Mon, 27 Mar 2023 11:57:46 -0700

correctly invoke gdb_eval_or_none

Link: https://lkml.kernel.org/r/20230327185746.3856407-1-f.fainelli@gmail.com
Fixes: 8207d4a88e1e ("scripts/gdb: add lx-genpd-summary command")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/genpd.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/genpd.py~scripts-gdb-bail-early-if-there-are-no-generic-pd-v2
+++ a/scripts/gdb/linux/genpd.py
@@ -70,7 +70,7 @@ Output is similar to /sys/kernel/debug/p
             gdb.write('    %-50s  %s\n' % (kobj_path, rtpm_status_str(dev)))
 
     def invoke(self, arg, from_tty):
-        if linux.utils.gdb_eval_or_none("&gpd_list") is None:
+        if gdb_eval_or_none("&gpd_list") is None:
             raise gdb.GdbError("No power domain(s) registered")
         gdb.write('domain                          status          children\n');
         gdb.write('    /device                                             runtime status\n');
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

scripts-gdb-bail-early-if-there-are-no-clocks.patch
scripts-gdb-bail-early-if-there-are-no-generic-pd.patch

