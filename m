Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664F3C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 391AE20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266242;
	bh=KZv86SGROQuAxONMdugifOQP9NC6KglC3pUBv1dH0vU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mHo7VUUo5QgaDFenq4F8DzgPYe9u0EBTvY9gGoKes9MQ2hFUhW6GnoMxO3w6w7n+o
	 SXvWCjSY71OWdRafIuV8Nw2e0KRc/tY8e8Xaq58mY8Pttv3FJb3VWkDIB55JNMFXmN
	 eM9CemNwzcbbCUYvv25p8ArGdcdUjVRwOMa0U6VY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHLVEC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHLVEB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72CA120774;
        Wed, 12 Aug 2020 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266241;
        bh=KZv86SGROQuAxONMdugifOQP9NC6KglC3pUBv1dH0vU=;
        h=Date:From:To:Subject:From;
        b=gHBWF4ip3G5fTvdNlEqKsXouGErevHSllo4pj0hkSJlrpe0vmn0rWLWryAF7Q+Sf0
         m9g94ItApKQRyFEYtpuMDOrOm2TDiF6eFzhymvrggSN4t6qQkw+jquCqjATvTMlfPg
         VaEpc7fcOXkGAHLG+B+KGxvgQlnxWMMXc6CBAB/E=
Date:   Wed, 12 Aug 2020 14:04:01 -0700
From:   akpm@linux-foundation.org
To:     kent.overstreet@gmail.com, luc.vanoostenryck@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 lib-generic-radix-treec-remove-unneeded-__rcu.patch removed from -mm tree
Message-ID: <20200812210401.qVHNd9_YX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/generic-radix-tree.c: remove unneeded __rcu
has been removed from the -mm tree.  Its filename was
     lib-generic-radix-treec-remove-unneeded-__rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: lib/generic-radix-tree.c: remove unneeded __rcu

struct __genradix is defined as having its member 'root'
annotated as __rcu. But in the corresponding API RCU is not used.
Sparse reports this type mismatch as:
	lib/generic-radix-tree.c:56:35: warning: incorrect type in initializer (different address spaces)
	lib/generic-radix-tree.c:56:35:    expected struct genradix_root *r
	lib/generic-radix-tree.c:56:35:    got struct genradix_root [noderef] <asn:4> *__val
with 6 other ones.

So, correct root's type by removing this unneeded __rcu.

Link: http://lkml.kernel.org/r/20200621161745.55396-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/generic-radix-tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/generic-radix-tree.h~lib-generic-radix-treec-remove-unneeded-__rcu
+++ a/include/linux/generic-radix-tree.h
@@ -44,7 +44,7 @@
 struct genradix_root;
 
 struct __genradix {
-	struct genradix_root __rcu	*root;
+	struct genradix_root		*root;
 };
 
 /*
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are


