Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90415C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A8E207DA
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597863767;
	bh=smg6mRFkSm4lWG7WEDMGdYprSy/PmBfpILWH4q/4EOs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=R81R2Wx1T1XXzXzgMgXff7Kb4HjeZyMqlQ2SHRLmicYzxATWwDYjKSt1Fbhp5AILZ
	 Ga3Ydk9m+fNIwS0Mui78C/By4oxsGv/3Pggb9dR2ck9TMVRQGtNTver19KMQc2N1+O
	 xR9e+vMCAL9yzUnkxTj8I68SAuqnVSV9C1J+CMdw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHSTCq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSTCq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:02:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A567F207DA;
        Wed, 19 Aug 2020 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597863765;
        bh=smg6mRFkSm4lWG7WEDMGdYprSy/PmBfpILWH4q/4EOs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VJAcg/LsxlVgjcAzOjS1uYViLPj3kv8/Ee+YNsFyrowBKhOBL3WiWlf3/UZEQWPvC
         bmfdp41pk78RaGnfIWkcSOE0TFyUClnY3oQPoo/AsVLTrxjgILasdmbhkVLi8ScY6n
         zRKzHXc9i+iGgMHm0rFWcx4rr5r/vA7qV7OTqopQ=
Date:   Wed, 19 Aug 2020 12:02:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ira.weiny@intel.com,
        mm-commits@vger.kernel.org
Subject:  + mm-highmem-clean-up-endif-comments.patch added to -mm
 tree
Message-ID: <20200819190245.ETmCa4Vk3%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem.c: clean up endif comments
has been added to the -mm tree.  Its filename is
     mm-highmem-clean-up-endif-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-clean-up-endif-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-clean-up-endif-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/highmem.c: clean up endif comments

The #endif at the end of the file matches up with the '#if
defined(HASHED_PAGE_VIRTUAL)' on line 374.  Not the CONFIG_HIGHMEM #if
earlier.

Fix comments on both of the #endif's to indicate the correct end of blocks
for each.

Link: https://lkml.kernel.org/r/20200819184635.112579-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~mm-highmem-clean-up-endif-comments
+++ a/mm/highmem.c
@@ -369,7 +369,7 @@ void kunmap_high(struct page *page)
 }
 
 EXPORT_SYMBOL(kunmap_high);
-#endif
+#endif	/* CONFIG_HIGHMEM */
 
 #if defined(HASHED_PAGE_VIRTUAL)
 
@@ -481,4 +481,4 @@ void __init page_address_init(void)
 	}
 }
 
-#endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
+#endif	/* defined(HASHED_PAGE_VIRTUAL) */
_

Patches currently in -mm which might be from ira.weiny@intel.com are

mm-highmem-clean-up-endif-comments.patch

