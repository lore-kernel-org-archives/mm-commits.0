Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971CDC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6312760233
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWxL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEHWxL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE0160233;
        Sat,  8 May 2021 22:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514329;
        bh=CTjlMADHg6DnlgK3d+9mtYOPsOJJ+FN9bKU+JJxRKws=;
        h=Date:From:To:Subject:From;
        b=0Ew9aCEaL5oPhoQMggdv7FtgFKpcqhdA4i9Ef/YsDgTnKenWXnU6AM4UZEPycAJMo
         vHrEzwZA9SqicHciK1LyAPhAtFI/P2sUv9YQFk8FGQyDoTrFxvL8Ii9rjFwwoVCEwD
         NpU4qnUDpGbKMSIu4R7KAv/Pc+/9paVIeUSZl/PQ=
Date:   Sat, 08 May 2021 15:52:09 -0700
From:   akpm@linux-foundation.org
To:     linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org
Subject:  [merged] kernel-credc-make-init_groups-static.patch
 removed from -mm tree
Message-ID: <20210508225209.EGB7iVXo_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cred.c: make init_groups static
has been removed from the -mm tree.  Its filename was
     kernel-credc-make-init_groups-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/cred.c: make init_groups static

init_groups is declared in both cred.h and init_task.h, but it is not
actually referenced anywhere outside of cred.c where it is defined.  So
make it static and remove the declarations.

Link: https://lkml.kernel.org/r/20210310220102.2484201-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h      |    1 -
 include/linux/init_task.h |    1 -
 kernel/cred.c             |    2 +-
 3 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/cred.h~kernel-credc-make-init_groups-static
+++ a/include/linux/cred.h
@@ -53,7 +53,6 @@ do {							\
 		groups_free(group_info);		\
 } while (0)
 
-extern struct group_info init_groups;
 #ifdef CONFIG_MULTIUSER
 extern struct group_info *groups_alloc(int);
 extern void groups_free(struct group_info *);
--- a/include/linux/init_task.h~kernel-credc-make-init_groups-static
+++ a/include/linux/init_task.h
@@ -25,7 +25,6 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 extern struct nsproxy init_nsproxy;
-extern struct group_info init_groups;
 extern struct cred init_cred;
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
--- a/kernel/cred.c~kernel-credc-make-init_groups-static
+++ a/kernel/cred.c
@@ -33,7 +33,7 @@ do {									\
 static struct kmem_cache *cred_jar;
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
-struct group_info init_groups = { .usage = ATOMIC_INIT(2) };
+static struct group_info init_groups = { .usage = ATOMIC_INIT(2) };
 
 /*
  * The initial credentials for the initial task
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


