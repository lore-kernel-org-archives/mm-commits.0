Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44ED9C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245463AbiESW0X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245500AbiESWZ5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650B3B35
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19CA2B828C6
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20BAC385AA;
        Thu, 19 May 2022 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999152;
        bh=7mIqSdHM1ZhdJWXzb2MbOUBfmpALLtI7Keb001MB90c=;
        h=Date:To:From:Subject:From;
        b=xz++D6kJ91H0/a4bSnfgGjtxUTT0AY1J9zwlV7/xw6WlG8KeSPnELY6RKttEKkCYf
         D/gB6b5J6YvLt8ML9Oi7WL+vog9S5MK9LmUo58xIkQyPlt8y8TRxgyeMnG8XkT/6V0
         0mzNJfp5D45NEHxSdlWmgScRFBNT6hsC7pjx5hY4=
Date:   Thu, 19 May 2022 15:25:52 -0700
To:     mm-commits@vger.kernel.org, sjenning@redhat.com,
        shakeelb@google.com, minchan@kernel.org, mhocko@suse.com,
        guro@fb.com, ddstreet@ieee.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-simplify-zswap-configuration.patch removed from -mm tree
Message-Id: <20220519222552.B20BAC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: Kconfig: simplify zswap configuration
has been removed from the -mm tree.  Its filename was
     mm-kconfig-simplify-zswap-configuration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: Kconfig: simplify zswap configuration

- CONFIG_ZRAM: Zram is a user-facing feature, whereas zsmalloc is
  not. Don't make the user chase down a technical dependency like
  that, just select it in automatically when zram is requested. The
  CONFIG_CRYPTO dependency is redundant due to more specific deps.

- CONFIG_ZPOOL: This is not a user-facing feature. Hide the symbol and
  have it selected in as needed.

- CONFIG_ZSWAP: Select CRYPTO instead of depend. Common pattern.

- Make the ZSWAP suboptions and their descriptions (compression,
  allocation backend) a bit more straight-forward for the user.

Link: https://lkml.kernel.org/r/20220510152847.230957-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |    3 +
 mm/Kconfig                 |   55 +++++++++++++++--------------------
 2 files changed, 27 insertions(+), 31 deletions(-)

--- a/drivers/block/zram/Kconfig~mm-kconfig-simplify-zswap-configuration
+++ a/drivers/block/zram/Kconfig
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 config ZRAM
 	tristate "Compressed RAM block device support"
-	depends on BLOCK && SYSFS && ZSMALLOC && CRYPTO
+	depends on BLOCK && SYSFS
 	depends on CRYPTO_LZO || CRYPTO_ZSTD || CRYPTO_LZ4 || CRYPTO_LZ4HC || CRYPTO_842
+	select ZSMALLOC
 	help
 	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
 	  Pages written to these disks are compressed and stored in memory
--- a/mm/Kconfig~mm-kconfig-simplify-zswap-configuration
+++ a/mm/Kconfig
@@ -9,6 +9,9 @@ menu "Memory Management options"
 config ARCH_NO_SWAP
 	bool
 
+config ZPOOL
+	bool
+
 menuconfig SWAP
 	bool "Support for paging of anonymous memory (swap)"
 	depends on MMU && BLOCK && !ARCH_NO_SWAP
@@ -21,8 +24,9 @@ menuconfig SWAP
 
 config ZSWAP
 	bool "Compressed cache for swap pages (EXPERIMENTAL)"
-	depends on SWAP && CRYPTO=y
+	depends on SWAP
 	select FRONTSWAP
+	select CRYPTO
 	select ZPOOL
 	help
 	  A lightweight compressed cache for swap pages.  It takes
@@ -38,8 +42,18 @@ config ZSWAP
 	  they have not be fully explored on the large set of potential
 	  configurations and workloads that exist.
 
+config ZSWAP_DEFAULT_ON
+	bool "Enable the compressed cache for swap pages by default"
+	depends on ZSWAP
+	help
+	  If selected, the compressed cache for swap pages will be enabled
+	  at boot, otherwise it will be disabled.
+
+	  The selection made here can be overridden by using the kernel
+	  command line 'zswap.enabled=' option.
+
 choice
-	prompt "Compressed cache for swap pages default compressor"
+	prompt "Default compressor"
 	depends on ZSWAP
 	default ZSWAP_COMPRESSOR_DEFAULT_LZO
 	help
@@ -105,7 +119,7 @@ config ZSWAP_COMPRESSOR_DEFAULT
        default ""
 
 choice
-	prompt "Compressed cache for swap pages default allocator"
+	prompt "Default allocator"
 	depends on ZSWAP
 	default ZSWAP_ZPOOL_DEFAULT_ZBUD
 	help
@@ -145,26 +159,9 @@ config ZSWAP_ZPOOL_DEFAULT
        default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
        default ""
 
-config ZSWAP_DEFAULT_ON
-	bool "Enable the compressed cache for swap pages by default"
-	depends on ZSWAP
-	help
-	  If selected, the compressed cache for swap pages will be enabled
-	  at boot, otherwise it will be disabled.
-
-	  The selection made here can be overridden by using the kernel
-	  command line 'zswap.enabled=' option.
-
-config ZPOOL
-	tristate "Common API for compressed memory storage"
-	depends on ZSWAP
-	help
-	  Compressed memory storage API.  This allows using either zbud or
-	  zsmalloc.
-
 config ZBUD
-	tristate "Low (Up to 2x) density storage for compressed pages"
-	depends on ZPOOL
+	tristate "2:1 compression allocator (zbud)"
+	depends on ZSWAP
 	help
 	  A special purpose allocator for storing compressed pages.
 	  It is designed to store up to two compressed pages per physical
@@ -173,8 +170,8 @@ config ZBUD
 	  density approach when reclaim will be used.
 
 config Z3FOLD
-	tristate "Up to 3x density storage for compressed pages"
-	depends on ZPOOL
+	tristate "3:1 compression allocator (z3fold)"
+	depends on ZSWAP
 	help
 	  A special purpose allocator for storing compressed pages.
 	  It is designed to store up to three compressed pages per physical
@@ -182,15 +179,13 @@ config Z3FOLD
 	  still there.
 
 config ZSMALLOC
-	tristate "Memory allocator for compressed pages"
+	tristate
+	prompt "N:1 compression allocator (zsmalloc)" if ZSWAP
 	depends on MMU
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
-	  compressed RAM pages.  zsmalloc uses virtual memory mapping
-	  in order to reduce fragmentation.  However, this results in a
-	  non-standard allocator interface where a handle, not a pointer, is
-	  returned by an alloc().  This handle must be mapped in order to
-	  access the allocated space.
+	  pages of various compression levels efficiently. It achieves
+	  the highest storage density with the least amount of fragmentation.
 
 config ZSMALLOC_STAT
 	bool "Export zsmalloc statistics"
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

