Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6FDC7EE43
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjFGUAA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjFGT76 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 15:59:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2AF19AA
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 12:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB8D464159
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 19:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D531C4339B;
        Wed,  7 Jun 2023 19:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686167996;
        bh=mGR7FglPA0CDJYM3Dpkh8LWMusWs42XslXH3dzBhAx0=;
        h=Date:To:From:Subject:From;
        b=zsqlGBfhQqyHRVGwrbJ5dmZ0Ri1XPcXpdxfIVFb9DkeNSVoQxFJGh5mcqM4xJWJz7
         t7L4o+w5hwtJIEuVYEJr8x3geoZ1BkDlT1vMzQzABB7xvulUoqkfB0V/OEMD9+euYd
         ItH1r7fNpKIuD8kf4aDrhTJ4AyBnBavEv5BxGt00=
Date:   Wed, 07 Jun 2023 12:59:55 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        willy@infradead.org, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] radix-tree-move-declarations-to-header.patch removed from -mm tree
Message-Id: <20230607195956.3D531C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix-tree: move declarations to header
has been removed from the -mm tree.  Its filename was
     radix-tree-move-declarations-to-header.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: radix-tree: move declarations to header
Date: Tue, 16 May 2023 21:41:54 +0200

The xarray.c file contains the only call to radix_tree_node_rcu_free(),
and it comes with its own extern declaration for it.  This means the
function definition causes a missing-prototype warning:

lib/radix-tree.c:288:6: error: no previous prototype for 'radix_tree_node_rcu_free' [-Werror=missing-prototypes]

Instead, move the declaration for this function to a new header that can
be included by both, and do the same for the radix_tree_node_cachep
variable that has the same underlying problem but does not cause a warning
with gcc.

[zhangpeng.00@bytedance.com: fix building radix tree test suite]
  Link: https://lkml.kernel.org/r/20230521095450.21332-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20230516194212.548910-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                  |    2 ++
 lib/radix-tree.h                  |    8 ++++++++
 lib/xarray.c                      |    6 ++----
 tools/testing/radix-tree/Makefile |    5 +++--
 4 files changed, 15 insertions(+), 6 deletions(-)

--- a/lib/radix-tree.c~radix-tree-move-declarations-to-header
+++ a/lib/radix-tree.c
@@ -27,6 +27,8 @@
 #include <linux/string.h>
 #include <linux/xarray.h>
 
+#include "radix-tree.h"
+
 /*
  * Radix tree node cache.
  */
--- /dev/null
+++ a/lib/radix-tree.h
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* radix-tree helpers that are only shared with xarray */
+
+struct kmem_cache;
+struct rcu_head;
+
+extern struct kmem_cache *radix_tree_node_cachep;
+extern void radix_tree_node_rcu_free(struct rcu_head *head);
--- a/lib/xarray.c~radix-tree-move-declarations-to-header
+++ a/lib/xarray.c
@@ -12,6 +12,8 @@
 #include <linux/slab.h>
 #include <linux/xarray.h>
 
+#include "radix-tree.h"
+
 /*
  * Coding conventions in this file:
  *
@@ -247,10 +249,6 @@ void *xas_load(struct xa_state *xas)
 }
 EXPORT_SYMBOL_GPL(xas_load);
 
-/* Move the radix tree node cache here */
-extern struct kmem_cache *radix_tree_node_cachep;
-extern void radix_tree_node_rcu_free(struct rcu_head *head);
-
 #define XA_RCU_FREE	((struct xarray *)1)
 
 static void xa_node_free(struct xa_node *node)
--- a/tools/testing/radix-tree/Makefile~radix-tree-move-declarations-to-header
+++ a/tools/testing/radix-tree/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I. -I../../include -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address \
-	  -fsanitize=undefined
+CFLAGS += -I. -I../../include -I../../../lib -g -Og -Wall \
+	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS+= -lpthread -lurcu
 TARGETS = main idr-test multiorder xarray maple
@@ -49,6 +49,7 @@ $(OFILES): Makefile *.h */*.h generated/
 	../../../include/linux/xarray.h \
 	../../../include/linux/maple_tree.h \
 	../../../include/linux/radix-tree.h \
+	../../../lib/radix-tree.h \
 	../../../include/linux/idr.h
 
 radix-tree.c: ../../../lib/radix-tree.c
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch
mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch
mm-page_poison-always-declare-__kernel_map_pages-function.patch
mm-sparse-mark-populate_section_memmap-static.patch
lib-devmem_is_allowed-include-linux-ioh.patch
locking-add-lockevent_read-prototype.patch
panic-hide-unused-global-functions.patch
panic-make-function-declarations-visible.patch
kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch
kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

