Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47095C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D6B22203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633323;
	bh=QSmBtJDroo6Z4D+HXWjvM0StAuYY7GUmTabPVQPGV08=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eyLl3OVuaWifbpnlrCcDjbt9a3piDkrRTr210ZIJL95ioPhQQQ4UJZ4190r46wQtD
	 u4pXzDjx+egioD4t6afiM7Dbt1PMHuN+G+n4M2ggIcU9Ww5bAqa/+qCWjAVuzn93th
	 AMgHelm2HiYo2vYfZZoE4rlmmLdybQcfjDU178YU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388465AbgJMXzW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388463AbgJMXzW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8394E208B3;
        Tue, 13 Oct 2020 23:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633322;
        bh=QSmBtJDroo6Z4D+HXWjvM0StAuYY7GUmTabPVQPGV08=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q57F0yOHAdJcT7un1Slpzn161xxli/HE+8I5dj8C6nmBfHX1unVN4gLCNmkMcHOrs
         1JegdjdeRYpal0LmcxxWEeC2M0AF3dBAvd2EEhU04EmwcYIHXVRkzZkg2kgJLzTXnp
         8hgEEya9+jO0LHC+XekAa+tfU5wC1m2gd4/cAuv8=
Date:   Tue, 13 Oct 2020 16:55:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, jasowang@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 126/181] mm/page_isolation: exit early when
 pageblock is isolated in set_migratetype_isolate()
Message-ID: <20201013235521.z0NNxC9EO%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: exit early when pageblock is isolated in set_migratetype_isolate()

Right now, if we have two isolations racing on a pageblock that's in the
MOVABLE zone, we would trigger the WARN_ON_ONCE().  Let's just return
directly, simplifying error handling.

The change was introduced in commit 3d680bdf60a5 ("mm/page_isolation: fix
potential warning from user").  As far as I can see, we currently don't
have alloc_contig_range() users that use the ZONE_MOVABLE (anymore), so
it's currently more a cleanup and a preparation for the future than a fix.

Link: http://lkml.kernel.org/r/20200816125333.7434-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -29,10 +29,12 @@ static int set_migratetype_isolate(struc
 	/*
 	 * We assume the caller intended to SET migrate type to isolate.
 	 * If it is already set, then someone else must have raced and
-	 * set it before us.  Return -EBUSY
+	 * set it before us.
 	 */
-	if (is_migrate_isolate_page(page))
-		goto out;
+	if (is_migrate_isolate_page(page)) {
+		spin_unlock_irqrestore(&zone->lock, flags);
+		return -EBUSY;
+	}
 
 	/*
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
@@ -52,7 +54,6 @@ static int set_migratetype_isolate(struc
 		ret = 0;
 	}
 
-out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret) {
 		drain_all_pages(zone);
_
