Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C57C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF3364F21
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhB0Cdh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhB0Cc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 745A164F14;
        Sat, 27 Feb 2021 02:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393147;
        bh=TQHJ2JIuWavz8R/I/k3ABe4hyFXQctmdj8tmej1HEI4=;
        h=Date:From:To:Subject:From;
        b=Vl+MHbydwryP/X0FXzrchuQKB+UsXtKSwIsqGRmV0X59vO7ohKv9858qW8G1O+TLH
         Cw0/ebVgOHfgQb5/fGRmtyBdGb5XYB25jxyL7UaZovxt5ZdUxcwWdmBX6+vdmzIEPB
         QNpOyv00WPHRnyMu0zike1immBD2BPNYabtWzsBU=
Date:   Fri, 26 Feb 2021 18:32:27 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, kuba@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check.patch
 removed from -mm tree
Message-ID: <20210227023227.Y74a3t9C3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add kmalloc_array_node to unnecessary OOM message check
has been removed from the -mm tree.  Its filename was
     checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are


