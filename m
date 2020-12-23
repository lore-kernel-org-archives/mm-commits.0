Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59957C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DCA522482
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgLWUab (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 15:30:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727187AbgLWUab (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 15:30:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C3C6221FA;
        Wed, 23 Dec 2020 20:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608755390;
        bh=Wmn8pWI+7yyXDNsocovTQnHGI6+LhjiEqeBVc1JNgvw=;
        h=Date:From:To:Subject:From;
        b=ZKNE/pGIFsmKnjz9JqDpHHw5GbnGo1KrgFmbsulKb8+xIbmEGOWrm0foP1V7xjM4a
         aO0HJ7oyeuDqpAFlW0uGOwiNZi6Y5o0FH2xpVDxKj9oev3Ns95nZfNVitsWtosm3Ne
         ak3HqsxNQJDBqgYmk7P38er1wloGr1H1R7qMHISg=
Date:   Wed, 23 Dec 2020 12:29:50 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, deller@gmx.de, adobriyan@gmail.com,
        akpm@linux-foundation.org
Subject:  [withdrawn]
 proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch removed
 from -mm tree
Message-ID: <20201223202950.McVa1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix
has been removed from the -mm tree.  Its filename was
     proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix

further simplification

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/fs/proc/base.c~proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix
+++ a/fs/proc/base.c
@@ -384,15 +384,8 @@ static const struct file_operations proc
 static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
 {
-	unsigned long wchan;
-
 	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
-		wchan = get_wchan(task);
-	else
-		wchan = 0;
-
-	if (wchan)
-		seq_printf(m, "%ps", (void *) wchan);
+		seq_printf(m, "%ps", (void *)get_wchan(task));
 	else
 		seq_putc(m, '0');
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-prototype-for-__add_to_page_cache_locked-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

