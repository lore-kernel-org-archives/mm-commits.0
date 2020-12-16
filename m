Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E511C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66DF723332
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgLPEoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgLPEoO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:14 -0500
Date:   Tue, 15 Dec 2020 20:42:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093763;
        bh=g2pay3zyx7b/pINp/x/owWlFtpWlkImkX6LvlPQcVQw=;
        h=From:To:Subject:In-Reply-To:From;
        b=tWtHEupr4gyQ0AUkBilOSnUptBUk8Yb0Lzdq06LzCoRL9/Jr/bZugrbB03/jLuIPq
         UOinTDDB5Wpq3ng+YsErs1Y1+nEfQ4MmYMlfvRsoGBxJ+vV5+73NvN6O2rHQX17wsY
         enxpMRzdoJQr+abPfW383JqKVPlJRwI8LaTY+Rq4=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sh_def@163.com,
        torvalds@linux-foundation.org
Subject:  [patch 07/95] fs/proc: make pde_get() return nothing
Message-ID: <20201216044242.elmECioKS%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
