Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6FFEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 18:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjGBSuO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 14:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjGBSuN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 14:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60543C3
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 11:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F7F60C77
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 18:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EBDC433C7;
        Sun,  2 Jul 2023 18:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688323811;
        bh=QbIymBbhRrCVuMQINnyhmGPCotr3c0BQvzGqKGRn5Zg=;
        h=Date:To:From:Subject:From;
        b=fhqv2HG8PYomyBGNKef9AesdM2/bBFAZGs8dZEV49Tw9ru6qJ1wdoAsxzpuepjpGp
         /kUD07/iiI2ecliV2qIwd8EvLsUZ6i0IivNLk6AkcrfTkoxsYd/z9wfBje1cql+uvI
         t76Haz8Hz1LBkAyAQoulejSCifTlSeSYsYfrjLBI=
Date:   Sun, 02 Jul 2023 11:50:10 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        falcon@tinylab.org, djwong@kernel.org, brauner@kernel.org,
        linux@weissschuh.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-memfd_create-into-a-selectable-config-option.patch added to mm-unstable branch
Message-Id: <20230702185011.32EBDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make MEMFD_CREATE into a selectable config option
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-memfd_create-into-a-selectable-config-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-memfd_create-into-a-selectable-config-option.patch

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
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: mm: make MEMFD_CREATE into a selectable config option
Date: Fri, 30 Jun 2023 11:08:53 +0200

The memfd_create() syscall, enabled by CONFIG_MEMFD_CREATE, is useful on
its own even when not required by CONFIG_TMPFS or CONFIG_HUGETLBFS.

Split it into its own proper bool option that can be enabled by users.

Move that option into mm/ where the code itself also lies.  Also add
"select" statements to CONFIG_TMPFS and CONFIG_HUGETLBFS so they
automatically enable CONFIG_MEMFD_CREATE as before.

Link: https://lkml.kernel.org/r/20230630-config-memfd-v1-1-9acc3ae38b5a@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Tested-by: Zhangjin Wu <falcon@tinylab.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    5 ++---
 mm/Kconfig |    3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/Kconfig~mm-make-memfd_create-into-a-selectable-config-option
+++ a/fs/Kconfig
@@ -169,6 +169,7 @@ source "fs/sysfs/Kconfig"
 config TMPFS
 	bool "Tmpfs virtual memory file system support (former shm fs)"
 	depends on SHMEM
+	select MEMFD_CREATE
 	help
 	  Tmpfs is a file system which keeps all files in virtual memory.
 
@@ -240,6 +241,7 @@ config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	depends on (SYSFS || SYSCTL)
+	select MEMFD_CREATE
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
 	  ramfs. For architectures that support it, say Y here and read
@@ -264,9 +266,6 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEF
 	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
 	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
 
-config MEMFD_CREATE
-	def_bool TMPFS || HUGETLBFS
-
 config ARCH_HAS_GIGANTIC_PAGE
 	bool
 
--- a/mm/Kconfig~mm-make-memfd_create-into-a-selectable-config-option
+++ a/mm/Kconfig
@@ -1144,6 +1144,9 @@ config KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
 config IO_MAPPING
 	bool
 
+config MEMFD_CREATE
+	bool "Enable memfd_create() system call" if EXPERT
+
 config SECRETMEM
 	default y
 	bool "Enable memfd_secret() system call" if EXPERT
_

Patches currently in -mm which might be from linux@weissschuh.net are

mm-make-memfd_create-into-a-selectable-config-option.patch

