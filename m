Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C062C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 889006141A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbhGAB6d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhGAB6c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C81BB61418;
        Thu,  1 Jul 2021 01:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104562;
        bh=qHGXSWtOk3VLrb2L/UpN8WPAMGnTXo4Y8XT5q4kDFYU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EQf4cXfm/QT+FypRh+rCXDv5s+/sEMGyb8QFmUQ3hnwCi/YRQ6DucZicXvtalth2G
         aFsXwj/ivcX4FCI9TN1btswIyWSqfWG61WklkWz0eDQ8zElwHgVBlLku+LZxXwYLI2
         t/hMUK2hcjeluS/fP04vitUfdJ5OyezpgR8LOGSQ=
Date:   Wed, 30 Jun 2021 18:56:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 167/192] lib: memscan() fixlet
Message-ID: <20210701015601.Iv6tEUqqh%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
