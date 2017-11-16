From: akpm@linux-foundation.org
Subject: [patch 058/131] f2fs: use pagevec_lookup_range_tag()
Date: Wed, 15 Nov 2017 17:34:48 -0800
Message-ID: <20171116013448.LhqbxY-Qx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932972AbdKPBet (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, jack@suse.cz, jaegeuk@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yuchao0@huawei.com

From: Jan Kara <jack@suse.cz>
Subject: f2fs: use pagevec_lookup_range_tag()

We want only pages from given range in f2fs_write_cache_pages().  Use
pagevec_lookup_range_tag() instead of pagevec_lookup_tag() and remove
unnecessary code.

Link: http://lkml.kernel.org/r/20171009151359.31984-6-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/f2fs/data.c~f2fs-use-pagevec_lookup_range_tag fs/f2fs/data.c
--- a/fs/f2fs/data.c~f2fs-use-pagevec_lookup_range_tag
+++ a/fs/f2fs/data.c
@@ -1669,8 +1669,8 @@ retry:
 	while (!done && (index <= end)) {
 		int i;
 
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			      min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1);
+		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+				tag, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
@@ -1678,11 +1678,6 @@ retry:
 			struct page *page = pvec.pages[i];
 			bool submitted = false;
 
-			if (page->index > end) {
-				done = 1;
-				break;
-			}
