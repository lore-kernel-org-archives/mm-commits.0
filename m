Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA442C77B7A
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 21:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjEPVAn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 17:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjEPVAm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 17:00:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD0B59FB
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 14:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A548E62F1C
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 21:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8AFC433D2;
        Tue, 16 May 2023 21:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684270840;
        bh=Ss1+cvUATQvRT1LWGOLvrXTQC+QA2Mp6TM5ydgiq0mQ=;
        h=Date:To:From:Subject:From;
        b=JgyRL56cjv3FVVvkgTcWEpEuFFrp1d4dlgVwBY9r1P45FBrAI4DSTEeGih3vrREnb
         ZvK//qY9amvHCpgtPQOwx5MUTN2m8KotZXi0afqPeL8RBAk6+SspkgFajdhyOSUWmD
         wKng4iUBQX8i3SRnWt87ZsUCVTFJxK2OzRC/RDWM=
Date:   Tue, 16 May 2023 14:00:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-move-declarations-to-header.patch added to mm-hotfixes-unstable branch
Message-Id: <20230516210040.0C8AFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: move declarations to header
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     radix-tree-move-declarations-to-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-move-declarations-to-header.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Link: https://lkml.kernel.org/r/20230516194212.548910-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 ++
 lib/radix-tree.h |    8 ++++++++
 lib/xarray.c     |    6 ++----
 3 files changed, 12 insertions(+), 4 deletions(-)

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
_

Patches currently in -mm which might be from arnd@arndb.de are

radix-tree-move-declarations-to-header.patch
kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch

