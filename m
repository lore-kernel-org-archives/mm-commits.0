From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-get-mle-inuse-only-when-it-is-initialized.patch removed from -mm
 tree
Date: Thu, 16 Nov 2017 11:59:08 -0800
Message-ID: <20171116195908.osdy2A75h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934048AbdKPT7J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 14:59:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: get mle inuse only when it is initialized
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-get-mle-inuse-only-when-it-is-initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2/dlm: get mle inuse only when it is initialized

When dlm_add_migration_mle returns -EEXIST, previously input mle will not
be initialized.  So we can't use its associated dlm object.  And we truly
don't need this mle for already launched migration progress, since oldmle
has taken this role.

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373CED7AA61@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-get-mle-inuse-only-when-it-is-initialized fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-get-mle-inuse-only-when-it-is-initialized
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2616,7 +2616,9 @@ static int dlm_migrate_lockres(struct dl
 	 * otherwise the assert_master from the new
 	 * master will destroy this.
 	 */
-	dlm_get_mle_inuse(mle);
+	if (ret != -EEXIST)
+		dlm_get_mle_inuse(mle);
+
 	spin_unlock(&dlm->master_lock);
 	spin_unlock(&dlm->spinlock);
 
_

Patches currently in -mm which might be from ge.changwei@h3c.com are


