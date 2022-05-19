Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3D0C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244745AbiESVBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbiESVBh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2ABD5AEC8
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A161B8280A
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD33C385AA;
        Thu, 19 May 2022 21:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994094;
        bh=K8nRegUivIip4WPx/8NbURHN6B34YNHVgjHY/RJXAVg=;
        h=Date:To:From:Subject:From;
        b=HXs0dzQNfaPa7YCN+WTDd/LjvBpJ+A9wa45gQxEt3bFfBO4oQ7EofbHeu4axpxGtV
         NLGdXZG0vCyW6lUrX9aH5CnZAdmilYJ0V0njXXTAM7o44DdbuYWYW3z8ayKGjSLF4c
         nF7s7AgU+r+mrEyn5IGdqrRLyA5OaODQ6JjWno6I=
Date:   Thu, 19 May 2022 14:01:33 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch removed from -mm tree
Message-Id: <20220519210134.1FD33C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch

This patch was dropped because it was folded into mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix

WARNING: unmet direct dependencies detected for ARCH_ENABLE_MEMORY_HOTREMOVE
  Depends on [n]: MEMORY_HOTPLUG [=n]
  Selected by [y]:
  - PPC [=y]

This is a symbol for the architecture to declare a feature.  It mustn't be
conditional on user selection.  Move it out of 'if MEMORY_HOTPLUG'.

Link: https://lkml.kernel.org/r/Ynz8NusTdEGcCnJN@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/Kconfig~mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix
+++ a/mm/Kconfig
@@ -436,6 +436,9 @@ config HAVE_BOOTMEM_INFO_NODE
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	bool
 
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	bool
+
 # eventually, we can have this option just 'select SPARSEMEM'
 menuconfig MEMORY_HOTPLUG
 	bool "Memory hotplug"
@@ -462,9 +465,6 @@ config MEMORY_HOTPLUG_DEFAULT_ONLINE
 	  Say N here if you want the default policy to keep all hot-plugged
 	  memory blocks in 'offline' state.
 
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	bool
-
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

documentation-filesystems-proc-update-meminfo-section.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix.patch
zswap-memcg-accounting-fix-2.patch
revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

