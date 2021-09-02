Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89223C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75EB4610E6
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347766AbhIBVyp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347834AbhIBVyV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F025661166;
        Thu,  2 Sep 2021 21:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619602;
        bh=HaIFv9pD4Bs/Rvsd5bh17DZqs2PR1T9rPtVXHZyVkHY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WvezcGqAy7b5+7DN+IHO3DCdZcrOEyiBn+YZqOlPSsHNCVP+XWqmU1ySUAtEtccrK
         +N0i4bMnLM2kf4ZWhtPaISPnuC/h/Q2uqrvVkOVZ6yq/Pviaqd4d4hUOM2uVkgASET
         Hahlidxh9WNznVNybeOFLUjseJur1uAkQ1fxvwD0=
Date:   Thu, 02 Sep 2021 14:53:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 064/212] fs: drop_caches: fix skipping over shadow
 cache inodes
Message-ID: <20210902215321.8weaTZ9iQ%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: fs: drop_caches: fix skipping over shadow cache inodes

When drop_caches truncates the page cache in an inode it also includes any
shadow entries for evicted pages.  However, there is a preliminary check
on whether the inode has pages: if it has *only* shadow entries, it will
skip running truncation on the inode and leave it behind.

Fix the check to mapping_empty(), such that it runs truncation on any
inode that has cache entries at all.

Link: https://lkml.kernel.org/r/20210614211904.14420-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/drop_caches.c~fs-drop_caches-fix-skipping-over-shadow-cache-inodes
+++ a/fs/drop_caches.c
@@ -3,6 +3,7 @@
  * Implement the manual drop-all-pagecache function
  */
 
+#include <linux/pagemap.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
@@ -27,7 +28,7 @@ static void drop_pagecache_sb(struct sup
 		 * we need to reschedule to avoid softlockups.
 		 */
 		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    (inode->i_mapping->nrpages == 0 && !need_resched())) {
+		    (mapping_empty(inode->i_mapping) && !need_resched())) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
_
