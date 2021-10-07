Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FA2C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 21:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6AED61058
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 21:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhJGVH0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233176AbhJGVHY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 17:07:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE1BA61058;
        Thu,  7 Oct 2021 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633640730;
        bh=nD6BPOzXh7cySGPbqC3PorzVDZK9zkQ9SP4Tq6LOtE8=;
        h=Date:From:To:Subject:From;
        b=psJeOPUMnor+pn/hie/utAE+qy81JLvE1A+2lPMD2FFD/bXns4mAA0Hn3zbMvBM6R
         wphoVjh8fUfNjMqAQcLGw/dVOLWiOGdKtEwXeynt2YnI9dbgkGqIl/8PTqLQJJkVOf
         VZBwP3uU2Z58c4xieUGMSidQP9M9X0P9IrV7+dFA=
Date:   Thu, 07 Oct 2021 14:05:29 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, brho@google.com,
        catalin.marinas@arm.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  + elfcore-correct-reference-to-config_uml-fix.patch added
 to -mm tree
Message-ID: <20211007210529.WB5DLxK7H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: elfcore-correct-reference-to-config_uml-fix
has been added to the -mm tree.  Its filename is
     elfcore-correct-reference-to-config_uml-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/elfcore-correct-reference-to-config_uml-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/elfcore-correct-reference-to-config_uml-fix.patch

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

elfcore-correct-reference-to-config_uml-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

