Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5E5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357568AbiCYBg5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357473AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E14C12EC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB43360909
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3E6C340ED;
        Fri, 25 Mar 2022 01:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171972;
        bh=6KRiwKBdqXzgD65rt0nw4rchcfPRfH73/fSiaQW5Vj8=;
        h=Date:To:From:Subject:From;
        b=0jyCb85rTGC/k51AXo90k0O+zboairnggVthCDpVQYPBH5DYQykdI0IKMMvqQAwrl
         JiKnsAULuUm+8UETji4cibOHtC0MaVqcN6buHszmUewgnRBFBq7gpy0RoPyjQrkSdl
         moiQkDfO1aAjQVlG1D88ReS57DRSBbedG/hYA4Q0=
Date:   Thu, 24 Mar 2022 18:32:51 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, ddstreet@ieee.org,
        maciej.szmigiero@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-zswapc-allow-handling-just-same-value-filled-pages.patch removed from -mm tree
Message-Id: <20220325013252.2F3E6C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: allow handling just same-value filled pages
has been removed from the -mm tree.  Its filename was
     mm-zswapc-allow-handling-just-same-value-filled-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: mm/zswap.c: allow handling just same-value filled pages

Zswap has an ability to efficiently store same-value filled pages, which
can be turned on and off using the "same_filled_pages_enabled" parameter.

However, there is currently no way to enable just this (lightweight)
functionality, while not making use of the whole compressed page storage
machinery.

Add a "non_same_filled_pages_enabled" parameter which allows disabling
handling of pages that aren't same-value filled.  This way zswap can be
run in such lightweight same-value filled pages only mode.

Link: https://lkml.kernel.org/r/7dbafa963e8bab43608189abbe2067f4b9287831.1641247624.git.maciej.szmigiero@oracle.com
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/zswap.rst |   22 +++++++++++++++++++---
 mm/zswap.c                             |   15 ++++++++++++++-
 2 files changed, 33 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/zswap.rst~mm-zswapc-allow-handling-just-same-value-filled-pages
+++ a/Documentation/admin-guide/mm/zswap.rst
@@ -130,9 +130,25 @@ attribute, e.g.::
 	echo 1 > /sys/module/zswap/parameters/same_filled_pages_enabled
 
 When zswap same-filled page identification is disabled at runtime, it will stop
-checking for the same-value filled pages during store operation. However, the
-existing pages which are marked as same-value filled pages remain stored
-unchanged in zswap until they are either loaded or invalidated.
+checking for the same-value filled pages during store operation.
+In other words, every page will be then considered non-same-value filled.
+However, the existing pages which are marked as same-value filled pages remain
+stored unchanged in zswap until they are either loaded or invalidated.
+
+In some circumstances it might be advantageous to make use of just the zswap
+ability to efficiently store same-filled pages without enabling the whole
+compressed page storage.
+In this case the handling of non-same-value pages by zswap (enabled by default)
+can be disabled by setting the ``non_same_filled_pages_enabled`` attribute
+to 0, e.g. ``zswap.non_same_filled_pages_enabled=0``.
+It can also be enabled and disabled at runtime using the sysfs
+``non_same_filled_pages_enabled`` attribute, e.g.::
+
+	echo 1 > /sys/module/zswap/parameters/non_same_filled_pages_enabled
+
+Disabling both ``zswap.same_filled_pages_enabled`` and
+``zswap.non_same_filled_pages_enabled`` effectively disables accepting any new
+pages by zswap.
 
 To prevent zswap from shrinking pool when zswap is full and there's a high
 pressure on swap (this will result in flipping pages in and out zswap pool
--- a/mm/zswap.c~mm-zswapc-allow-handling-just-same-value-filled-pages
+++ a/mm/zswap.c
@@ -120,11 +120,19 @@ static unsigned int zswap_accept_thr_per
 module_param_named(accept_threshold_percent, zswap_accept_thr_percent,
 		   uint, 0644);
 
-/* Enable/disable handling same-value filled pages (enabled by default) */
+/*
+ * Enable/disable handling same-value filled pages (enabled by default).
+ * If disabled every page is considered non-same-value filled.
+ */
 static bool zswap_same_filled_pages_enabled = true;
 module_param_named(same_filled_pages_enabled, zswap_same_filled_pages_enabled,
 		   bool, 0644);
 
+/* Enable/disable handling non-same-value filled pages (enabled by default) */
+static bool zswap_non_same_filled_pages_enabled = true;
+module_param_named(non_same_filled_pages_enabled, zswap_non_same_filled_pages_enabled,
+		   bool, 0644);
+
 /*********************************
 * data structures
 **********************************/
@@ -1147,6 +1155,11 @@ static int zswap_frontswap_store(unsigne
 		kunmap_atomic(src);
 	}
 
+	if (!zswap_non_same_filled_pages_enabled) {
+		ret = -EINVAL;
+		goto freepage;
+	}
+
 	/* if entry is successfully added, it keeps the reference */
 	entry->pool = zswap_pool_current_get();
 	if (!entry->pool) {
_

Patches currently in -mm which might be from maciej.szmigiero@oracle.com are


