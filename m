Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0ABECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiILDaD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2065927CE8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B05046116E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F911C433D6;
        Mon, 12 Sep 2022 03:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953329;
        bh=E0lHupjRjoVURYVJtcPrd5VmuqfUD0I2VKsv5W25gCs=;
        h=Date:To:From:Subject:From;
        b=Iel7VbT1imKwLPF2dl3TB1ixtua8fznGR/OTElS0vL4yFZ2vnEXt5oDcYoRdFJE32
         fHvU3sTDmo7fmm3ZCIBPNVhw0jcPlalQQG1aCY4geGFY6vynAmFZbNHV5SCwgBScFL
         7rO43yWNP25ssprmPFq+eiTkZ7qBipZnpVt68mCo=
Date:   Sun, 11 Sep 2022 20:28:48 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, cgel.zte@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place.patch removed from -mm tree
Message-Id: <20220912032849.0F911C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: make the annotations of refaults code at the right place
has been removed from the -mm tree.  Its filename was
     mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/vmscan: make the annotations of refaults code at the right place
Date: Sat, 13 Aug 2022 08:07:58 +0000

After patch "mm/workingset: prepare the workingset detection
infrastructure for anon LRU", we can handle the refaults of anonymous
pages too.  So the annotations of refaults should cover both of anonymous
pages and file pages.

Link: https://lkml.kernel.org/r/20220813080757.59131-1-yang.yang29@zte.com.cn
Fixes: 170b04b7ae4963 ("mm/workingset: prepare the workingset detection infrastructure for anon LRU")
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place
+++ a/mm/vmscan.c
@@ -3228,6 +3228,11 @@ again:
 	if (!sc->force_deactivate) {
 		unsigned long refaults;
 
+		/*
+		 * When refaults are being observed, it means a new
+		 * workingset is being established. Deactivate to get
+		 * rid of any stale active pages quickly.
+		 */
 		refaults = lruvec_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_ANON);
 		if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
@@ -3236,11 +3241,6 @@ again:
 		else
 			sc->may_deactivate &= ~DEACTIVATE_ANON;
 
-		/*
-		 * When refaults are being observed, it means a new
-		 * workingset is being established. Deactivate to get
-		 * rid of any stale active pages quickly.
-		 */
 		refaults = lruvec_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_FILE);
 		if (refaults != target_lruvec->refaults[WORKINGSET_FILE] ||
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

filemap-make-the-accounting-of-thrashing-more-consistent.patch
delayacct-support-re-entrance-detection-of-thrashing-accounting.patch
mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch

