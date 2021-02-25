Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28D2C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A6E064FB7
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhBYTRQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234109AbhBYTOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:14:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A92BD64F2C;
        Thu, 25 Feb 2021 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280294;
        bh=kEsiz4EaoFbACKfCVIQG2nAYeqCTFX/F7fhUtHVukKk=;
        h=Date:From:To:Subject:From;
        b=Ks0Z4r4YogcSEBAKMuk2Fwbi+lVMufurteHZqvJ7Opn7KhL3cfjilAHzI9sBa8axJ
         +ZhImAhBvIjB/OLIqTPoJVTD6egu5BLspWX5Qo6Cfp4kliuUj0PiQWTKFD/bMMbsT2
         f/ClGAZdyMxb3+0PTutuk2qiqBxfMBTiGFviL9eE=
Date:   Thu, 25 Feb 2021 11:11:33 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, guozh88@chinatelecom.cn,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged]
 ocfs2-cleanup-some-definitions-which-is-not-used-anymore.patch removed from
 -mm tree
Message-ID: <20210225191133.qQAlziJ5o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up some definitions which are not used any more
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-some-definitions-which-is-not-used-anymore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from guozh88@chinatelecom.cn are


