From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 045/128] ntfs: replace attach_page_buffers with
 attach_page_private
Date: Tue, 02 Jun 2020 13:12:37 -0700
Message-ID: <20200602201237.SK-v7vNqW%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBUMi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:12:38 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anton@tuxera.com, guoqing.jiang@cloud.ionos.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: ntfs: replace attach_page_buffers with attach_page_private

Call the new function since attach_page_buffers will be removed.

Link: http://lkml.kernel.org/r/20200517214718.468-8-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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
