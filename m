Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45769C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 22:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiDGWsv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 18:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbiDGWsu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 18:48:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727A91606AB
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 15:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1141CB82993
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 22:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC49C385A4;
        Thu,  7 Apr 2022 22:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649371606;
        bh=/P5DCpIqqKMZhCfq6M+VwEIQREpULlWBOmtoNRGHUzE=;
        h=Date:To:From:Subject:From;
        b=l5MX+vjaVER/LkyZmr34tzwCgOpdo/noPp5ath+NXlxxrk3VvriXWQyC6fXYyVf58
         WELXTQj5D7p4NNVWD50GSPAA1t3Qlbb3eGuJvtfJ0lVw9nAYBSGG8Ez9a3gjbV9VEe
         dHqlg838gXqPmNkcFctgPZLfV22j0aMzejD4Wf6Y=
Date:   Thu, 07 Apr 2022 15:46:45 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com,
        marmarek@invisiblethingslab.com, david@redhat.com, jgross@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-build_zonerefs_node.patch added to -mm tree
Message-Id: <20220407224646.9CC49C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix build_zonerefs_node()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-build_zonerefs_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-build_zonerefs_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-build_zonerefs_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Juergen Gross <jgross@suse.com>
Subject: mm, page_alloc: fix build_zonerefs_node()

Since commit 6aa303defb74 ("mm, vmscan: only allocate and reclaim from
zones with pages managed by the buddy allocator") only zones with free
memory are included in a built zonelist.  This is problematic when e.g. 
all memory of a zone has been ballooned out when zonelists are being
rebuilt.

The decision whether to rebuild the zonelists when onlining new memory is
done based on populated_zone() returning 0 for the zone the memory will be
added to.  The new zone is added to the zonelists only, if it has free
memory pages (managed_zone() returns a non-zero value) after the memory
has been onlined.  This implies, that onlining memory will always free the
added pages to the allocator immediately, but this is not true in all
cases: when e.g.  running as a Xen guest the onlined new memory will be
added only to the ballooned memory list, it will be freed only when the
guest is being ballooned up afterwards.

Another problem with using managed_zone() for the decision whether a zone
is being added to the zonelists is, that a zone with all memory used will
in fact be removed from all zonelists in case the zonelists happen to be
rebuilt.

Use populated_zone() when building a zonelist as it has been done before
that commit.

Link: https://lkml.kernel.org/r/20220407120637.9035-1-jgross@suse.com
Fixes: 6aa303defb74 ("mm, vmscan: only allocate and reclaim from zones with pages managed by the buddy allocator")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-build_zonerefs_node
+++ a/mm/page_alloc.c
@@ -6131,7 +6131,7 @@ static int build_zonerefs_node(pg_data_t
 	do {
 		zone_type--;
 		zone = pgdat->node_zones + zone_type;
-		if (managed_zone(zone)) {
+		if (populated_zone(zone)) {
 			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
_

Patches currently in -mm which might be from jgross@suse.com are

mm-page_alloc-fix-build_zonerefs_node.patch

