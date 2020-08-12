Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBBAC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 553E2221E2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266228;
	bh=P7Lfo9jynKVnlw6XG6HzMq7s1aCQDmfhpKD7YzbAvko=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FqvgHt7s5T+yHioGmUlaHEUmjkMMxohSpUHzQKps134Ne7TszG8uKXNeB7ntfpkEk
	 HXp8MEZWZ5GnMJUT8X5lqS0iQInDd1wGMvsZF09NJpLWAGcyBHy2j+XLFe3QG+hFW8
	 /MmenrSgJiU+ilZKR7LuVaXE1yDVODhNeWMK7bWE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHLVDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHLVDr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CCF62177B;
        Wed, 12 Aug 2020 21:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266226;
        bh=P7Lfo9jynKVnlw6XG6HzMq7s1aCQDmfhpKD7YzbAvko=;
        h=Date:From:To:Subject:From;
        b=mRTtuWGxoGBC1ktwINsUlvKzN3XmyIz97RWfY3OhNOX3RPGSWlB9+/UCIwsgmUKUp
         2bMZ68UwB7/FH/IMdYvjutAJeMdnKV3ncXnscJz5UmH/wrYI+Z8bSZUyMzVMiZcMhi
         J4rT49jDZttfmD8vjD7OGU8O7xa8equPZVMWz1MY=
Date:   Wed, 12 Aug 2020 14:03:46 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, nivedita@alum.mit.edu
Subject:  [merged]
 kernelh-remove-duplicate-include-of-asm-div64h.patch removed from -mm tree
Message-ID: <20200812210346.zHGOdrqBn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: remove duplicate include of asm/div64.h
has been removed from the -mm tree.  Its filename was
     kernelh-remove-duplicate-include-of-asm-div64h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


