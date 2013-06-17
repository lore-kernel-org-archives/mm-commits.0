From: akpm@linux-foundation.org
Subject: +
 fs-ocfs2-journalh-add-bits_wanted-while-calculating-credits-in-ocfs2_calc_extend_credits.patch added to -mm tree
Date: Mon, 17 Jun 2013 14:17:45 -0700
Message-ID: <51bf7cf9.QcLkJqfByMBRE2hH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab3FQVRq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jun 2013 17:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, rgoldwyn@gmail.com

Subject: + fs-ocfs2-journalh-add-bits_wanted-while-calculating-credits-in-ocfs2_calc_extend_credits.patch added to -mm tree
To: rgoldwyn@gmail.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Mon, 17 Jun 2013 14:17:45 -0700


The patch titled
     Subject: fs/ocfs2/journal.h: add bits_wanted while calculating credits in ocfs2_calc_extend_credits
has been added to the -mm tree.  Its filename is
     fs-ocfs2-journalh-add-bits_wanted-while-calculating-credits-in-ocfs2_calc_extend_credits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: fs/ocfs2/journal.h: add bits_wanted while calculating credits in ocfs2_calc_extend_credits

While adding extends to a file, the credits are calculated incorrectly and
if the requested clusters is more than one (or more because we used a
conservative limit) then we run out of journal credits and we hit an
assert in journalling code.

The function parameter bits_wanted variable was not used at all.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/journal.h~fs-ocfs2-journalh-add-bits_wanted-while-calculating-credits-in-ocfs2_calc_extend_credits fs/ocfs2/journal.h
--- a/fs/ocfs2/journal.h~fs-ocfs2-journalh-add-bits_wanted-while-calculating-credits-in-ocfs2_calc_extend_credits
+++ a/fs/ocfs2/journal.h
@@ -537,7 +537,7 @@ static inline int ocfs2_calc_extend_cred
 	extent_blocks = 1 + 1 + le16_to_cpu(root_el->l_tree_depth);
 
 	return bitmap_blocks + sysfile_bitmap_blocks + extent_blocks +
-	       ocfs2_quota_trans_credits(sb);
+	       ocfs2_quota_trans_credits(sb) + bits_wanted;
 }
 
 static inline int ocfs2_calc_symlink_credits(struct super_block *sb)
_

Patches currently in -mm which might be from rgoldwyn@gmail.com are

ocfs2-remove-unecessary-variable-needs_checkpoint.patch
fs-ocfs2-journalh-add-bits_wanted-while-calculating-credits-in-ocfs2_calc_extend_credits.patch

