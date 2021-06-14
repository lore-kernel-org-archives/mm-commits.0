Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AEEC2B9F4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8722561166
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhFNWCy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 18:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230230AbhFNWCs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 18:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4499D61209;
        Mon, 14 Jun 2021 22:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623708045;
        bh=IozP6bYxdZVR269aTpRpn89FxbGay2HMIodAjpn/2s0=;
        h=Date:From:To:Subject:From;
        b=Ewq4qHfnAAuEkO7g2csJLLbho5LMQaW+Hw8xIjEx5QOCEELkx+b2G4yQgHwJALN24
         Ffv/ItBy4Ze6SFyz2KeQwKP3uZPW/C9i0KQjH3c2bnQI1gMv2vey6nqOPgnvbsWkTH
         YMWbQ/sebm9WdixYEuNJSMhJSub+V3obha9O5VF8=
Date:   Mon, 14 Jun 2021 15:00:44 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  +
 fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch added to -mm
 tree
Message-ID: <20210614220044.hJxSaXNK7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: drop_caches: fix skipping over shadow cache inodes
has been added to the -mm tree.  Its filename is
     fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Reported-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
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

mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

