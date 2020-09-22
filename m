Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78ACDC2D0E2
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28652238D6
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600803804;
	bh=Q+XPYM45cH8Zwq1BUmUErEZ9T7Zk1cQtHrzTdCyXds4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=otEFrRD6CMPlvyxxSb/Fv47jLuI6IKH66jo864n1HjIgqXkSjsFGy8CPqGOhjZEo5
	 wKDVLl09zx7EdAdeI7UawXzK96hWcFXrLa1rbZ+WzTPcElRTMO2VIZ27dqosOTv2at
	 UkD5XG1I8zRqn6SCr0biF++z3XCjvEvFDNlOUaLI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIVTnX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 15:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVTnX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 15:43:23 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6E3D23787;
        Tue, 22 Sep 2020 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600803803;
        bh=Q+XPYM45cH8Zwq1BUmUErEZ9T7Zk1cQtHrzTdCyXds4=;
        h=Date:From:To:Subject:From;
        b=Y/2vxfCW9l6ej4JUS+/F6g65GdZ/hmve31nH5gGk6Hy3hHCP8JuEdFzCkuerwgZJn
         GgMbRqVCuMbhz0D3a3iiPDC547G5RNf+ZVl5ygXoyVAGT4hgLg3zdFQczr5XNJ/Sng
         16TRCNal7To+uF/vmJ4qkzH/kVIBNfOReSIi56w8=
Date:   Tue, 22 Sep 2020 12:43:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        osalvador@suse.com, naoya.horiguchi@nec.com, mhocko@kernel.org,
        cai@lca.pw, osalvador@suse.de
Subject:  [to-be-updated]
 mmhwpoison-drop-unneeded-pcplist-draining.patch removed from -mm tree
Message-ID: <20200922194322.b_3L8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: drop unneeded pcplist draining
has been removed from the -mm tree.  Its filename was
     mmhwpoison-drop-unneeded-pcplist-draining.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: drop unneeded pcplist draining

memory_failure and soft_offline_path paths now drain pcplists by calling
get_hwpoison_page.

memory_failure flags the page as HWPoison before, so that page cannot
longer go into a pcplist, and soft_offline_page only flags a page as
HWPoison if 1) we took the page off a buddy freelist 2) the page was
in-use and we migrated it 3) was a clean pagecache.

Because of that, a page cannot longer be poisoned and be in a pcplist.

Link: https://lkml.kernel.org/r/20200908075626.11976-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/madvise.c~mmhwpoison-drop-unneeded-pcplist-draining
+++ a/mm/madvise.c
@@ -917,10 +917,6 @@ static int madvise_inject_error(int beha
 			return ret;
 	}
 
-	/* Ensure that all poisoned pages are removed from per-cpu lists */
-	for_each_populated_zone(zone)
-		drain_all_pages(zone);
-
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
mmhwpoison-remove-stale-code.patch

