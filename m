Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75A4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 18:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357795AbiELSur (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 14:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345813AbiELSuq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 14:50:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B41F2658
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 11:50:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7984B6191C
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 18:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF4EC385B8;
        Thu, 12 May 2022 18:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652381440;
        bh=kqG9xQ5TiIGBXz0r8ej/jw+aO1u+qFEYR8Lh2bhjd+U=;
        h=Date:To:From:Subject:From;
        b=BOJ08N0Y5eyTNPaRECYWSAyPNOupXdyDnn10EQEAHOKxOKxFid+gr/OGgUCYHYEkq
         FhudHYBrcK13Q79G1K8Q4JQ3C/SfwVsACEuLM02lvQgmKtyMse8mHCnLNf6UzV87gA
         c7Fnhwy6BngoXcqtJcDps8DVoXvZl1uKVUzHP4Jk=
Date:   Thu, 12 May 2022 11:50:40 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch added to mm-unstable branch
Message-Id: <20220512185040.BAF4EC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch

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
documentation-filesystems-proc-update-meminfo-section-fix.patch
documentation-filesystems-proc-update-meminfo-section-fix-2.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix.patch

