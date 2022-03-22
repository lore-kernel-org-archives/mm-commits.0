Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A7DC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbiCVVts (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiCVVtO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AFC6005C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A19C76100A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CCCC340EE;
        Tue, 22 Mar 2022 21:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985664;
        bh=WCsIdgvm4p3k+5Cv/PlRL2Jz2UslW1DVV3Oh54qbpSc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Yg0t/pwjbmCAlOjlL9bpiOQwUD8OX99GKGBEEK6Pa9+GjWrv/2Mv60/IPlQtYRD/m
         TzXlOW2wO6+KOima4Ibt8TUVeXISFou4nyMbQSVT9kpDsJnCZ2AhWOI4KhRxD1FOFk
         50uu28z6c45CsI8rHwu8pnOISXdLhZgj+hUlioFw=
Date:   Tue, 22 Mar 2022 14:47:43 -0700
To:     vitaly.wool@konsulko.com, sjenning@redhat.com, ddstreet@ieee.org,
        maciej.szmigiero@oracle.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 181/227] mm/zswap.c: allow handling just same-value filled pages
Message-Id: <20220322214743.F3CCCC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
