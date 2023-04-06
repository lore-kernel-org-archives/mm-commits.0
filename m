Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF32C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbjDFCyf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbjDFCxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF47E57
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A005764242
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05533C433D2;
        Thu,  6 Apr 2023 02:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749602;
        bh=EpTh05GBYMx1Ov1R0zwR9p+IoyS9BwdjNFWD8CZWBpA=;
        h=Date:To:From:Subject:From;
        b=R0hDcpMRhQKOpdeorpNjpeEpiKG4WwxnlcRSV6abMd2+VKLipwGZVsAMjOOep0iIA
         ibguEF/WlTPeedQlb5h4N4yKaXcch2pgw+oYAcYOUx01p7rKaR224AvIql7uu5f/tS
         YpWb9GWbiLcLp6GYPIWvfdTXhN08UKwWwSZP6BCk=
Date:   Wed, 05 Apr 2023 19:53:21 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org,
        leonard.crestez@nxp.com, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-bail-early-if-there-are-no-generic-pd.patch removed from -mm tree
Message-Id: <20230406025322.05533C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: bail early if there are no generic PD
has been removed from the -mm tree.  Its filename was
     scripts-gdb-bail-early-if-there-are-no-generic-pd.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[f.fainelli@gmail.com: correctly invoke gdb_eval_or_none]
  Link: https://lkml.kernel.org/r/20230327185746.3856407-1-f.fainelli@gmail.com
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
+        if gdb_eval_or_none("&gpd_list") is None:
+            raise gdb.GdbError("No power domain(s) registered")
         gdb.write('domain                          status          children\n');
         gdb.write('    /device                                             runtime status\n');
         gdb.write('----------------------------------------------------------------------\n');
_

Patches currently in -mm which might be from f.fainelli@gmail.com are


