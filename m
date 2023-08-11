Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9F9C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbjHKW6h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbjHKW6f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585511AE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1271671E7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FE5C433C8;
        Fri, 11 Aug 2023 22:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794714;
        bh=MYpASvcdlf9fgnHa+gvLbk0ADaX1o07+0IoM9tjuyiU=;
        h=Date:To:From:Subject:From;
        b=d4GAyKQvQ5yCEN9DvWKtvCLUCI6VMx6RQhDukMO0mGgkDwa/U22QkVgDvnBgDnP6M
         18Hyg2WZcxnhH4tet7mX3/blFFPn6Mqn/XldUBXZMrxm5Mx1WPQsu/vX9ZJ4d08Ie1
         T1wq8h7uZxXqEIFRku85y0IyCMLmp4pNYoNlGaLY=
Date:   Fri, 11 Aug 2023 15:58:33 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        falcon@tinylab.org, djwong@kernel.org, brauner@kernel.org,
        linux@weissschuh.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-memfd_create-into-a-selectable-config-option.patch removed from -mm tree
Message-Id: <20230811225834.42FE5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make MEMFD_CREATE into a selectable config option
has been removed from the -mm tree.  Its filename was
     mm-make-memfd_create-into-a-selectable-config-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


