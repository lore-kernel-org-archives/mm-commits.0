Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14887C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEAC92076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195996;
	bh=96T8LwzRhF2NGcJE76BsmnBgLSSR+OE/3bsHBGiDLzY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0CCD4+BWXMZOk2r0pACTUrvyBhmUtGayB8xE3J/XU7Jnu184Q67uzP8DnZ2nxoYfS
	 luSbLfIQuCALjuwqUksNhviLgtRXl5pHJ+KOBnXF4CIu6LveXZmg1PsqyeJCz6NZ50
	 Xsu7jqigRjfy4JMVtLbY7gVq86HME2F7EwS9iJWg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLBdQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBdQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72367207DA;
        Wed, 12 Aug 2020 01:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195994;
        bh=96T8LwzRhF2NGcJE76BsmnBgLSSR+OE/3bsHBGiDLzY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XtMb6Y16z3p4Bfkw1RNq6liwT6l8DFgN5PRAovpW1VLHkUyOqRmObnun8iFIP0Qpa
         AikKi9KIVLfyT9jOj14qZNUpNy055LZAsVg+ObaXuMU7DnYPTet5cvDISr9RMCxvap
         3yhPEbb5wCJRzjOqpCYnbDaiH373wT0hETHDfl7U=
Date:   Tue, 11 Aug 2020 18:33:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 056/165] mm/page_alloc.c: delete or fix duplicated
 words
Message-ID: <20200812013314.HUq8ADdLL%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/page_alloc.c: delete or fix duplicated words

Drop the repeated word "them" and "that".
Change "the the" to "to the".

Link: http://lkml.kernel.org/r/20200801173822.14973-10-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-delete-or-fix-duplicated-words
+++ a/mm/page_alloc.c
@@ -4282,7 +4282,7 @@ retry:
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
 	 * pages are pinned on the per-cpu lists or in high alloc reserves.
-	 * Shrink them them and try again
+	 * Shrink them and try again
 	 */
 	if (!page && !drained) {
 		unreserve_highatomic_pageblock(ac, false);
@@ -6192,7 +6192,7 @@ static int zone_batchsize(struct zone *z
  * locking.
  *
  * Any new users of pcp->batch and pcp->high should ensure they can cope with
- * those fields changing asynchronously (acording the the above rule).
+ * those fields changing asynchronously (acording to the above rule).
  *
  * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
  * outside of boot time (or some other assurance that no concurrent updaters
@@ -8203,7 +8203,7 @@ void *__init alloc_large_system_hash(con
  * race condition. So you can't expect this function should be exact.
  *
  * Returns a page without holding a reference. If the caller wants to
- * dereference that page (e.g., dumping), it has to make sure that that it
+ * dereference that page (e.g., dumping), it has to make sure that it
  * cannot get removed (e.g., via memory unplug) concurrently.
  *
  */
_
