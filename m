Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9797C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 18:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjK0Stw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 13:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjK0Stw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 13:49:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D49D41
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 10:49:58 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690AFC433C8;
        Mon, 27 Nov 2023 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701110998;
        bh=v/EOgtdJFf2Qc2noB3RnySwI43B44vFp+1sUe7odFro=;
        h=Date:To:From:Subject:From;
        b=V8+5Yr6eQCq1CQFf6zQee8O1ISYxtEOUGYP58QbuW989TV794qWO8B/NzhGZkUwu0
         quCnXghGSRtyi5mDSwO+hgOlCVXO5LUJjdeGyp+95zv6q5219RlLc8nwtKgf8RrTDq
         GaHJh4kGphG0RZ0rTaMxYgHz7FecLhynQD9GGzbw=
Date:   Mon, 27 Nov 2023 10:49:57 -0800
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        oleg@redhat.com, matthias.bgg@gmail.com,
        chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com, andreyknvl@google.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-stackdepot-rename-pool_index_cached-to-pools_num.patch added to mm-nonmm-unstable branch
Message-Id: <20231127184958.690AFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/stackdepot: rename pool_index_cached to pools_num
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-stackdepot-rename-pool_index_cached-to-pools_num.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-stackdepot-rename-pool_index_cached-to-pools_num.patch

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
Subject: scripts/gdb/stackdepot: rename pool_index_cached to pools_num
Date: Mon, 27 Nov 2023 15:04:02 +0800

After stackdepot evicting support patchset[1], we rename pool_index_cached
to pools_num.

Link: https://lore.kernel.org/linux-mm/cover.1700502145.git.andreyknvl@google.com/ [1]
Link: https://lkml.kernel.org/r/20231127070404.4192-3-Kuan-Ying.Lee@mediatek.com
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

--- a/scripts/gdb/linux/stackdepot.py~scripts-gdb-stackdepot-rename-pool_index_cached-to-pools_num
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
scripts-gdb-stackdepot-rename-pool_index_cached-to-pools_num.patch
scripts-gdb-remove-exception-handling-and-refine-print-format.patch

