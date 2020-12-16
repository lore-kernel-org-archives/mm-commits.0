Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B252C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A1023441
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgLPRJb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59887 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLPRJb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:31 -0500
Date:   Wed, 16 Dec 2020 09:08:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138507;
        bh=pgUcgQQX9OZbFsDoL1jaIxJYo7RPtdrw5rXLDwOmLWs=;
        h=From:To:Subject:From;
        b=fZNNTQoDsrstrG3cjH2547OjIKPF/3+9hGfmnD1qled1FzwVHbh+qIV3SgFQBtvBq
         QvuYu1VPHlwhiWdT3eq2hVwtW2hbzRJAlVmIMVgv+V9KTtrfuGMM3lEYkWY7qhtHum
         dx/zydvQjpDDI3ynCxpub49imOQb7MtpjiTZH/j4=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, ebiederm@xmission.com,
        mm-commits@vger.kernel.org, sh_def@163.com
Subject:  [merged] fs-proc-make-pde_get-return-nothing.patch
 removed from -mm tree
Message-ID: <20201216170827.Mt71xXzMe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: make pde_get() return nothing
has been removed from the -mm tree.  Its filename was
     fs-proc-make-pde_get-return-nothing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: fs/proc: make pde_get() return nothing

We don't need pde_get()'s return value, so make pde_get() return nothing

Link: https://lkml.kernel.org/r/20201211061944.GA2387571@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/proc/internal.h~fs-proc-make-pde_get-return-nothing
+++ a/fs/proc/internal.h
@@ -190,10 +190,9 @@ struct dentry *proc_lookup_de(struct ino
 extern int proc_readdir(struct file *, struct dir_context *);
 int proc_readdir_de(struct file *, struct dir_context *, struct proc_dir_entry *);
 
-static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
+static inline void pde_get(struct proc_dir_entry *pde)
 {
 	refcount_inc(&pde->refcnt);
-	return pde;
 }
 extern void pde_put(struct proc_dir_entry *);
 
_

Patches currently in -mm which might be from sh_def@163.com are

mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

