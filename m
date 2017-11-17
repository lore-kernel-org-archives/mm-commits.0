From: akpm@linux-foundation.org
Subject: + mm-shmem-remove-unused-info-variable.patch added to -mm tree
Date: Thu, 16 Nov 2017 16:35:02 -0800
Message-ID: <5a0e2eb6.DmuMCAhnJ2oaqU6g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdKQAfD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 19:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clabbe@baylibre.com, hughd@google.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: remove unused info variable
has been added to the -mm tree.  Its filename is
     mm-shmem-remove-unused-info-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-remove-unused-info-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-remove-unused-info-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from clabbe@baylibre.com are

mm-shmem-remove-unused-info-variable.patch

