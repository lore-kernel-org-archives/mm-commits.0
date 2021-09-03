Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD78AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E3C60C3E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350122AbhICU5Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349849AbhICU5J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C5F1601FD;
        Fri,  3 Sep 2021 20:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702569;
        bh=MwT0XzomU/gqNb2icplrtLNGW0saK3gHP83WQUCFgRk=;
        h=Date:From:To:Subject:From;
        b=uVtz3wE93X3Yv23fnrIFKL5CAXRkLr1EfO5mlz3r+F0OjMk3Iukidq4G8ovw74m3z
         FtjWw6OmWOkrYxFbA6nDIXRGppDBw3KWkKglMYXQpDhvaeIlcCTx2pzpLWut1MnOcN
         1/DKpftdDHWzVQOZP/4gIRrAtEJd7z91mY/t+16U=
Date:   Fri, 03 Sep 2021 13:56:09 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  [merged]
 fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch removed from -mm
 tree
Message-ID: <20210903205609.dBuy68ldP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: drop_caches: fix skipping over shadow cache inodes
has been removed from the -mm tree.  Its filename was
     fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

