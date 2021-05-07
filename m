Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03567C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC42261289
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhEGBDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhEGBDi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C24B5610FA;
        Fri,  7 May 2021 01:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349360;
        bh=0L3kolUuDR8fwQiwrvqc+Ukz3JHygx4cOKiqfpsOpBk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=evPgeOAtJi/tkN5GHMpPgkAu3b0m5B0N9IqRUihZRDDDa7VnK7MJ7s+/A1cG8et1i
         lDUbkuNA5Xjxb9je+AbRuCi7cclsLgRzReSiqTB0fifwMYD8eds25v7MQFzHp7Alsk
         +xwDZiZDyKu/mUGyR9XBGuxTd4OxeQE60sbgTw9Y=
Date:   Thu, 06 May 2021 18:02:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 13/91] kernel/cred.c: make init_groups static
Message-ID: <20210507010239.bYfQQ1TOQ%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
