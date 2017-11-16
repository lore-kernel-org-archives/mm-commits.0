From: akpm@linux-foundation.org
Subject: [patch 011/131] ocfs2/dlm: get mle inuse only when it is
 initialized
Date: Wed, 15 Nov 2017 17:31:52 -0800
Message-ID: <20171116013152.cJomuAjFT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933442AbdKPBby (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:31:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
