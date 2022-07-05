Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57E0C43334
	for <mm-commits@archiver.kernel.org>; Tue,  5 Jul 2022 22:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiGEW0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiGEW0U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2022 18:26:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FF814020
        for <mm-commits@vger.kernel.org>; Tue,  5 Jul 2022 15:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77F1DB8199E
        for <mm-commits@vger.kernel.org>; Tue,  5 Jul 2022 22:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28644C341C7;
        Tue,  5 Jul 2022 22:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657059976;
        bh=jwm47+piYrxzgmwgeJgLywiPlRS1EHZwgXVRYhO9wdI=;
        h=Date:To:From:Subject:From;
        b=UTiJuf4LnkQAMRQx9eAiVX4kedewR0HqNM9WD4vYHLFYZ8+rA+VU+tgbmtQCF5Ger
         7E1Q0Ajjw0CF7VXZ0xNeNhQ9VdLahl9/+9e218oClQd21oAViZE7f092fkqW79SmIH
         6JH5SubQvJvQ7ZmAHYHVt23E0tYwm7hbaZWPm7/4=
Date:   Tue, 05 Jul 2022 15:26:15 -0700
To:     mm-commits@vger.kernel.org, guoren@kernel.org, chris@zankel.net,
        anshuman.khandual@arm.com, jcmvbkbc@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-mm-enable-arch_has_vm_get_page_prot-fix.patch added to mm-unstable branch
Message-Id: <20220705222616.28644C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: noMMU: fix vm_get_page_prot definition
has been added to the -mm mm-unstable branch.  Its filename is
     xtensa-mm-enable-arch_has_vm_get_page_prot-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xtensa-mm-enable-arch_has_vm_get_page_prot-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: xtensa: noMMU: fix vm_get_page_prot definition
Date: Tue, 5 Jul 2022 15:14:11 -0700

Don't define protection_map and don't use DECLARE_VM_GET_PAGE_PROT in
noMMU configs, because in that case the definition for vm_get_page_prot is
provided by the include/linux/mm.h

Link: https://lkml.kernel.org/r/20220705221411.3381797-1-jcmvbkbc@gmail.com
Fixes: 61ab8053710f ("xtensa/mm: enable ARCH_HAS_VM_GET_PAGE_PROT")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/xtensa/mm/init.c~xtensa-mm-enable-arch_has_vm_get_page_prot-fix
+++ a/arch/xtensa/mm/init.c
@@ -217,6 +217,7 @@ static int __init parse_memmap_opt(char
 }
 early_param("memmap", parse_memmap_opt);
 
+#ifdef CONFIG_MMU
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= PAGE_NONE,
 	[VM_READ]					= PAGE_READONLY,
@@ -236,3 +237,4 @@ static const pgprot_t protection_map[16]
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_EXEC
 };
 DECLARE_VM_GET_PAGE_PROT
+#endif
_

Patches currently in -mm which might be from jcmvbkbc@gmail.com are

xtensa-mm-enable-arch_has_vm_get_page_prot-fix.patch

