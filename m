Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930FEC433DB
	for <mm-commits@archiver.kernel.org>; Sat, 20 Feb 2021 00:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64E8C64E24
	for <mm-commits@archiver.kernel.org>; Sat, 20 Feb 2021 00:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhBTAcl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Feb 2021 19:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBTAcl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Feb 2021 19:32:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C09DC061574
        for <mm-commits@vger.kernel.org>; Fri, 19 Feb 2021 16:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2dd8vEBcHUO2D+iwnt3LAFJgV8oWHDNyaDshbGUHIik=; b=XeT0PRhOHAg2y3mtE7ZZUWEED0
        a3NTx+A7slIXtvzFqZqE+dIGTQAJfs8opSCVH2remQpeZcCMg4t5ENQjQgYKOTcZLYDGQmieNtYmn
        o373U09QRNdmVhKD77fsHAxqDh/gjImTXvC9Vus+4tgihS/4BOXiKd9L8odNlWekvyapeuPko8aUv
        GaE5X6FuYqG+ktsHdULoUyfDEG1dvBTe0QLuexArnJhaeDMfFUfvLiVO7liIjRZxd/AFNjR9LWhHN
        vo/67oEgS2l6bhIVmpkumhxz2kktMpyeOTTUdL3RKBY+tgy7eRFE7q8/RQv0l3yE54F6zRdV7YQoR
        +AiHRSYg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lDGAc-003Rh1-0F; Sat, 20 Feb 2021 00:31:17 +0000
Date:   Sat, 20 Feb 2021 00:30:49 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, nathan@kernel.org
Subject: Re: [to-be-updated] mm-gfp-add-kernel-doc-for-gfp_t.patch removed
 from -mm tree
Message-ID: <20210220003049.GZ2858050@casper.infradead.org>
References: <20210219210532.tnvl5%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219210532.tnvl5%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Feb 19, 2021 at 01:05:32PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/gfp: add kernel-doc for gfp_t
> has been removed from the -mm tree.  Its filename was
>      mm-gfp-add-kernel-doc-for-gfp_t.patch
> 
> This patch was dropped because an updated version will be merged


From 90e7f279d1003df342f80afd6a7b95ff6d644ff1 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 19 Feb 2021 13:35:17 +1100
Subject: [PATCH] mm/gfp: add kernel-doc for gfp_t

The generated html will link to the definition of the gfp_t automatically
once we define it.  Move the one-paragraph overview of GFP flags from the
documentation directory into gfp.h and pull gfp.h into the documentation.

Link: https://lkml.kernel.org/r/20210215204909.3824509-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
---
 Documentation/core-api/mm-api.rst |  7 ++-----
 include/linux/gfp.h               | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index 1baa106cee0b..874ae1250258 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -19,11 +19,8 @@ User Space Memory Access
 Memory Allocation Controls
 ==========================
 
-Functions which need to allocate memory often use GFP flags to express
-how that memory should be allocated. The GFP acronym stands for "get
-free pages", the underlying memory allocation function. Not every GFP
-flag is allowed to every function which may allocate memory. Most
-users will want to use a plain ``GFP_KERNEL``.
+.. kernel-doc:: include/linux/gfp.h
+   :internal:
 
 .. kernel-doc:: include/linux/gfp.h
    :doc: Page mobility and placement hints
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 08007b9b7986..0a88f84b08f4 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -8,6 +8,20 @@
 #include <linux/linkage.h>
 #include <linux/topology.h>
 
+/* The typedef is in types.h but we want the documentation here */
+#if 0
+/**
+ * typedef gfp_t - Memory allocation flags.
+ *
+ * GFP flags are commonly used throughout Linux to indicate how memory
+ * should be allocated.  The GFP acronym stands for get_free_pages(),
+ * the underlying memory allocation function.  Not every GFP flag is
+ * supported by every function which may allocate memory.  Most users
+ * will want to use a plain ``GFP_KERNEL``.
+ */
+typedef unsigned int __bitwise gfp_t;
+#endif
+
 struct vm_area_struct;
 
 /*
-- 
2.29.2

