Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC559C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 18:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FBA6143F
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 18:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhEMSKZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 14:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231378AbhEMSKY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 14:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E86C46101B;
        Thu, 13 May 2021 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620929354;
        bh=SIYyDtSuVNtLF7vZloMSewNL623fclK3kQKc7Srexek=;
        h=Date:From:To:Subject:From;
        b=S5TPq7AxATCN3aDp1HcVntgoSQ7pNBMxsBZoafBblkLHo9dBMLMQEJT3jEEKT/eX7
         XJHFinUvI5gaf6OQxQj/1f46dAsu8L2E3lL9wLmntoXVclqN4eO2TRnxUgJLbsyJCm
         oHT2sMtF/FYCF9TnQlQbrAJaunc1EimpbRbMkJDM=
Date:   Thu, 13 May 2021 11:09:13 -0700
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, andi.kleen@intel.com,
        andriy.shevchenko@intel.com, feng.tang@intel.com,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        ying.huang@intel.com
Subject:  [merged]
 makefile-extend-32b-aligned-debug-option-to-64b-aligned.patch removed from
 -mm tree
Message-ID: <20210513180913.qwwLpXy9X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: extend 32B aligned debug option to 64B aligned
has been removed from the -mm tree.  Its filename was
     makefile-extend-32b-aligned-debug-option-to-64b-aligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: Makefile: extend 32B aligned debug option to 64B aligned

commit 09c60546f04f ("./Makefile: add debug option to enable function
aligned on 32 bytes") was introduced to help debugging strange kernel
performance changes caused by code alignment change.

Recently we found 2 similar cases [1][2] caused by code-alignment changes,
which can only be identified by forcing 64 bytes aligned for all
functions.

Originally, 32 bytes was used mainly for not wasting too much text space,
but this option is only for debug anyway where text space is not a big
concern.  So extend the alignment to 64 bytes to cover more similar cases.

[1].https://lore.kernel.org/lkml/20210427090013.GG32408@xsang-OptiPlex-9020/
[2].https://lore.kernel.org/lkml/20210420030837.GB31773@xsang-OptiPlex-9020/
Link: https://lkml.kernel.org/r/1620286499-40999-1-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile          |    4 ++--
 lib/Kconfig.debug |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/lib/Kconfig.debug~makefile-extend-32b-aligned-debug-option-to-64b-aligned
+++ a/lib/Kconfig.debug
@@ -411,8 +411,8 @@ config SECTION_MISMATCH_WARN_ONLY
 
 	  If unsure, say Y.
 
-config DEBUG_FORCE_FUNCTION_ALIGN_32B
-	bool "Force all function address 32B aligned" if EXPERT
+config DEBUG_FORCE_FUNCTION_ALIGN_64B
+	bool "Force all function address 64B aligned" if EXPERT
 	help
 	  There are cases that a commit from one domain changes the function
 	  address alignment of other domains, and cause magic performance
--- a/Makefile~makefile-extend-32b-aligned-debug-option-to-64b-aligned
+++ a/Makefile
@@ -1029,8 +1029,8 @@ KBUILD_CFLAGS	+= $(CC_FLAGS_CFI)
 export CC_FLAGS_CFI
 endif
 
-ifdef CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B
-KBUILD_CFLAGS += -falign-functions=32
+ifdef CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B
+KBUILD_CFLAGS += -falign-functions=64
 endif
 
 # arch Makefile may override CC so keep this after arch Makefile is included
_

Patches currently in -mm which might be from feng.tang@intel.com are


