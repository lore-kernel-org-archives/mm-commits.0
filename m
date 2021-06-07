Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE88C47082
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B019D61208
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFGXJR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 19:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhFGXJR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 19:09:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 951B360C3E;
        Mon,  7 Jun 2021 23:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623107230;
        bh=bDjhOeYZ7s5LJmbDDaeb6KkhSQMl6HFLmEQFqcQtTi4=;
        h=Date:From:To:Subject:From;
        b=tRNHpimEltqiLNINKjtZ8p1wC6vMKdBuNA2KSF3IdquSlsiHLsGWC/aDdAs+HiXzs
         +8KkRt2J/of3gs3i5e3Cmz8pkgkbWYATDL6AD9qVC2Zt3vQd0xQ+c+ns6YKk4F6Dls
         QEUGu77C+hP1GpWLCe/DpjL9qozocBXw79hNbkX0=
Date:   Mon, 07 Jun 2021 16:07:10 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  + lib-memscan-fixlet.patch added to -mm tree
Message-ID: <20210607230710.6trdEm9YQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: memscan() fixlet
has been added to the -mm tree.  Its filename is
     lib-memscan-fixlet.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-memscan-fixlet.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-memscan-fixlet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-memscan-fixlet.patch
exec-remove-checks-in-__register_bimfmt.patch

