Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CC7C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357485AbiCYBhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357489AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D630533895
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8382EB81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24818C340ED;
        Fri, 25 Mar 2022 01:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172030;
        bh=NPjDtBIk4Zgfa/UacuOGin5gbicXQdOaOaQwtWejI18=;
        h=Date:To:From:Subject:From;
        b=ITTZbai3f/OJYixvo7XwnJNXtwrdgr3dLFSz7HXUssTGjKR9+FPlse9dD4dOWPObR
         xTrwzvhgLl3Er0PfadRVzs6sA94GNyhqqaApFH+L3S5STKvl3RC9Gx/e36hcymXk/8
         iym609tjortLrRYLfjXfIkypH/bv80O1JDBfU6gQ=
Date:   Thu, 24 Mar 2022 18:33:49 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, guoren@kernel.org,
        feng.tang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-kconfigdebug-add-arch-dependency-for-function_align-option.patch removed from -mm tree
Message-Id: <20220325013350.24818C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-add-arch-dependency-for-function_align-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option

0Day robots reported there is compiling issue for 'csky' ARCH
when CONFIG_DEBUG_FORCE_DATA_SECTION_ALIGNED is enabled [1]:

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}:2277: Error: pcrel offset for branch to .LS000B too far (0x3c)


Which was discussed in [2].  And as there is no solution for csky yet, add
some dependency for this config to limit it to several ARCHs which have no
compiling issue so far.

[1]. https://lore.kernel.org/lkml/202202271612.W32UJAj2-lkp@intel.com/
[2]. https://www.spinics.net/lists/linux-kbuild/msg30298.html

Link: https://lkml.kernel.org/r/20220304021100.GN4548@shbuild999.sh.intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-add-arch-dependency-for-function_align-option
+++ a/lib/Kconfig.debug
@@ -439,7 +439,8 @@ config SECTION_MISMATCH_WARN_ONLY
 	  If unsure, say Y.
 
 config DEBUG_FORCE_FUNCTION_ALIGN_64B
-	bool "Force all function address 64B aligned" if EXPERT
+	bool "Force all function address 64B aligned"
+	depends on EXPERT && (X86_64 || ARM64 || PPC32 || PPC64 || ARC)
 	help
 	  There are cases that a commit from one domain changes the function
 	  address alignment of other domains, and cause magic performance
_

Patches currently in -mm which might be from feng.tang@intel.com are


