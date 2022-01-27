Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356BFC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 02:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiA0CnX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 21:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiA0CnW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 21:43:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C245C06161C
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 18:43:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7146E61369
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 02:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BF7C340E7;
        Thu, 27 Jan 2022 02:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643251400;
        bh=3BKj6STjJHHI+MJ9Mc3iK5jrGWSkVMZxkpGtB5mwrVI=;
        h=Date:From:To:Subject:From;
        b=gE5GMAgiWQyH7IX94pom8yY3EdTy+CJM86GWhi8fxRxAEOEEfdCVP8qPRFk3I4op+
         XB3jKjeXhmEwSz8yQX050c5U4rEddtVu/PH0ark/JfTRJdlQ13imYw2ObPEMRL7MCx
         pu/kSYsAzt2EiUeX2zN40yQKRCcmaeSKNaWj6O6Y=
Date:   Wed, 26 Jan 2022 18:43:20 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, maciej.szmigiero@oracle.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com
Subject:  +
 mm-zswapc-allow-handling-just-same-value-filled-pages.patch added to -mm
 tree
Message-ID: <20220127024320.bM0SbKxbp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: allow handling just same-value filled pages
has been added to the -mm tree.  Its filename is
     mm-zswapc-allow-handling-just-same-value-filled-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswapc-allow-handling-just-same-value-filled-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswapc-allow-handling-just-same-value-filled-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-zswapc-allow-handling-just-same-value-filled-pages.patch

