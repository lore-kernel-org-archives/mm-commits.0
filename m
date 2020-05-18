From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 ntfs-replace-attach_page_buffers-with-attach_page_private.patch added to
 -mm tree
Date: Mon, 18 May 2020 14:46:23 -0700
Message-ID: <20200518214623.JXxuH9RAy%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgERVqZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:46:25 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@tuxera.com, guoqing.jiang@cloud.ionos.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: replace attach_page_buffers with attach_page_private
has been added to the -mm tree.  Its filename is
     ntfs-replace-attach_page_buffers-with-attach_page_private.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntfs-replace-attach_page_buffers-with-attach_page_private.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntfs-replace-attach_page_buffers-with-attach_page_private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: ntfs: replace attach_page_buffers with attach_page_private

Call the new function since attach_page_buffers will be removed.

Link: http://lkml.kernel.org/r/20200517214718.468-8-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/aops.c |    2 +-
 fs/ntfs/mft.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ntfs/aops.c~ntfs-replace-attach_page_buffers-with-attach_page_private
+++ a/fs/ntfs/aops.c
@@ -1732,7 +1732,7 @@ void mark_ntfs_record_dirty(struct page
 				bh = bh->b_this_page;
 			} while (bh);
 			tail->b_this_page = head;
-			attach_page_buffers(page, head);
+			attach_page_private(page, head);
 		} else
 			buffers_to_free = bh;
 	}
--- a/fs/ntfs/mft.c~ntfs-replace-attach_page_buffers-with-attach_page_private
+++ a/fs/ntfs/mft.c
@@ -504,7 +504,7 @@ int ntfs_sync_mft_mirror(ntfs_volume *vo
 			bh = bh->b_this_page;
 		} while (bh);
 		tail->b_this_page = head;
-		attach_page_buffers(page, head);
+		attach_page_private(page, head);
 	}
 	bh = head = page_buffers(page);
 	BUG_ON(!bh);
_

Patches currently in -mm which might be from guoqing.jiang@cloud.ionos.com are

include-linux-pagemaph-introduce-attach-detach_page_private.patch
md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch
btrfs-use-attach-detach_page_private.patch
fs-bufferc-use-attach-detach_page_private.patch
f2fs-use-attach-detach_page_private.patch
iomap-use-attach-detach_page_private.patch
ntfs-replace-attach_page_buffers-with-attach_page_private.patch
orangefs-use-attach-detach_page_private.patch
buffer_headh-remove-attach_page_buffers.patch
mm-migratec-call-detach_page_private-to-cleanup-code.patch
