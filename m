Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC6DC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E52620738
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598300298;
	bh=Tm9eu+XqO17dwQHJljIp/SUCD1/n4CwQbNIKtHkgjyc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cWhxOQJ0kR4zdekhUu75ZTk5yPoB+SyUdQBu9adM27uA5M3g79UYm4UQaRax1FTnj
	 JPsfJrjj+/baSu1MxxaKZ7o6i4b5WSmek7RURrVdFBwSw2JPi0KAuicCjE9v2S/yB/
	 X7QbHWvVVz5xvhVPK9Mvwl8wBSLwx3F+i8+NgeG8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgHXUSS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXUSR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 16:18:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB9E22074D;
        Mon, 24 Aug 2020 20:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598300296;
        bh=Tm9eu+XqO17dwQHJljIp/SUCD1/n4CwQbNIKtHkgjyc=;
        h=Date:From:To:Subject:From;
        b=AlWA13bQiatTLRjfMZvtWIpd54bZ0SxVFLCOigQ+BGntll9gxCdIqDkx4mCP9dRhe
         2vgG+LwB+gbgH0cYDVz84vzivyKuFlsoN9TR2xS/MoG/2s4cIal2y0tJY9CsfXaZgL
         fzm0R9nFAZ5F/Yp0WxXjuS7OqHLco5m3YlwNrkuQ=
Date:   Mon, 24 Aug 2020 13:18:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + lib-libcrc32c-delete-duplicated-words.patch added to
 -mm tree
Message-ID: <20200824201816.sjwQoWZHR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: libcrc32c: delete duplicated words
has been added to the -mm tree.  Its filename is
     lib-libcrc32c-delete-duplicated-words.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-libcrc32c-delete-duplicated-words.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-libcrc32c-delete-duplicated-words.patch

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
Subject: lib: libcrc32c: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040430.25807-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/libcrc32c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/libcrc32c.c~lib-libcrc32c-delete-duplicated-words
+++ a/lib/libcrc32c.c
@@ -12,7 +12,7 @@
  * pages =        {},
  * month =        {June},
  *}
- * Used by the iSCSI driver, possibly others, and derived from the
+ * Used by the iSCSI driver, possibly others, and derived from
  * the iscsi-crc.c module of the linux-iscsi driver at
  * http://linux-iscsi.sourceforge.net.
  *
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

