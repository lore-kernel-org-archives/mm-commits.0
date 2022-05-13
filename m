Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681FBC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383813AbiEMTVt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383860AbiEMTVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F01266D
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 017F2B8310B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B79C34113;
        Fri, 13 May 2022 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469675;
        bh=r1X0CQlSA6bzFu+ThZlzAiUJP4n+5d4GMN2DxoqWkkk=;
        h=Date:To:From:Subject:From;
        b=L7JtJ6z6ipTzIFzj1G8lY8zlNHY+gnJtJf8f/JgPK5Z8SL4AG6uOIFO+CzP57XOMs
         9Yz90w2RImK0KD+KozmK0a559VsxABIv8R0+QaVTajsX2z9d9TO5kVSuuaG+zzTcA9
         702vOU8/Agc5+WXyIB0xaquuIRlc+3AGdM41r25s=
Date:   Fri, 13 May 2022 12:21:15 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-uffd-move-userfaultfd-configs-into-mm.patch removed from -mm tree
Message-Id: <20220513192115.A0B79C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: move USERFAULTFD configs into mm/
has been removed from the -mm tree.  Its filename was
     mm-uffd-move-userfaultfd-configs-into-mm.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: move USERFAULTFD configs into mm/

We used to have USERFAULTFD configs stored in init/.  It makes sense as a
start because that's the default place for storing syscall related
configs.

However userfaultfd evolved a bit in the past few years and some more
config options were added.  They're no longer related to syscalls and
start to be not suitable to be kept in the init/ directory anymore,
because they're pure mm concepts.

But it's not ideal either to keep the userfaultfd configs separate from
each other.  Hence this patch moves the userfaultfd configs under init/ to
be under mm/ so that we'll start to group all userfaultfd configs
together.

We do have quite a few examples of syscall related configs that are not
put under init/Kconfig: FTRACE_SYSCALLS, SWAP, FILE_LOCKING,
MEMFD_CREATE..  They all reside in the dir where they're more suitable for
the concept.  So it seems there's no restriction to keep the role of
having syscall related CONFIG_* under init/ only.

Link: https://lkml.kernel.org/r/20220420144823.35277-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   17 -----------------
 mm/Kconfig   |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/init/Kconfig~mm-uffd-move-userfaultfd-configs-into-mm
+++ a/init/Kconfig
@@ -1667,16 +1667,6 @@ config ADVISE_SYSCALLS
 	  applications use these syscalls, you can disable this option to save
 	  space.
 
-config HAVE_ARCH_USERFAULTFD_WP
-	bool
-	help
-	  Arch has userfaultfd write protection support
-
-config HAVE_ARCH_USERFAULTFD_MINOR
-	bool
-	help
-	  Arch has userfaultfd minor fault support
-
 config MEMBARRIER
 	bool "Enable membarrier() system call" if EXPERT
 	default y
@@ -1741,13 +1731,6 @@ config KALLSYMS_BASE_RELATIVE
 
 # syscall, maps, verifier
 
-config USERFAULTFD
-	bool "Enable userfaultfd() system call"
-	depends on MMU
-	help
-	  Enable the userfaultfd() system call that allows to intercept and
-	  handle page faults in userland.
-
 config ARCH_HAS_MEMBARRIER_CALLBACKS
 	bool
 
--- a/mm/Kconfig~mm-uffd-move-userfaultfd-configs-into-mm
+++ a/mm/Kconfig
@@ -909,6 +909,23 @@ config ANON_VMA_NAME
 	  area from being merged with adjacent virtual memory areas due to the
 	  difference in their name.
 
+config USERFAULTFD
+	bool "Enable userfaultfd() system call"
+	depends on MMU
+	help
+	  Enable the userfaultfd() system call that allows to intercept and
+	  handle page faults in userland.
+
+config HAVE_ARCH_USERFAULTFD_WP
+	bool
+	help
+	  Arch has userfaultfd write protection support
+
+config HAVE_ARCH_USERFAULTFD_MINOR
+	bool
+	help
+	  Arch has userfaultfd minor fault support
+
 config PTE_MARKER
 	bool
 
_

Patches currently in -mm which might be from peterx@redhat.com are


