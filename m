Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4894AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241228AbiESVBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbiESVBh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:01:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887485AEC5
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D09E7CE26FF
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E096DC385B8;
        Thu, 19 May 2022 21:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994093;
        bh=nrS7fPCeyp3zpDVTn6A+eJxHRkaeHkkfA/nKmQLvrpo=;
        h=Date:To:From:Subject:From;
        b=vp3aXA2giPH8Qb3Cc1szQygPs0e4rz5fd0r3hH0yHKmgN8VGU3ylqU4EEv6WtR2Vt
         bZznxXmINVbExfPOuR8vJRpg1cTveC4xJfNbX2JG/OtEktYpbpF51ym8g+/8Kx94Sq
         JbSC+DjH8zyTYL5jh9tVbrwxdQ7aKZ55PLhY87QQ=
Date:   Thu, 19 May 2022 14:01:32 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch removed from -mm tree
Message-Id: <20220519210132.E096DC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix
has been removed from the -mm tree.  Its filename was
     mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch

This patch was dropped because it was folded into mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch

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
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix.patch
zswap-memcg-accounting-fix-2.patch
revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

