Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CC9C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD87B2078B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597805706;
	bh=jCgC98QY4CtxoH6vFmQZyowA/GhREg74KfgzcyBRO3w=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CfxmGq1BctS1tEvyPux4NN6XywQATPXdCFPv0peCMs4gMpkbbxcMFsrrdwPJ4QSGm
	 FnsWEn74Zqovxs4dD10bPrl+LyAf2Uq7XyYOEVipo9sVPaJb/VNm/01QqnnvrUOhS9
	 BZ0xcXKyemzfrr0tZp1Zc2sBRpzAQLCFC3YQ6XWo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHSCzG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbgHSCzG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 22:55:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E99882076E;
        Wed, 19 Aug 2020 02:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597805705;
        bh=jCgC98QY4CtxoH6vFmQZyowA/GhREg74KfgzcyBRO3w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f82bFy0CUxoDaQMMHD+ED9LhFUV+P2NXswJ/zg7XFE1f4AgqTSfYNc18InUVIRbWA
         UmBnJUgv37wPCS1nYfHfBRdtvkne8fYKlqMtHHpjEzjNtvfUISNY6U3PZMTCbB9/V7
         XZU26GvmVnNTv8B5bRO8chM3/mKVeTLrZpO0J3os=
Date:   Tue, 18 Aug 2020 19:55:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, cai@lca.pw, david@redhat.com, jasowang@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-page=5Fisolation-exit-early-when-pageblock-is-isolated-?=
 =?US-ASCII?Q?in-set=5Fmigratetype=5Fisolate.patch?= added to -mm tree
Message-ID: <20200819025504.cFz1MGW58%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: exit early when pageblock is isolated in set_migratetype_isolate()
has been added to the -mm tree.  Its filename is
     mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch

