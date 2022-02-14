Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36842C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 23:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiBNXHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 18:07:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiBNXHF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 18:07:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16517B0A60
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 15:06:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D982B811E1
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 23:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5EAC340E9;
        Mon, 14 Feb 2022 23:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644880012;
        bh=DGr767iXkP/Sj2Ko6bMhuoCg+E4Qq7eiq0tjvQxIzp8=;
        h=Date:To:From:Subject:From;
        b=X30mpTR+zz/AWndnD6Mw2rs5StV6Ytv2XLvvGTrkdwFsWM12dklZAwg8K29kZnPpw
         RirhGhYDDGafhhDx83zzbZe8VhX8kHbR/bBzSogtnd8exN87++OFICfXuxXVVelgla
         q0k2/2cMp04cUv8xcpR+6traEMnZ0rYnuVNVmrz0=
Date:   Mon, 14 Feb 2022 15:06:52 -0800
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + binfmt-move-more-stuff-undef-config_coredump.patch added to -mm tree
Message-Id: <20220214230652.9B5EAC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt: move more stuff undef CONFIG_COREDUMP
has been added to the -mm tree.  Its filename is
     binfmt-move-more-stuff-undef-config_coredump.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/binfmt-move-more-stuff-undef-config_coredump.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/binfmt-move-more-stuff-undef-config_coredump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: binfmt: move more stuff undef CONFIG_COREDUMP

struct linux_binfmt::core_dump and struct min_coredump::min_coredump are
used under CONFIG_COREDUMP only.  Shrink those embedded configs a bit.

Link: https://lkml.kernel.org/r/YglbIFyN+OtwVyjW@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c         |    2 ++
 fs/binfmt_elf_fdpic.c   |    2 +-
 fs/binfmt_flat.c        |    2 ++
 include/linux/binfmts.h |    2 ++
 4 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~binfmt-move-more-stuff-undef-config_coredump
+++ a/fs/binfmt_elf.c
@@ -101,8 +101,10 @@ static struct linux_binfmt elf_format =
 	.module		= THIS_MODULE,
 	.load_binary	= load_elf_binary,
 	.load_shlib	= load_elf_library,
+#ifdef CONFIG_COREDUMP
 	.core_dump	= elf_core_dump,
 	.min_coredump	= ELF_EXEC_PAGESIZE,
+#endif
 };
 
 #define BAD_ADDR(x) (unlikely((unsigned long)(x) >= TASK_SIZE))
--- a/fs/binfmt_elf_fdpic.c~binfmt-move-more-stuff-undef-config_coredump
+++ a/fs/binfmt_elf_fdpic.c
@@ -83,8 +83,8 @@ static struct linux_binfmt elf_fdpic_for
 	.load_binary	= load_elf_fdpic_binary,
 #ifdef CONFIG_ELF_CORE
 	.core_dump	= elf_fdpic_core_dump,
-#endif
 	.min_coredump	= ELF_EXEC_PAGESIZE,
+#endif
 };
 
 static int __init init_elf_fdpic_binfmt(void)
--- a/fs/binfmt_flat.c~binfmt-move-more-stuff-undef-config_coredump
+++ a/fs/binfmt_flat.c
@@ -102,8 +102,10 @@ static int flat_core_dump(struct coredum
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_flat_binary,
+#ifdef CONFIG_COREDUMP
 	.core_dump	= flat_core_dump,
 	.min_coredump	= PAGE_SIZE
+#endif
 };
 
 /****************************************************************************/
--- a/include/linux/binfmts.h~binfmt-move-more-stuff-undef-config_coredump
+++ a/include/linux/binfmts.h
@@ -98,8 +98,10 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *);
 	int (*load_shlib)(struct file *);
+#ifdef CONFIG_COREDUMP
 	int (*core_dump)(struct coredump_params *cprm);
 	unsigned long min_coredump;	/* minimal dump size */
+#endif
 } __randomize_layout;
 
 extern void __register_binfmt(struct linux_binfmt *fmt, int insert);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

elf-fix-overflow-in-total-mapping-size-calculation.patch
binfmt-move-more-stuff-undef-config_coredump.patch

