Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EE1C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A382620738
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598300297;
	bh=irVyoUZi+GHozHBIMdi34Tnw+38Av+/kOq11r24BXHk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IpREi91Yi/LqxXRuZRl+1SRkByLu93i+aB3VJDQRVXldtX8id0A/ZvDAmbsB6Qvgw
	 1ERG9D48LpFYm41JBQKe6NUYfTo7N+CZDujENo0XPpdFgbzedR/1gXE0Bt3M891h//
	 CiAxJcGk6eXOlRPyzwyK2MBTkAQE0gEmhbeyxJXA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHXUSR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUSQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 16:18:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02CFA20738;
        Mon, 24 Aug 2020 20:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598300295;
        bh=irVyoUZi+GHozHBIMdi34Tnw+38Av+/kOq11r24BXHk=;
        h=Date:From:To:Subject:From;
        b=yFo7/YFjj1+iuiqHF95gksZq5HXFSQDUMvbc5/YVxqYL2nyMhhOxiJzkA2ICZ0xGE
         goT3hxPxXYepm/u15KY5bLQTNupHnlUivQQpBV7OESHXJTabbvR5a2mqqgHghDMPts
         KRhOB5HjPfFlhxOhi49dtvTJRliQgdDnektd2xOY=
Date:   Mon, 24 Aug 2020 13:18:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + lib-bitmap-delete-duplicated-words.patch added to -mm
 tree
Message-ID: <20200824201814.mQ53hWQOh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: delete duplicated words
has been added to the -mm tree.  Its filename is
     lib-bitmap-delete-duplicated-words.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-delete-duplicated-words.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-delete-duplicated-words.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: bitmap: delete duplicated words

Drop the repeated word "an".

Link: https://lkml.kernel.org/r/20200823040424.25760-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bitmap.c~lib-bitmap-delete-duplicated-words
+++ a/lib/bitmap.c
@@ -23,7 +23,7 @@
 /**
  * DOC: bitmap introduction
  *
- * bitmaps provide an array of bits, implemented using an an
+ * bitmaps provide an array of bits, implemented using an
  * array of unsigned longs.  The number of valid bits in a
  * given bitmap does _not_ need to be an exact multiple of
  * BITS_PER_LONG.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch

