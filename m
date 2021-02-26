Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC02C43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE7664EE2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhBZBXZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhBZBWt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE9FA64F13;
        Fri, 26 Feb 2021 01:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302522;
        bh=7EgLt7ixMD+x2IkqQ0JqG4wTI0BkIZFyBMLb/rcE+UE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kbXPaaepvMhcl+IZtrRXYzpQRsqX733/dW4o+ur9KgP8tHrNLMnEEHSr1yeciNveU
         HQvMXQyWeN9vmnunrJcpy/dKcxY7Yxfw9Wn79mDAhyTbG0zFhtdP7/4xjVGjuU0WSa
         vDepH67DY77MTiq66n3fApRfJGg5wfkA7HUCLBjo=
Date:   Thu, 25 Feb 2021 17:22:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, kuba@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 105/118] checkpatch: add kmalloc_array_node to
 unnecessary OOM message check
Message-ID: <20210226012201.gwNkg1WcP%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: add kmalloc_array_node to unnecessary OOM message check

commit 5799b255c491 ("include/linux/slab.h: add kmalloc_array_node() and
kcalloc_node()") was added in 2017.  Update the unnecessary OOM message
test to include it.

Link: https://lkml.kernel.org/r/b9dc4a808b1518e08ab8761480d9872e5d18e7cd.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check
+++ a/scripts/checkpatch.pl
@@ -487,7 +487,7 @@ our $logFunctions = qr{(?x:
 
 our $allocFunctions = qr{(?x:
 	(?:(?:devm_)?
-		(?:kv|k|v)[czm]alloc(?:_node|_array)? |
+		(?:kv|k|v)[czm]alloc(?:_array)?(?:_node)? |
 		kstrdup(?:_const)? |
 		kmemdup(?:_nul)?) |
 	(?:\w+)?alloc_skb(?:_ip_align)? |
_
