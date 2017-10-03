From: akpm@linux-foundation.org
Subject: + include-linux-fsh-fix-comment-about-struct-address_space.patch
 added to -mm tree
Date: Tue, 03 Oct 2017 14:49:19 -0700
Message-ID: <59d405df.fVAPQYnFYMmaa2ZH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdJCVtU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/fs.h: fix comment about struct address_space
has been added to the -mm tree.  Its filename is
     include-linux-fsh-fix-comment-about-struct-address_space.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-fsh-fix-comment-about-struct-address_space.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-fsh-fix-comment-about-struct-address_space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: include/linux/fs.h: fix comment about struct address_space

Before 9c5d760b8d22 ("mm: split gfp_mask and mapping flags into separate
fields") the private_* fields of struct adrress_space were grouped
together and using "ditto" in comments describing the last fields was
correct.

With introduction of gpf_mask between private_lock and private_list
"ditto" references the wrong description.

Fix it by using the elaborate description.

Link: http://lkml.kernel.org/r/1507009987-8746-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~include-linux-fsh-fix-comment-about-struct-address_space include/linux/fs.h
--- a/include/linux/fs.h~include-linux-fsh-fix-comment-about-struct-address_space
+++ a/include/linux/fs.h
@@ -403,7 +403,7 @@ struct address_space {
 	unsigned long		flags;		/* error bits */
 	spinlock_t		private_lock;	/* for use by the address_space */
 	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
-	struct list_head	private_list;	/* ditto */
+	struct list_head	private_list;	/* for use by the address_space */
 	void			*private_data;	/* ditto */
 	errseq_t		wb_err;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

include-linux-fsh-fix-comment-about-struct-address_space.patch

