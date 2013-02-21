From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-remove-kfree-redundant-null-checks-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:11:21 -0800
Message-ID: <20130221231121.695775A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36853 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3BUXLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:11:22 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so9974qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:11:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, mfasheh@suse.com, tim.gardner@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-remove-kfree-redundant-null-checks-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-kfree-redundant-null-checks-fix.patch

This patch was dropped because it was folded into ocfs2-remove-kfree-redundant-null-checks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-remove-kfree-redundant-null-checks-fix

revert dubious change in ocfs2_begin_truncate_log_recovery()

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-remove-kfree-redundant-null-checks-fix fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-remove-kfree-redundant-null-checks-fix
+++ a/fs/ocfs2/alloc.c
@@ -6134,7 +6134,7 @@ bail:
 		iput(tl_inode);
 	brelse(tl_bh);
 
-	if (status < 0) {
+	if (status < 0 && (*tl_copy)) {
 		kfree(*tl_copy);
 		*tl_copy = NULL;
 		mlog_errno(status);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch

