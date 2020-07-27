Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD527C433EB
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F0F42074F
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595880631;
	bh=cdrLiNgqSYW5mgwXsIiRr9K7n4RsFm7arnSMnQ52sXk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fEjOOquypZeQDrF067zpeysLTHo2dp7G+COU7F8v197fpoSqIInskRe25axcvdoBv
	 ZCgXNlqpeZeZ0+it2aI2xyycmMvKp0KUskuC76yv9JFBcJUeDsesBNNLNODTxm7fjV
	 15sF6WEDMHqI+ILHda8VTZiyykmdQeAqqFEs1BE0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgG0UKb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgG0UKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 16:10:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8861520729;
        Mon, 27 Jul 2020 20:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595880630;
        bh=cdrLiNgqSYW5mgwXsIiRr9K7n4RsFm7arnSMnQ52sXk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LbOVEzPe5jOw+C4LMYOo0myqBjPnpeNcRlV4pvy4s8XIyO8Go66JTM/VFJFPFELJm
         PYehoKYY3iLnAjzsbXK4/FS17HxjfaSAQL6uU43KIoZgJsdFCouYEKCnlSY1z/7bIZ
         Y9HMYu/TjnXNna6gsPE+6awTTJj5tsEDhS0BYpMk=
Date:   Mon, 27 Jul 2020 13:10:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hch@lst.de, mm-commits@vger.kernel.org, nivedita@alum.mit.edu
Subject:  + kernelh-remove-duplicate-include-of-asm-div64h.patch
 added to -mm tree
Message-ID: <20200727201030.MvgriPza8%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: remove duplicate include of asm/div64.h
has been added to the -mm tree.  Its filename is
     kernelh-remove-duplicate-include-of-asm-div64h.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-remove-duplicate-include-of-asm-div64h.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-remove-duplicate-include-of-asm-div64h.patch

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
Subject: kernel.h: remove duplicate include of asm/div64.h

This seems to have been added inadvertently in commit
  72deb455b5ec ("block: remove CONFIG_LBDAF")

Link: http://lkml.kernel.org/r/20200727034852.2813453-1-nivedita@alum.mit.edu
Fixes: 72deb455b5ec ("block: remove CONFIG_LBDAF")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/kernel.h~kernelh-remove-duplicate-include-of-asm-div64h
+++ a/include/linux/kernel.h
@@ -17,7 +17,6 @@
 #include <asm/byteorder.h>
 #include <asm/div64.h>
 #include <uapi/linux/kernel.h>
-#include <asm/div64.h>
 
 #define STACK_MAGIC	0xdeadbeef
 
_

Patches currently in -mm which might be from nivedita@alum.mit.edu are

sh-mm-drop-unused-max_physaddr_bits.patch
sparc-drop-unused-max_physaddr_bits.patch
kernelh-remove-duplicate-include-of-asm-div64h.patch

