From: akpm@linux-foundation.org
Subject: + shmem-remove-redundant-code.patch added to -mm tree
Date: Thu, 18 Mar 2010 12:20:50 -0700
Message-ID: <201003181920.o2IJKoVr010846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986Ab0CRTU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 15:20:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, hugh.dickins@tiscali.co.uk, minchan.kim@gmail.com


The patch titled
     shmem: remove redundant code
has been added to the -mm tree.  Its filename is
     shmem-remove-redundant-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem: remove redundant code
From: Huang Shijie <shijie8@gmail.com>

prep_new_page() will call set_page_private(page, 0) to initialise the
page, so the code is redundant.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/shmem.c~shmem-remove-redundant-code mm/shmem.c
--- a/mm/shmem.c~shmem-remove-redundant-code
+++ a/mm/shmem.c
@@ -433,8 +433,6 @@ static swp_entry_t *shmem_swp_alloc(stru
 
 		spin_unlock(&info->lock);
 		page = shmem_dir_alloc(mapping_gfp_mask(inode->i_mapping));
-		if (page)
-			set_page_private(page, 0);
 		spin_lock(&info->lock);
 
 		if (!page) {
_

Patches currently in -mm which might be from shijie8@gmail.com are

linux-next.patch
shmem-remove-redundant-code.patch

