From: akpm@linux-foundation.org
Subject: + ocfs2-dont-spam-on-edquot.patch added to -mm tree
Date: Fri, 20 Sep 2013 13:50:12 -0700
Message-ID: <523cb504.bf6EQ79A4F7NwWZ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3ITUuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, admin@wset.edu.pl, jlbec@evilplan.org

Subject: + ocfs2-dont-spam-on-edquot.patch added to -mm tree
To: jlbec@evilplan.org,admin@wset.edu.pl,jack@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:50:12 -0700


The patch titled
     Subject: ocfs2: don't spam on -EDQUOT
has been added to the -mm tree.  Its filename is
     ocfs2-dont-spam-on-edquot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dont-spam-on-edquot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dont-spam-on-edquot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joel Becker <jlbec@evilplan.org>
Subject: ocfs2: don't spam on -EDQUOT

-EDQUOT is a user-visible error, not a logic problem.  Teach mlog_errno()
to ignore it like it ignores -ENOSPC, etc.

Signed-off-by: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: Marek Królikowski <admin@wset.edu.pl>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/masklog.h~ocfs2-dont-spam-on-edquot fs/ocfs2/cluster/masklog.h
--- a/fs/ocfs2/cluster/masklog.h~ocfs2-dont-spam-on-edquot
+++ a/fs/ocfs2/cluster/masklog.h
@@ -199,7 +199,8 @@ extern struct mlog_bits mlog_and_bits, m
 #define mlog_errno(st) do {						\
 	int _st = (st);							\
 	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
-	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC)		\
+	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
+	    _st != -EDQUOT)						\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
 } while (0)
 
_

Patches currently in -mm which might be from jlbec@evilplan.org are

fs-ocfs2-superc-use-a-bigger-nodestr-in-ocfs2_dismount_volume.patch
fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits.patch
fs-ocfs2-filec-fix-wrong-comment.patch
ocfs2-return-enomem-when-sb_getblk-fails.patch
ocfs2-return-enomem-when-sb_getblk-fails-update.patch
ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch
ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch
ocfs2-dont-spam-on-edquot.patch
ocfs2-use-bitmap_weight.patch
ocfs2-skip-locks-in-the-blocked-list.patch
ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch
ocfs2-use-find_last_bit.patch
ocfs2-break-useless-while-loop.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
linux-next.patch

