Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7D8C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiCYWp4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbiCYWpH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CDD20E975
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 209EF614BD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783C1C340F0;
        Fri, 25 Mar 2022 22:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248201;
        bh=hJvXpLFtw8ASqULu9f2JdCXTawMbHvsbs5DDF8zoapA=;
        h=Date:To:From:Subject:From;
        b=FztHcVpngnfofIkc+9OFPB+8tssHFkpiZH2qXj0u17LExuA1Ojl1sUL+L2yUojB+G
         sXXfEB2c4YbcdB6+lNyroP06lzOV0rxMq/XjkejENP1Sx5KbjiQ4oURfcTJc2tPsIX
         TPc2KmUZpbqy7jEIQt9238nl7zNWS8bL6BNU3/Dg=
Date:   Fri, 25 Mar 2022 15:43:20 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-generalize-arch_has_filter_pgprot.patch removed from -mm tree
Message-Id: <20220325224321.783C1C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalize ARCH_HAS_FILTER_PGPROT
has been removed from the -mm tree.  Its filename was
     mm-generalize-arch_has_filter_pgprot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: generalize ARCH_HAS_FILTER_PGPROT

ARCH_HAS_FILTER_PGPROT config has duplicate definitions on platforms that
subscribe it.  Instead make it a generic config option which can be
selected on applicable platforms when required.

Link: https://lkml.kernel.org/r/1643004823-16441-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    3 ---
 mm/Kconfig       |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/Kconfig~mm-generalize-arch_has_filter_pgprot
+++ a/arch/x86/Kconfig
@@ -337,9 +337,6 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
-config ARCH_HAS_FILTER_PGPROT
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
--- a/mm/Kconfig~mm-generalize-arch_has_filter_pgprot
+++ a/mm/Kconfig
@@ -762,6 +762,9 @@ config ARCH_HAS_CURRENT_STACK_POINTER
 	  register alias named "current_stack_pointer", this config can be
 	  selected.
 
+config ARCH_HAS_FILTER_PGPROT
+	bool
+
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


