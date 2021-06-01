Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A24C47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 23:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D371613DB
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 23:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhFAXpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234766AbhFAXpQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 19:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE1976139A;
        Tue,  1 Jun 2021 23:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622591013;
        bh=Tw9R+MKD8AAaXBck2EJlgZbP/omtzCSt7sIWz4iGjvc=;
        h=Date:From:To:Subject:From;
        b=liBVpEda6eqpv9joue2LhYqSFbQvZJFgy31wUOThN+gaZZTuLJh8oycj6gerB9WHb
         jgRiNcAcX3LiwNSWPS09GesPR+/AJrUlsbUmfxL9SlovgikluaAQ0+SVh1Yk+b86Sr
         KW3vHIAXwQVD17ZBwIXKS8SP2Te49ZlIHwZAJX1E=
Date:   Tue, 01 Jun 2021 16:43:33 -0700
From:   akpm@linux-foundation.org
To:     colyli@suse.de, mm-commits@vger.kernel.org, rdunlap@infradead.org,
        yuehaibing@huawei.com
Subject:  + lib-crc64-fix-kernel-doc-warning.patch added to -mm
 tree
Message-ID: <20210601234333.NZNdGUHBl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: crc64: fix kernel-doc warning
has been added to the -mm tree.  Its filename is
     lib-crc64-fix-kernel-doc-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-crc64-fix-kernel-doc-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-crc64-fix-kernel-doc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: lib: crc64: fix kernel-doc warning

Fix W=1 kernel build warning:

lib/crc64.c:40: warning:
 bad line:         or the previous crc64 value if computing incrementally.

Link: https://lkml.kernel.org/r/20210601135851.15444-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Coly Li <colyli@suse.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crc64.c~lib-crc64-fix-kernel-doc-warning
+++ a/lib/crc64.c
@@ -37,7 +37,7 @@ MODULE_LICENSE("GPL v2");
 /**
  * crc64_be - Calculate bitwise big-endian ECMA-182 CRC64
  * @crc: seed value for computation. 0 or (u64)~0 for a new CRC calculation,
-	or the previous crc64 value if computing incrementally.
+ *       or the previous crc64 value if computing incrementally.
  * @p: pointer to buffer over which CRC64 is run
  * @len: length of buffer @p
  */
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

lib-crc64-fix-kernel-doc-warning.patch
mm-dmapool-use-device_attr_ro-macro.patch
mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix.patch
mm-compaction-use-device_attr_wo-macro.patch

