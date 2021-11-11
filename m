Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D58C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E78261108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhKKC5P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234632AbhKKC5O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:57:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F7506103C;
        Thu, 11 Nov 2021 02:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599266;
        bh=VIaarQuQNykmIhAXMRB6//zK6k+b2yN/6LwjJZjJG0c=;
        h=Date:From:To:Subject:From;
        b=BaoZVdexBZTzM9kKJt5Uv59mMJ/cVGw+KPTQOCqK9Vg/xFcTgL24xc21C7cJusUHO
         +dnE68l3J1ls/j6fvCqoodIamOgngWEwvmld2k+Rdi1GaFkud35/YzFZQs1dhKOZgc
         QN9Oh1f+hZunn+m+GiXk0U87q2GFGUhREem3Wz+8=
Date:   Wed, 10 Nov 2021 18:54:26 -0800
From:   akpm@linux-foundation.org
To:     dbueso@suse.de, ebiederm@xmission.com, manfred@colorfullife.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 ipc-ipc_sysctlc-remove-fallback-for-config_proc_sysctl.patch removed from
 -mm tree
Message-ID: <20211111025426.8pCz8l-wc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/ipc_sysctl.c: remove fallback for !CONFIG_PROC_SYSCTL
has been removed from the -mm tree.  Its filename was
     ipc-ipc_sysctlc-remove-fallback-for-config_proc_sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from manfred@colorfullife.com are


