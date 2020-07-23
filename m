Return-Path: <SRS0=ssb3=BC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22575C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFCF207C4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595548245;
	bh=JI6HFAiKsnGprIxG3QaLAW2YD9ELt8uwPtkl9VhbpQs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EGRZQJIQI3RlOz8ioEYRBSGs/xppOEIvXUqRFusirK1wW5bskVfFeEEeAOkReARJU
	 kCaGdEoGZJnvPxu9ROwlrnOb0zKUdvT2k5HgMWGmnlh3HcrYCVzShnG0Xvqjn3AvA0
	 bi/H9lKOWbMp8v3/YV0W56TWuIY+w6nsmAHQFdws=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgGWXuo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 19:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgGWXuo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 19:50:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA89B207C4;
        Thu, 23 Jul 2020 23:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595548243;
        bh=JI6HFAiKsnGprIxG3QaLAW2YD9ELt8uwPtkl9VhbpQs=;
        h=Date:From:To:Subject:From;
        b=qUqSbGjENmjVydBUiSIBt2EFh+NSgK6DAueNlZ5F3sCj+YR/o0Wc3MxxjjGhI71O2
         I+pb345KePZj7etM/A6ocm2CBC9+4FYH6PRcNmmeUbwTmts9Dm6pkS0xPwHU+HKIBO
         AeaKKbfKWwccpUUFAZ60+FG/+E1Rt8Wr1siQAb6A=
Date:   Thu, 23 Jul 2020 16:50:43 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        nivedita@alum.mit.edu
Subject:  + sparc-drop-unused-max_physaddr_bits.patch added to -mm
 tree
Message-ID: <20200723235043.E03qn8y0-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: drop unused MAX_PHYSADDR_BITS
has been added to the -mm tree.  Its filename is
     sparc-drop-unused-max_physaddr_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-drop-unused-max_physaddr_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-drop-unused-max_physaddr_bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: sparc: drop unused MAX_PHYSADDR_BITS

The macro is not used anywhere, so remove the definition.

Link: http://lkml.kernel.org/r/20200723231544.17274-4-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/sparsemem.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/sparc/include/asm/sparsemem.h~sparc-drop-unused-max_physaddr_bits
+++ a/arch/sparc/include/asm/sparsemem.h
@@ -7,7 +7,6 @@
 #include <asm/page.h>
 
 #define SECTION_SIZE_BITS       30
-#define MAX_PHYSADDR_BITS       MAX_PHYS_ADDRESS_BITS
 #define MAX_PHYSMEM_BITS        MAX_PHYS_ADDRESS_BITS
 
 #endif /* !(__KERNEL__) */
_

Patches currently in -mm which might be from nivedita@alum.mit.edu are

x86-mm-drop-unused-max_physaddr_bits.patch
sh-mm-drop-unused-max_physaddr_bits.patch
sparc-drop-unused-max_physaddr_bits.patch

