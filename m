Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D71C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87A9364F29
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhBXUCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235092AbhBXUCJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99CE564F09;
        Wed, 24 Feb 2021 20:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196839;
        bh=5SLsoieTj/NszhC297QywX3bjC/l54Nq9Xzmhrozaow=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JuDP6vPl2Jyv3SNNgZOdzS8lel2aURWY84bNZkYZoCHh4cV+6SHevexaly5Wgtx67
         Idgg/ugUj4iM/Wxi/5/abeApXBuAN+nxf5rV56/jKVhsjSch6RBShgRDSoMfDAckBo
         ENngPcu2lNd6dGI3IFQGwt3UJZKELyl43IoOXIJM=
Date:   Wed, 24 Feb 2021 12:00:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        guozh88@chinatelecom.cn, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 009/173] ocfs2: clean up some definitions which
 are not used any more
Message-ID: <20210224200038.8DNzWkTSw%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: guozh <guozh88@chinatelecom.cn>
Subject: ocfs2: clean up some definitions which are not used any more

There are some definitions which is not used anymore in OCFS2 module, so
as to be removed.

Link: https://lkml.kernel.org/r/2021011916182284700534@chinatelecom.cn
Signed-off-by: Guozhonghua <guozh88@chinatelecom.cn>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmast.c    |   10 ----------
 fs/ocfs2/dlm/dlmcommon.h |    4 ----
 2 files changed, 14 deletions(-)

--- a/fs/ocfs2/dlm/dlmast.c~ocfs2-cleanup-some-definitions-which-is-not-used-anymore
+++ a/fs/ocfs2/dlm/dlmast.c
@@ -165,16 +165,6 @@ void __dlm_queue_bast(struct dlm_ctxt *d
 	spin_unlock(&lock->spinlock);
 }
 
-void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
-{
-	BUG_ON(!dlm);
-	BUG_ON(!lock);
-
-	spin_lock(&dlm->ast_lock);
-	__dlm_queue_bast(dlm, lock);
-	spin_unlock(&dlm->ast_lock);
-}
-
 static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			   struct dlm_lock *lock)
 {
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-cleanup-some-definitions-which-is-not-used-anymore
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -17,10 +17,7 @@
 
 #define DLM_LOCKID_NAME_MAX    32
 
-#define DLM_DOMAIN_NAME_MAX_LEN    255
 #define DLM_LOCK_RES_OWNER_UNKNOWN     O2NM_MAX_NODES
-#define DLM_THREAD_SHUFFLE_INTERVAL    5     // flush everything every 5 passes
-#define DLM_THREAD_MS                  200   // flush at least every 200 ms
 
 #define DLM_HASH_SIZE_DEFAULT	(1 << 17)
 #if DLM_HASH_SIZE_DEFAULT < PAGE_SIZE
@@ -902,7 +899,6 @@ void __dlm_lockres_grab_inflight_worker(
 		struct dlm_lock_resource *res);
 
 void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
-void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_do_local_ast(struct dlm_ctxt *dlm,
_
