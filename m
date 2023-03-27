Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A87C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 19:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjC0TJG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 15:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjC0TJC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 15:09:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D18410E5
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 12:09:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 117D2B818BC
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 19:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA822C433D2;
        Mon, 27 Mar 2023 19:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679944138;
        bh=/llt3UedWWo+N2ETXQXkAh9lKcDF4PWUxhjZe7B6zv8=;
        h=Date:To:From:Subject:From;
        b=oTLVtZHPVeUCgzYmgVAxGBYfaBYOe24SN2EwmYhhicLBgBbv0btpsurxVfyliMSiX
         8dOkI3dqma8mZO9ToXx+LypfgWU3VNampDkmIs2zfSUS3olL9RFltRTsWn/PWKCpO8
         7aQalP4w8V96ephBRYWUe7deJMIooMIgtbj2r9KI=
Date:   Mon, 27 Mar 2023 12:08:58 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org,
        leonard.crestez@nxp.com, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-bail-early-if-there-are-no-generic-pd.patch added to mm-nonmm-unstable branch
Message-Id: <20230327190858.BA822C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: bail early if there are no generic PD
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-bail-early-if-there-are-no-generic-pd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-bail-early-if-there-are-no-generic-pd.patch

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
scripts-gdb-bail-early-if-there-are-no-clocks.patch
scripts-gdb-bail-early-if-there-are-no-generic-pd.patch
scripts-gdb-bail-early-if-there-are-no-generic-pd-v2.patch

