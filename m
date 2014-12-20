From: akpm@linux-foundation.org
Subject: +
 fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch added to -mm tree
Date: Fri, 19 Dec 2014 16:31:47 -0800
Message-ID: <5494c373.NpWKj45Z6Z4j9wh1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLTAbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 19:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: LinoSanfilippo@gmx.de, eparis@redhat.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: only destroy mark when both mask and ignored_mask are cleared
has been added to the -mm tree.  Its filename is
     fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
