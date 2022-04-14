Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F88C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 02:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiDNCem (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 22:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239477AbiDNCek (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 22:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DFA4EF5B
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 19:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECCB061BB9
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 02:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C14C385A6;
        Thu, 14 Apr 2022 02:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649903534;
        bh=WqOOMrO568mxcWFzmeqwJ7K2hUc23pCDbgijBF5Ktbk=;
        h=Date:To:From:Subject:From;
        b=EETATr7i/cHLc7rNMGbXjehXaxpfHVVyrtF2pBjU/MGFj+L/+mYQPtI9xjgCBjRjj
         lrDrghlAko1YsByqR+L99+C7lMsHfpjvr6I9BCwEkmTi9hAiW4MqP0Om//DuOkFcSz
         maUsNTqoxbrP//maRxlhkuwx1rVMWR532OpxiIgI=
Date:   Wed, 13 Apr 2022 19:32:13 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-add-config_arch_has_nonleaf_pmd_young-fix.patch added to -mm tree
Message-Id: <20220414023214.40C14C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-x86-add-config_arch_has_nonleaf_pmd_young-fix
has been added to the -mm tree.  Its filename is
     mm-x86-add-config_arch_has_nonleaf_pmd_young-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-x86-add-config_arch_has_nonleaf_pmd_young-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-add-config_arch_has_nonleaf_pmd_young-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm-x86-add-config_arch_has_nonleaf_pmd_young-fix

fix Kconfig warnings

Link: https://lkml.kernel.org/r/YlZrmTd0JGO7/g8a@google.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/Kconfig~mm-x86-add-config_arch_has_nonleaf_pmd_young-fix
+++ a/arch/Kconfig
@@ -1380,7 +1380,6 @@ config HAVE_ARCH_NODE_DEV_GROUP
 
 config ARCH_HAS_NONLEAF_PMD_YOUNG
 	bool
-	depends on PGTABLE_LEVELS > 2
 	help
 	  Architectures that select this option are capable of setting the
 	  accessed bit in non-leaf PMD entries when using them as part of linear
--- a/arch/x86/Kconfig~mm-x86-add-config_arch_has_nonleaf_pmd_young-fix
+++ a/arch/x86/Kconfig
@@ -85,7 +85,7 @@ config X86
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
-	select ARCH_HAS_NONLEAF_PMD_YOUNG
+	select ARCH_HAS_NONLEAF_PMD_YOUNG	if PGTABLE_LEVELS > 2
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
 	select ARCH_HAS_COPY_MC			if X86_64
 	select ARCH_HAS_SET_MEMORY
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young-fix.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

