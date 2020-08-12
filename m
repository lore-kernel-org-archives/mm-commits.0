Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECF1C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F14D2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195946;
	bh=J2BLymsFhWXgR77IvkBu3GBiHvsXv9/+7px1gOL06oQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=V8zerxXfiNRTGKFLDhbgZLnq00NNCw0E7jnM5HL+c+LxCKH+AAXFi9mGaZkX10uc0
	 JW7ESUk8YyRJXav+TQmPOLhGdACiKOZvcT39bSrj2Bnngevr+pZiYy/0doVZxDoTqY
	 QovBFYKWpbssswVtIrfpvujG8ZUajczXwVlwFuPw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgHLBcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHLBcZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96A9207F7;
        Wed, 12 Aug 2020 01:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195945;
        bh=J2BLymsFhWXgR77IvkBu3GBiHvsXv9/+7px1gOL06oQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v3JOlxyltdbgzAKUP/0csW4X3kxw90AaoZpPNPo9tKjL0E+dpVFL1TZB4xkLEA8Y+
         Vop/L5WgWryWCCiU3211Scv8PTWFl8h2728RVTyPlk+Y0i+oMFRwyhnkrdwrTreJRi
         ofLSJx2CHiahBAJPnKN8ap8S3m/nsDivSM8uEjOc=
Date:   Tue, 11 Aug 2020 18:32:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, charante@codeaurora.org,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  [patch 040/165] mm, memory_hotplug: update pcp lists
 everytime onlining a memory block
Message-ID: <20200812013224.WuU3xG4yj%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
