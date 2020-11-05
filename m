Return-Path: <SRS0=UeFd=EL=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0397C2D0A3
	for <mm-commits@archiver.kernel.org>; Thu,  5 Nov 2020 01:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F5CD20BED
	for <mm-commits@archiver.kernel.org>; Thu,  5 Nov 2020 01:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604538181;
	bh=yN6TSVu5oSaY5n8rLoVFRoj/hyCDNdDJI0KUjQppgOI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=G0zSY4E3bIZ8QDJX6MuLmoI2prQckB9Hf1buC2rfi2UJ5WfujF+ogVRwLNA9lP1CV
	 DbdC0dhk8YjWnyTdeMTt3ysFqqbvceqoh70qRWUYrqYE+HRMD14Jo0LDxAK6ns6wPB
	 CgsfYN8g21Exh06oIz6DSmvQd/QAP6kjYi95rp8Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgKEBDB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Nov 2020 20:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbgKEBDA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 4 Nov 2020 20:03:00 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D71E20867;
        Thu,  5 Nov 2020 01:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604538180;
        bh=yN6TSVu5oSaY5n8rLoVFRoj/hyCDNdDJI0KUjQppgOI=;
        h=Date:From:To:Subject:From;
        b=CPt2wYIsXP1T+Ox+kDdvaQhs/ZEFWdjLC9Dzk1EZ3g2PyZ3e6uGm9mREh8EsHJYJY
         F9uikoxIGIG4b/yJjJ6N2diYKcN+0wc2sGPUSQMlsATDh2xRiIuxViD2u7buctAMce
         lIyLjlrLhv/M6NGrnJO0x0O74ASc8GdRq5N7rEI4=
Date:   Wed, 04 Nov 2020 17:02:59 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        john.garry@huawei.com, jhubbard@nvidia.com,
        song.bao.hua@hisilicon.com
Subject:  + mm-gup_benchmark-gup_benchmark-depends-on-debug_fs.patch
 added to -mm tree
Message-ID: <20201105010259.U-rYU%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_test: GUP_TEST depends on DEBUG_FS
has been added to the -mm tree.  Its filename is
     mm-gup_benchmark-gup_benchmark-depends-on-debug_fs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup_benchmark-gup_benchmark-depends-on-debug_fs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup_benchmark-gup_benchmark-depends-on-debug_fs.patch

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
Subject: mm/gup_test: GUP_TEST depends on DEBUG_FS

Without DEBUG_FS, all the code in gup_benchmark becomes meaningless.
For sure kernel provides debugfs stub while DEBUG_FS is disabled, but
the point here is that GUP_TEST can do nothing without DEBUG_FS.

Link: https://lkml.kernel.org/r/20201104100552.20156-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Suggested-by: John Garry <john.garry@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~mm-gup_benchmark-gup_benchmark-depends-on-debug_fs
+++ a/mm/Kconfig
@@ -836,6 +836,7 @@ config PERCPU_STATS
 
 config GUP_TEST
 	bool "Enable infrastructure for get_user_pages()-related unit tests"
+	depends on DEBUG_FS
 	help
 	  Provides /sys/kernel/debug/gup_test, which in turn provides a way
 	  to make ioctl calls that can launch kernel-based unit tests for
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch
mm-gup_benchmark-gup_benchmark-depends-on-debug_fs.patch

