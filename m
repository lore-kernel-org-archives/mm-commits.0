Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B294C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 03:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17B5F20705
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 03:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgLWDEt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 22:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728548AbgLWCTO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90F962332A;
        Wed, 23 Dec 2020 02:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608689914;
        bh=2Wu7ezOQLvqZIvFRVykMYFxZ3u485hCdejWTHqYrnzQ=;
        h=Date:From:To:Subject:From;
        b=mx+wHc80FOEq+IYDzqvQTsUG54/ylx7vPKTrEjX1VOi5HNssP8Nfjknqo5CwF1iab
         uvb8pDMJ3MsN986z9Wck9YCCUREG1aVzOKSx5OQSt79RLrGwuDIpiT38rkJZjr41j6
         kvI9xg913sFrEN4jPYp+3crLZrnLHQ+NKG199Ttw=
Date:   Tue, 22 Dec 2020 18:18:34 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, deller@gmx.de, adobriyan@gmail.com,
        akpm@linux-foundation.org
Subject:  +
 proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch added to
 -mm tree
Message-ID: <20201223021834.9n93L%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix
has been added to the -mm tree.  Its filename is
     proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

