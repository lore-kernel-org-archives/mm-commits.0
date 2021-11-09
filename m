Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4841C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A364619E5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239382AbhKICis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238412AbhKICis (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3530619A6;
        Tue,  9 Nov 2021 02:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425363;
        bh=9aKcy7EmmvzTQioA3ybV217/iO/BSq0x/4lc3yjUXyo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LL0bHffpr86epX6sdBUNSA1/tNTfDNbwszJiyRXhKDD990m+bj6ZriDKrL2x+DK9p
         z9yrOiHrKaNU/eT5ywjm9394drAZdFoZUggwwiuW3F4boOp/XGSw7POxOae/8Tsazw
         2AszTMxK0ILJLnkgroNfuw0SLau1FHLdzvXb2J+U=
Date:   Mon, 08 Nov 2021 18:36:02 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dbueso@suse.de, ebiederm@xmission.com,
        linux-mm@kvack.org, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 87/87] ipc/ipc_sysctl.c: remove fallback for
 !CONFIG_PROC_SYSCTL
Message-ID: <20211109023602.uMF0RtjXa%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/ipc_sysctl.c: remove fallback for !CONFIG_PROC_SYSCTL

Compilation of ipc/ipc_sysctl.c is controlled by
obj-$(CONFIG_SYSVIPC_SYSCTL)
[see ipc/Makefile]

And CONFIG_SYSVIPC_SYSCTL depends on SYSCTL
[see init/Kconfig]

An SYSCTL is selected by PROC_SYSCTL.
[see fs/proc/Kconfig]

Thus: #ifndef CONFIG_PROC_SYSCTL in ipc/ipc_sysctl.c is impossible, the
fallback can be removed.

Link: https://lkml.kernel.org/r/20210918145337.3369-1-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/ipc/ipc_sysctl.c~ipc-ipc_sysctlc-remove-fallback-for-config_proc_sysctl
+++ a/ipc/ipc_sysctl.c
@@ -23,7 +23,6 @@ static void *get_ipc(struct ctl_table *t
 	return which;
 }
 
-#ifdef CONFIG_PROC_SYSCTL
 static int proc_ipc_dointvec(struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -118,18 +117,6 @@ static int proc_ipc_dointvec_minmax_chec
 }
 #endif
 
-#else
-#define proc_ipc_doulongvec_minmax NULL
-#define proc_ipc_dointvec	   NULL
-#define proc_ipc_dointvec_minmax   NULL
-#define proc_ipc_dointvec_minmax_orphans   NULL
-#define proc_ipc_auto_msgmni	   NULL
-#define proc_ipc_sem_dointvec	   NULL
-#ifdef CONFIG_CHECKPOINT_RESTORE
-#define proc_ipc_dointvec_minmax_checkpoint_restore	NULL
-#endif	/* CONFIG_CHECKPOINT_RESTORE */
-#endif
-
 int ipc_mni = IPCMNI;
 int ipc_mni_shift = IPCMNI_SHIFT;
 int ipc_min_cycle = RADIX_TREE_MAP_SIZE;
_
