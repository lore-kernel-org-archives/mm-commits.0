Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E692C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 30 Apr 2022 18:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244120AbiD3Sms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Apr 2022 14:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244111AbiD3Smq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 30 Apr 2022 14:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F26C28981
        for <mm-commits@vger.kernel.org>; Sat, 30 Apr 2022 11:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9939A61037
        for <mm-commits@vger.kernel.org>; Sat, 30 Apr 2022 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87A2C385A7;
        Sat, 30 Apr 2022 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651343963;
        bh=ndoWOC1I4kmeLON3CRspcc6a2h8xq9POlEvNFvyt+9k=;
        h=Date:To:From:Subject:From;
        b=iFJlsWe2diifElkC/lMYHW6QjqCNPHkWuVgXr6uZWLK8XCts3Edbu5CesvH18KuCX
         ZnsVPmtbX7DHkJvOxt4SmOn3DzAt98g28oVVt0NcsqxS129XQ22B68XuJkVFVPlwvd
         9Vd522XBxqHjDaxdvnImvJDJRAC2lVsfzaADET1I=
Date:   Sat, 30 Apr 2022 11:39:22 -0700
To:     mm-commits@vger.kernel.org, vvghjk1234@gmail.com,
        ohkwon1043@gmail.com, mgorman@techsingularity.net,
        lakroforce@gmail.com, jsyoo5b@gmail.com, hannes@cmpxchg.org,
        dthex5d@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-cache-the-result-of-node_dirty_ok-fix.patch added to mm-unstable branch
Message-Id: <20220430183922.E87A2C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-cache-the-result-of-node_dirty_ok-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-cache-the-result-of-node_dirty_ok-fix.patch

This patch should soon appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-cache-the-result-of-node_dirty_ok-fix

rename last_pgdat_dirty_limit to last_pgdat_dirty_ok

Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ohhoon Kwon <ohkwon1043@gmail.com>
Cc: JaeSang Yoo <jsyoo5b@gmail.com>
Cc: Jiyoup Kim <lakroforce@gmail.com>
Cc: Donghyeok Kim <dthex5d@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-cache-the-result-of-node_dirty_ok-fix
+++ a/mm/page_alloc.c
@@ -4022,7 +4022,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 	struct zoneref *z;
 	struct zone *zone;
 	struct pglist_data *last_pgdat = NULL;
-	bool last_pgdat_dirty_limit = false;
+	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 
 retry:
@@ -4063,10 +4063,10 @@ retry:
 		if (ac->spread_dirty_pages) {
 			if (last_pgdat != zone->zone_pgdat) {
 				last_pgdat = zone->zone_pgdat;
-				last_pgdat_dirty_limit = node_dirty_ok(zone->zone_pgdat);
+				last_pgdat_dirty_ok = node_dirty_ok(zone->zone_pgdat);
 			}
 
-			if (!last_pgdat_dirty_limit)
+			if (!last_pgdat_dirty_ok)
 				continue;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-create-new-mm-swaph-header-file-fix.patch
mm-page_alloc-cache-the-result-of-node_dirty_ok-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

