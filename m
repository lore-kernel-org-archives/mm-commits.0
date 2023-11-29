Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35B7C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 22:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjK2WPV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Nov 2023 17:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbjK2WPU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2023 17:15:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C3E10D0
        for <mm-commits@vger.kernel.org>; Wed, 29 Nov 2023 14:15:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210A3C433C7;
        Wed, 29 Nov 2023 22:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701296124;
        bh=y2EJUzQlfuYe85Uyv/uorAtwB7mNo3enYObGcG/LYcY=;
        h=Date:To:From:Subject:From;
        b=tGyZ5qE8cb3Bx9C2EJGAnxpx2kktUcdyzoeY0cxMNKzPtcxvwsSZXD+OkqztYsu7J
         1LYJiHSmk21pydBPFcnL7a2aTl1PMUxQm82nL0WNbHtd4xgwFBA4mlDCLbofAOp82R
         9L5+toST6eSDiMHemzBM15TBKORaqyFhrqOzKXSA=
Date:   Wed, 29 Nov 2023 14:15:23 -0800
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        oleg@redhat.com, matthias.bgg@gmail.com,
        chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com, andreyknvl@google.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-stackdepot-rename-pool_index-to-pools_num.patch added to mm-nonmm-unstable branch
Message-Id: <20231129221524.210A3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/stackdepot: rename pool_index to pools_num
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-stackdepot-rename-pool_index-to-pools_num.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-stackdepot-rename-pool_index-to-pools_num.patch

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
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/stackdepot: rename pool_index to pools_num
Date: Wed, 29 Nov 2023 14:51:39 +0800

After stackdepot evicting support patchset[1], we rename pool_index to
pools_num.

To avoid from the below issue, we rename consistently in
gdb scripts.

Python Exception <class 'gdb.error'>: No symbol "pool_index" in current
context.
Error occurred in Python: No symbol "pool_index" in current context.

[1] https://lore.kernel.org/linux-mm/cover.1700502145.git.andreyknvl@google.com/
Link: https://lkml.kernel.org/r/20231129065142.13375-3-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/stackdepot.py |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/gdb/linux/stackdepot.py~scripts-gdb-stackdepot-rename-pool_index-to-pools_num
+++ a/scripts/gdb/linux/stackdepot.py
@@ -25,10 +25,10 @@ def stack_depot_fetch(handle):
     handle_parts_t = gdb.lookup_type("union handle_parts")
     parts = handle.cast(handle_parts_t)
     offset = parts['offset'] << DEPOT_STACK_ALIGN
-    pool_index_cached = gdb.parse_and_eval('pool_index')
+    pools_num = gdb.parse_and_eval('pools_num')
 
-    if parts['pool_index'] > pool_index_cached:
-        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pool_index_cached, handle))
+    if parts['pool_index'] > pools_num:
+        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))
         return gdb.Value(0), 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-tasks-fix-lx-ps-command-error.patch
scripts-gdb-tasks-fix-lx-ps-command-error-v2.patch
scripts-gdb-stackdepot-rename-pool_index-to-pools_num.patch
scripts-gdb-remove-exception-handling-and-refine-print-format.patch

