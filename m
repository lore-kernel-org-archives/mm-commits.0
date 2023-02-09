Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00366C636CC
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 03:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjBIDlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Feb 2023 22:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbjBIDlO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2023 22:41:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CAB1EFD0
        for <mm-commits@vger.kernel.org>; Wed,  8 Feb 2023 19:41:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE6CFB81E98
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 03:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF87C433EF;
        Thu,  9 Feb 2023 03:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675914067;
        bh=Mfdiv8RMIrljoJ7HD7sFhenIxhVG0Vqqd+VUJW6CqJE=;
        h=Date:To:From:Subject:From;
        b=sGlRkiRNUT7qlU7Da95ks6mIEo8Jim/H7V9GnH5eLzdzrrJC3SN+F4ZXJxSamT0ny
         m2kP7Pld8UU65uBXIfwZNYhEuZGyKocJU5M4vYZpSH/Qkg3vBDMDzOtLc/McalwJa1
         PtnDqUC/qip6USeEbgOj5SVPCyaS7WfA5IZV1c/c=
Date:   Wed, 08 Feb 2023 19:41:06 -0800
To:     mm-commits@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        broonie@kernel.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-mm-fix-swp-type-masking-in-__swp_entry.patch added to mm-unstable branch
Message-Id: <20230209034107.6AF87C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm/mm: fix swp type masking in __swp_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     arm-mm-fix-swp-type-masking-in-__swp_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-mm-fix-swp-type-masking-in-__swp_entry.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: arm/mm: fix swp type masking in __swp_entry()
Date: Wed, 8 Feb 2023 15:08:01 +0100

We're masking with the number of type bits instead of the type mask, which
is obviously wrong.

Link: https://lkml.kernel.org/r/39fd91e3-c93b-23c6-afc6-cbe473bb0ca9@redhat.com
Fixes: 20aae9eff5ac ("arm/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arm/include/asm/pgtable.h~arm-mm-fix-swp-type-masking-in-__swp_entry
+++ a/arch/arm/include/asm/pgtable.h
@@ -292,7 +292,7 @@ static inline pte_t pte_modify(pte_t pte
 
 #define __swp_type(x)		(((x).val >> __SWP_TYPE_SHIFT) & __SWP_TYPE_MASK)
 #define __swp_offset(x)		((x).val >> __SWP_OFFSET_SHIFT)
-#define __swp_entry(type, offset) ((swp_entry_t) { (((type) & __SWP_TYPE_BITS) << __SWP_TYPE_SHIFT) | \
+#define __swp_entry(type, offset) ((swp_entry_t) { (((type) & __SWP_TYPE_MASK) << __SWP_TYPE_SHIFT) | \
 						   ((offset) << __SWP_OFFSET_SHIFT) })
 
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
_

Patches currently in -mm which might be from david@redhat.com are

arm-mm-fix-swp-type-masking-in-__swp_entry.patch

