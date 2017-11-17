From: akpm@linux-foundation.org
Subject: [patch 04/94] mm: shmem: remove unused info variable
Date: Fri, 17 Nov 2017 15:26:23 -0800
Message-ID: <20171117232623.kzi3g8cM4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423240AbdKQX0Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:26:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clabbe@baylibre.com, hughd@google.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Corentin Labbe <clabbe@baylibre.com>
Subject: mm: shmem: remove unused info variable

Fix the following warning by removing the unused variable:
mm/shmem.c:3205:27: warning: variable 'info' set but not used [-Wunused-but-set-variable]

Link: http://lkml.kernel.org/r/1510774029-30652-1-git-send-email-clabbe@baylibre.com
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/shmem.c~mm-shmem-remove-unused-info-variable mm/shmem.c
--- a/mm/shmem.c~mm-shmem-remove-unused-info-variable
+++ a/mm/shmem.c
@@ -3202,7 +3202,6 @@ static int shmem_symlink(struct inode *d
 	int len;
 	struct inode *inode;
 	struct page *page;
-	struct shmem_inode_info *info;
 
 	len = strlen(symname) + 1;
 	if (len > PAGE_SIZE)
@@ -3222,7 +3221,6 @@ static int shmem_symlink(struct inode *d
 		error = 0;
 	}
 
-	info = SHMEM_I(inode);
 	inode->i_size = len-1;
 	if (len <= SHORT_SYMLINK_LEN) {
 		inode->i_link = kmemdup(symname, len, GFP_KERNEL);
_
