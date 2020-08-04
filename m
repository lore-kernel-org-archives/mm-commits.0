Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A128EC433DF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 01:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A89132072A
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 01:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596504195;
	bh=9ZLepuIllq9fo8dVeYQZq/zlWxogBdtJdckuWymTRQ8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=F5E/7NUp33Ku+kCs/gIXqt1fvyOVOXVRE8ijWsRNU9sbhhISbUT/FtFVx6A7Xi9DI
	 /T7cnxdNQZnENGQCdIj+ZXYyvKInQcbgTBoeU5/iwrH240L469ZpLJvDFH0enWM36H
	 3jhb4tnAaxKt2abo1TI7dk5GzwFyGvESffhxSk0I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgHDBXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 21:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgHDBXO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 21:23:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 089B320781;
        Tue,  4 Aug 2020 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596504194;
        bh=9ZLepuIllq9fo8dVeYQZq/zlWxogBdtJdckuWymTRQ8=;
        h=Date:From:To:Subject:From;
        b=WBvWMnHENl9qszoi+Had2eDmDLGX/fm3hXkZS27O2ujVyx3j27ANhC2u7PqNf6nNS
         zUN7k51vefKLZispkfdYvd4d9NDGnXSTR4cJ1vo0IG1ENg8f8b6vH/0Nx3kFGjozog
         Gg4yaCKqjJwszV68si1JjOxEug/EwBxDMJD0xYdU=
Date:   Mon, 03 Aug 2020 18:23:13 -0700
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  +
 mm-memory_hotplug-update-pcp-lists-everytime-onlining-a-memory-block.patch
 added to -mm tree
Message-ID: <20200804012313.lTUQ4H-OP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: update pcp lists everytime onlining a memory block
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-update-pcp-lists-everytime-onlining-a-memory-block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-update-pcp-lists-everytime-onlining-a-memory-block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-update-pcp-lists-everytime-onlining-a-memory-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm, memory_hotplug: update pcp lists everytime onlining a memory block

When onlining a first memory block in a zone, pcp lists are not updated
thus pcp struct will have the default setting of ->high = 0,->batch = 1.

This means till the second memory block in a zone(if it have) is onlined
the pcp lists of this zone will not contain any pages because pcp's
->count is always greater than ->high thus free_pcppages_bulk() is called
to free batch size(=1) pages every time system wants to add a page to the
pcp list through free_unref_page().

To put this in a word, system is not using benefits offered by the pcp
lists when there is a single onlineable memory block in a zone.  Correct
this by always updating the pcp lists when memory block is onlined.

Link: http://lkml.kernel.org/r/1596372896-15336-1-git-send-email-charante@codeaurora.org
Fixes: 1f522509c77a ("mem-hotplug: avoid multiple zones sharing same boot strapping boot_pageset")
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-update-pcp-lists-everytime-onlining-a-memory-block
+++ a/mm/memory_hotplug.c
@@ -854,8 +854,7 @@ int __ref online_pages(unsigned long pfn
 	node_states_set_node(nid, &arg);
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
-	else
-		zone_pcp_update(zone);
+	zone_pcp_update(zone);
 
 	init_per_zone_wmark_min();
 
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch
mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch
mm-memory_hotplug-update-pcp-lists-everytime-onlining-a-memory-block.patch

