From: akpm@linux-foundation.org
Subject: + mm-introduce-kvalloc-helpers-fix.patch added to -mm tree
Date: Tue, 28 Mar 2017 13:58:41 -0700
Message-ID: <58dace81.ep8j48UOqC2TMJAd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36714 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932082AbdC1U6s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 16:58:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, jaegeuk@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce kv[mz]alloc helpers - f2fs fix up
has been added to the -mm tree.  Its filename is
     mm-introduce-kvalloc-helpers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-kvalloc-helpers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-kvalloc-helpers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm: introduce kv[mz]alloc helpers - f2fs fix up

f2fs fixup

Link: http://lkml.kernel.org/r/20170320163735.332e64b7@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/f2fs/node.c~mm-introduce-kvalloc-helpers-fix fs/f2fs/node.c
--- a/fs/f2fs/node.c~mm-introduce-kvalloc-helpers-fix
+++ a/fs/f2fs/node.c
@@ -2651,7 +2651,7 @@ static int init_free_nid_cache(struct f2
 	if (!nm_i->nat_block_bitmap)
 		return -ENOMEM;
 
-	nm_i->free_nid_count = f2fs_kvzalloc(nm_i->nat_blocks *
+	nm_i->free_nid_count = kvzalloc(nm_i->nat_blocks *
 					sizeof(unsigned short), GFP_KERNEL);
 	if (!nm_i->free_nid_count)
 		return -ENOMEM;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-introduce-kvalloc-helpers-fix.patch

