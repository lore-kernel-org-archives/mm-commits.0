Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E73C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 19:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241347AbiEKTEW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 15:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236747AbiEKTEV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 15:04:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9303F61604
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 12:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC97610E7
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 19:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814C9C340EE;
        Wed, 11 May 2022 19:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652295859;
        bh=i4QgfR6ebTvW5tmlB6dkFQarjK5okOtOBaBZQ9FdB0s=;
        h=Date:To:From:Subject:From;
        b=PuKyZoZGU84S1Byc7rHbKjKpCdv2pZHQIlGEEh1VALGmNs0UvDm7szASPvCjfWTnf
         E9Nom15py4IAJr6JuOh2wiqHnpy8Ah1lvKbTv+DAYmHgZEOvcviKLEKZNpkx9/Xj1V
         D93btzvvlpdZEo7Ix6gX6CfH2xswNl9sauVLKW34=
Date:   Wed, 11 May 2022 12:04:18 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch added to mm-unstable branch
Message-Id: <20220511190419.814C9C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix

fix kbuild warnings

Link: https://lkml.kernel.org/r/YnvkSVivfnT57Vwh@cmpxchg.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/Kconfig~mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix
+++ a/mm/Kconfig
@@ -692,6 +692,12 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 	  See Documentation/admin-guide/mm/nommu-mmap.rst for more information.
 
+config ARCH_WANT_GENERAL_HUGETLB
+	bool
+
+config ARCH_WANTS_THP_SWAP
+	def_bool n
+
 menuconfig TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
 	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE && !PREEMPT_RT
@@ -733,12 +739,6 @@ choice
 	  benefit.
 endchoice
 
-config ARCH_WANT_GENERAL_HUGETLB
-	bool
-
-config ARCH_WANTS_THP_SWAP
-	def_bool n
-
 config THP_SWAP
 	def_bool y
 	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

documentation-filesystems-proc-update-meminfo-section.patch
documentation-filesystems-proc-update-meminfo-section-fix.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch

