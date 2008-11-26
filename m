From: akpm@linux-foundation.org
Subject: - quota-remove-bogus-optimization-in-check_idq-and-check_bdq.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:27:07 -0800
Message-ID: <200811262027.mAQKR7Uv032764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbYKZU1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:27:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: remove bogus 'optimization' in check_idq() and check_bdq()
has been removed from the -mm tree.  Its filename was
     quota-remove-bogus-optimization-in-check_idq-and-check_bdq.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: remove bogus 'optimization' in check_idq() and check_bdq()
From: Jan Kara <jack@suse.cz>

Checks like <= 0 for an unsigned type do not make much sense.  The value
could be only 0 and that does not happen often enough for the check to be
worth it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dquot.c~quota-remove-bogus-optimization-in-check_idq-and-check_bdq fs/dquot.c
--- a/fs/dquot.c~quota-remove-bogus-optimization-in-check_idq-and-check_bdq
+++ a/fs/dquot.c
@@ -1037,7 +1037,7 @@ static inline char ignore_hardlimit(stru
 static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (inodes <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_ihardlimit &&
@@ -1069,7 +1069,7 @@ static int check_idq(struct dquot *dquot
 static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (space <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_bhardlimit &&
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
quota-remove-bogus-optimization-in-check_idq-and-check_bdq.patch
quota-make-_suspended-just-a-flag.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
ext4-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
quota-remove-compatibility-function-sb_any_quota_enabled.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch

