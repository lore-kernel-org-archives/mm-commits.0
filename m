Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56AFC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FD3761CA9
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGFTZV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhGFTZU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76E9461CA3;
        Tue,  6 Jul 2021 19:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599361;
        bh=HNB0dOZJppTrcQGM5cQlzkcju7NQ2B1VFpn/FfYIEsY=;
        h=Date:From:To:Subject:From;
        b=oUKU/E1QO0ZsHXbO1SSJAX2MBss+h0NgoDkOAnDstXFxDL1eTEZKnFZc4g79S/f2C
         YfXrjgzwMqQpfeazjWuyQ8O9BjOq6bIIZCYQQhX5kuM7iKZZmlh0n2ICNfcnQRVYJ7
         tx2VBUvaNVcBoTa2v6jogI5kBpL+sf9pc8s9+eyY=
Date:   Tue, 06 Jul 2021 12:22:41 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] lib-memscan-fixlet.patch removed from -mm tree
Message-ID: <20210706192241.G-w6wDdqw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: memscan() fixlet
has been removed from the -mm tree.  Its filename was
     lib-memscan-fixlet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib: memscan() fixlet

Generic version doesn't trucate second argument to char.

Older brother memchr() does as do s390, sparc and i386 assembly versions.

Fortunately, no code passes c >= 256.

Link: https://lkml.kernel.org/r/YLv4cCf0t5UPdyK+@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/string.c~lib-memscan-fixlet
+++ a/lib/string.c
@@ -977,7 +977,7 @@ void *memscan(void *addr, int c, size_t
 	unsigned char *p = addr;
 
 	while (size) {
-		if (*p == c)
+		if (*p == (unsigned char)c)
 			return (void *)p;
 		p++;
 		size--;
_

Patches currently in -mm which might be from adobriyan@gmail.com are


