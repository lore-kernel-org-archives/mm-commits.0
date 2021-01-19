Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6346FC4332E
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F7D022E01
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbhASTlq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:41:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbhASTbT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:31:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0752223103;
        Tue, 19 Jan 2021 19:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611084631;
        bh=FC9xZaIF2rUsi35olyfRJ94ab7CCRHg0kqxpaTe3eX8=;
        h=Date:From:To:Subject:From;
        b=jKZQ/R95ycPUikD0NAvG9eqG3qj9hpouxov3gPh5x+Si98O20/vgEQNLmDEZFHnWq
         bLgH6v7GrXgkemC7h/qWWiIPJyT52Wav3gzgoHBZ8wyKbXUBlfIHgoXeyeX6E0DQEE
         CL8vxiU2xcczugxmnvQLDsg+GptpMRvmKBY/7Glc=
Date:   Tue, 19 Jan 2021 11:30:30 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, guozh88@chinatelecom.cn,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  +
 ocfs2-cleanup-some-definitions-which-is-not-used-anymore.patch added to -mm
 tree
Message-ID: <20210119193030.YagEJKbUi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up some definitions which are not used any more
has been added to the -mm tree.  Its filename is
     ocfs2-cleanup-some-definitions-which-is-not-used-anymore.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cleanup-some-definitions-which-is-not-used-anymore.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cleanup-some-definitions-which-is-not-used-anymore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: guozh <guozh88@chinatelecom.cn>
Subject: ocfs2: clean up some definitions which are not used any more

There are some definitions which is not used anymore in OCFS2 module, so
as to be removed.

Link: https://lkml.kernel.org/r/2021011916182284700534@chinatelecom.cn
Signed-off-by: Guozhonghua <guozh88@chinatelecom.cn>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
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

ocfs2-cleanup-some-definitions-which-is-not-used-anymore.patch

