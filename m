Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC67C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62622078D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598300305;
	bh=JE5ErtZfseruDvQbxw5Abdlqv25u7GqietfkBagOlTo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RVj+MQ5H5xcJ8XUy+Itl+6n2Uhq4brm2/+hOO7V+6TUBN06S/m10BdrzNkaLBX8rV
	 TsWuopQnkgFy3jAffX9hIcRdRyQ1onvM5Mu95AU3m9cNa/g8EDuIeFk5Maw04m53ua
	 ukqVUlRRpAjWTgjcvcsi7xIoLmckwzzgEulnaxPw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHXUSY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXUSV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 16:18:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8D120738;
        Mon, 24 Aug 2020 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598300301;
        bh=JE5ErtZfseruDvQbxw5Abdlqv25u7GqietfkBagOlTo=;
        h=Date:From:To:Subject:From;
        b=YKAvFVtWNjL0r2k0esnAMXwJrxlT84MY83PWSU/QraCsCgWhJO9672LksXsmDbNYu
         YZY59nvc1Y25yYuEEMQil9yVfOVgWaYdnD3tve4UZOzAM+DgBUKWF2P0ZLi3HUfkpJ
         yO8ipMpZtHTRILE5+cEYarY1Mzmumqy4gLrMzCvc=
Date:   Mon, 24 Aug 2020 13:18:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + lib-devres-delete-duplicated-words.patch added to -mm
 tree
Message-ID: <20200824201820.9JxUoA766%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: devres: delete duplicated words
has been added to the -mm tree.  Its filename is
     lib-devres-delete-duplicated-words.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-devres-delete-duplicated-words.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-devres-delete-duplicated-words.patch

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
Subject: lib: devres: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040443.25900-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/devres.c~lib-devres-delete-duplicated-words
+++ a/lib/devres.c
@@ -217,7 +217,7 @@ void __iomem *devm_ioremap_resource_wc(s
  * Please Note: This is not a one-to-one replacement for of_iomap() because the
  * of_iomap() function does not track whether the region is already mapped.  If
  * two drivers try to map the same memory, the of_iomap() function will succeed
- * but the the devm_of_iomap() function will return -EBUSY.
+ * but the devm_of_iomap() function will return -EBUSY.
  *
  */
 void __iomem *devm_of_iomap(struct device *dev, struct device_node *node, int index,
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

