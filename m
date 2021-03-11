Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF11FC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 829EF64F8B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCKAWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhCKAWE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 19:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08AF64F60;
        Thu, 11 Mar 2021 00:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615422123;
        bh=48IPOAxrAp3xlslU1X0Nw5u6974dZIdDIj2FAcSSeBk=;
        h=Date:From:To:Subject:From;
        b=oX6RZFtKhIvsRkUdvjKH5gNQFsdw1ZuXS52X/Q5SQK3W4XnCNNMS72L5BFtX7sHNa
         0VdQaZRVtANcRG7/wcn3+b2tIOoACrcyy8yJ3THFjFC9H7GKLzW7ZrjRbOzm+W6wIt
         ntTN3ARQUGwCXhdR+z4uA7Z0ue+iSj4DVaB1moTI=
Date:   Wed, 10 Mar 2021 16:22:03 -0800
From:   akpm@linux-foundation.org
To:     linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org
Subject:  + kernel-credc-make-init_groups-static.patch added to -mm
 tree
Message-ID: <20210311002203.KE8fl08sR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cred.c: make init_groups static
has been added to the -mm tree.  Its filename is
     kernel-credc-make-init_groups-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-credc-make-init_groups-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-credc-make-init_groups-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-asyncc-fix-pr_debug-statement.patch
kernel-credc-make-init_groups-static.patch

