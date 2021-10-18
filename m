Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA3CC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC5C56113D
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhJRWJH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhJRWJH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:09:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F5B6112D;
        Mon, 18 Oct 2021 22:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634594815;
        bh=jTP6laton8LLKTDpLoAIHuYdprXUJAtpgzcw3qDAyus=;
        h=Date:From:To:Subject:From;
        b=XQsBgrxPviHPmx0cUTB55OW+FQV5oWj5AG5YDulP1SLZlGINoeB5vS9Q4IQ/lkXMU
         Mzf87JEAzU9JCWjRQ2QHQFMpJUCJD6cKMHexYhuDEf5uFN+5h5tUDQTbJy4YPN8ktH
         b4RWOSbrRsjSi9xrSrN+C6FxFmUrAsrsPLIfiH9k=
Date:   Mon, 18 Oct 2021 15:06:54 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, brho@google.com,
        catalin.marinas@arm.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  [folded-merged]
 elfcore-correct-reference-to-config_uml-fix.patch removed from -mm tree
Message-ID: <20211018220654.LwSAtMvbG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: elfcore-correct-reference-to-config_uml-fix
has been removed from the -mm tree.  Its filename was
     elfcore-correct-reference-to-config_uml-fix.patch

This patch was dropped because it was folded into elfcore-correct-reference-to-config_uml.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: elfcore-correct-reference-to-config_uml-fix

fix um/x86_64, per Catalin

Link: https://lkml.kernel.org/r/20211006181119.2851441-1-catalin.marinas@arm.com
Link: https://lkml.kernel.org/r/YV6pejGzLy5ppEpt@arm.com
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Barret Rhoden <brho@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfcore.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/elfcore.h~elfcore-correct-reference-to-config_uml-fix
+++ a/include/linux/elfcore.h
@@ -109,7 +109,7 @@ static inline int elf_core_copy_task_fpr
 #endif
 }
 
-#if defined(CONFIG_UML) || defined(CONFIG_IA64)
+#if (defined(CONFIG_UML) && defined(CONFIG_X86_32)) || defined(CONFIG_IA64)
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

elfcore-correct-reference-to-config_uml.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

