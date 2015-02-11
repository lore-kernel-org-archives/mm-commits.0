From: akpm@linux-foundation.org
Subject: [merged]
 fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:20:41 -0800
Message-ID: <54dbb999.vyXemmcv0ieq/44X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: LinoSanfilippo@gmx.de, eparis@redhat.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: only destroy mark when both mask and ignored_mask are cleared
has been removed from the -mm tree.  Its filename was
     fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: fanotify: only destroy mark when both mask and ignored_mask are cleared

In fanotify_mark_remove_from_mask() a mark is destroyed if only one of
both bitmasks (mask or ignored_mask) of a mark is cleared.  However the
other mask may still be set and contain information that should not be
lost.  So only destroy a mark if both masks are cleared.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -497,10 +497,9 @@ static __u32 fanotify_mark_remove_from_m
 		oldmask = fsn_mark->ignored_mask;
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
 	}
+	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
 	spin_unlock(&fsn_mark->lock);
 
-	*destroy = !(oldmask & ~mask);
