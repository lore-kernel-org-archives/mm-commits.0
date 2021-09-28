Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC48FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 23:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5D5F613A9
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 23:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243278AbhI1XfU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243296AbhI1XfH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 19:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 471E161357;
        Tue, 28 Sep 2021 23:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632872007;
        bh=SCasOI0RhjCEdXR0IhRVNQ6iy60LIi6Kc5Cwn9TgQco=;
        h=Date:From:To:Subject:From;
        b=WQNEXNldgmEREr/A/n4aCg1UjLJ/glE2scPcJWOwqCERJ/GyLvJg1KsUm5tmZQlrK
         lSnzsplAtXllUYcDtSi1d1Bsod6kD+t9LVEPkqh9XBg+WIp4kCXYuz35yWRLcn7dKX
         zYs1nLYHWheRs24lgdLyInv4fFexPteJAHg5V72A=
Date:   Tue, 28 Sep 2021 16:33:26 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, heiko.carstens@de.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org
Subject:  +
 powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch added to
 -mm tree
Message-ID: <20210928233326.NwuoejdX7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: use generic version of arch_is_kernel_initmem_freed()
has been added to the -mm tree.  Its filename is
     powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc: use generic version of arch_is_kernel_initmem_freed()

Generic version of arch_is_kernel_initmem_freed() now does the same
as powerpc version.

Remove the powerpc version.

Link: https://lkml.kernel.org/r/026c4fcbe018d35917e044de823efd57252c12e4.1632813331.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/sections.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/arch/powerpc/include/asm/sections.h~powerpc-use-generic-version-of-arch_is_kernel_initmem_freed
+++ a/arch/powerpc/include/asm/sections.h
@@ -6,21 +6,8 @@
 #include <linux/elf.h>
 #include <linux/uaccess.h>
 
-#define arch_is_kernel_initmem_freed arch_is_kernel_initmem_freed
-
 #include <asm-generic/sections.h>
 
-extern bool init_mem_is_free;
-
-static inline int arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	if (!init_mem_is_free)
-		return 0;
-
-	return addr >= (unsigned long)__init_begin &&
-		addr < (unsigned long)__init_end;
-}
-
 extern char __head_end[];
 
 #ifdef __powerpc64__
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-create-a-new-system-state-and-fix-core_kernel_text.patch
mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch
powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch
s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

