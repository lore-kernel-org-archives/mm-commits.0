Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611D8C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 19:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjC0THR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 15:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjC0THQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 15:07:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B941FEC
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 12:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B723B6148F
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 19:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B425C433EF;
        Mon, 27 Mar 2023 19:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679944035;
        bh=WaHepc19AMjscY6nMveBnOVRhV/7/7VU9okImgIhOL8=;
        h=Date:To:From:Subject:From;
        b=yDuxoXSFkq+rc8DQJsR5fWjJU2byA+63tNbxWY0NDO3s6ex9LOtBvd9zS2TViDze/
         QsBvM6TXv86qBSeQVH7WYfodCWCD2DOs1zlhfWUhqCK4e9nWIuC+OvS7Aw2CrUqIzN
         m45itAEcqgNcnOk9+QX+6uhoYTb4LCIcFvHo7j00=
Date:   Mon, 27 Mar 2023 12:07:14 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org,
        leonard.crestez@nxp.com, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] scripts-gdb-bail-early-if-there-are-no-generic-pd.patch removed from -mm tree
Message-Id: <20230327190715.1B425C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: bail early if there are no generic PD
has been removed from the -mm tree.  Its filename was
     scripts-gdb-bail-early-if-there-are-no-generic-pd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: scripts/gdb: bail early if there are no generic PD
Date: Thu, 23 Mar 2023 16:16:57 -0700

Avoid generating an exception if there are no generic power domain(s)
registered:

(gdb) lx-genpd-summary
domain                          status          children
    /device                                             runtime status
----------------------------------------------------------------------
Python Exception <class 'gdb.error'>: No symbol "gpd_list" in current context.
Error occurred in Python: No symbol "gpd_list" in current context.
(gdb) quit

Link: https://lkml.kernel.org/r/20230323231659.3319941-1-f.fainelli@gmail.com
Fixes: 8207d4a88e1e ("scripts/gdb: add lx-genpd-summary command")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/genpd.py |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/genpd.py~scripts-gdb-bail-early-if-there-are-no-generic-pd
+++ a/scripts/gdb/linux/genpd.py
@@ -5,7 +5,7 @@
 import gdb
 import sys
 
-from linux.utils import CachedType
+from linux.utils import CachedType, gdb_eval_or_none
 from linux.lists import list_for_each_entry
 
 generic_pm_domain_type = CachedType('struct generic_pm_domain')
@@ -70,6 +70,8 @@ Output is similar to /sys/kernel/debug/p
             gdb.write('    %-50s  %s\n' % (kobj_path, rtpm_status_str(dev)))
 
     def invoke(self, arg, from_tty):
+        if linux.utils.gdb_eval_or_none("&gpd_list") is None:
+            raise gdb.GdbError("No power domain(s) registered")
         gdb.write('domain                          status          children\n');
         gdb.write('    /device                                             runtime status\n');
         gdb.write('----------------------------------------------------------------------\n');
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

mailmap-add-an-entry-for-leonard-crestez.patch

