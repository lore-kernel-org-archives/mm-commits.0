Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7477C56201
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84ABB20797
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pIxPRiO4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgKJVv3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 16:51:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731984AbgKJVvZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 16:51:25 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFB6F2074B;
        Tue, 10 Nov 2020 21:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605045084;
        bh=lZlCu5x7XotJ92EYllna3uBCiw7RjETCg7mrT/h3xME=;
        h=Date:From:To:Subject:From;
        b=pIxPRiO418hupw6jiJih/MbsGKSGLnR2rgYKzL227Y1rMc8n9VotVJzdDNHfcFZkD
         kUatJ7/g3j6Uw/wT4nEmVAm338HWTrw5f0EIE9IuxHqetSjR34gv6GNhzjqIvuLNIg
         6dsM+vkeD/TKe3r/BST5J0TlLSTnLX2uXEJg1cGI=
Date:   Tue, 10 Nov 2020 13:51:23 -0800
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, john.garry@huawei.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        rdunlap@infradead.org, song.bao.hua@hisilicon.com
Subject:  +
 mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2.patch added to -mm
 tree
Message-ID: <20201110215123.Bs0U7IZsr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2
has been added to the -mm tree.  Its filename is
     mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2

add comment as a prompt to users as commented by John and Randy

Link: https://lkml.kernel.org/r/20201108083732.15336-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Suggested-by: John Garry <john.garry@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/Kconfig~mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2
+++ a/mm/Kconfig
@@ -854,6 +854,9 @@ config GUP_TEST
 
 	  See tools/testing/selftests/vm/gup_test.c
 
+comment "GUP_TEST needs to have DEBUG_FS enabled"
+	depends on !GUP_TEST && !DEBUG_FS
+
 config GUP_GET_PTE_LOW_HIGH
 	bool
 
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch
mm-gup_benchmark-gup_benchmark-depends-on-debug_fs.patch
mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2.patch
mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch

