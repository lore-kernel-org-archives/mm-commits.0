Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977F5C43467
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4140D221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709325;
	bh=MayYE6Vfrxoe0zwto06rvPStNX7w8XTAIkZr/TIOxPc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Q93cj0jl34C314P9JDJDXWPhJgWP67/u16ffdfoiZhowGXurkpQQLpMGopiYJjz7b
	 gC2ha3iBCNldk4FzKYA5HiIHoe8geAvtciDuE+buR3tFnbCRGmgblNQs0pyKNXFETK
	 qsIwieba8YfZo/mK3VorKzGG9zr1XB+eA4InGV1g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgJNVCE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730681AbgJNVCE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B8C820725;
        Wed, 14 Oct 2020 21:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709322;
        bh=MayYE6Vfrxoe0zwto06rvPStNX7w8XTAIkZr/TIOxPc=;
        h=Date:From:To:Subject:From;
        b=A2Wsz6vlffe68ojYzr+C2SKCIprb8LCv/0xpBOgJO3+Pdhs06XdQvirRnyoth9JbE
         0PXZuMWiF0cBEo1RJxwqqbmyJkTfjuZ7yXLov/HFA7W3b5cfpsBvl8hzxBMB4mkX1X
         sK/nwtPbDeJE6/nqwVV8C6w2Pa9nSIgOOEdExGos=
Date:   Wed, 14 Oct 2020 14:02:02 -0700
From:   akpm@linux-foundation.org
To:     agordeev@linux.ibm.com, corbet@lwn.net, mm-commits@vger.kernel.org
Subject:  [merged]
 docs-vm-fix-mm_count-vs-mm_users-counter-confusion.patch removed from -mm
 tree
Message-ID: <20201014210202.IwRK4Xycy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs/vm: fix 'mm_count' vs 'mm_users' counter confusion
has been removed from the -mm tree.  Its filename was
     docs-vm-fix-mm_count-vs-mm_users-counter-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: docs/vm: fix 'mm_count' vs 'mm_users' counter confusion

In the context of the anonymous address space lifespan description the
'mm_users' reference counter is confused with 'mm_count'.  I.e a "zombie"
mm gets released when "mm_count" becomes zero, not "mm_users".

Link: https://lkml.kernel.org/r/1597040695-32633-1-git-send-email-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/active_mm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/vm/active_mm.rst~docs-vm-fix-mm_count-vs-mm_users-counter-confusion
+++ a/Documentation/vm/active_mm.rst
@@ -64,7 +64,7 @@ Active MM
  actually get cases where you have a address space that is _only_ used by
  lazy users. That is often a short-lived state, because once that thread
  gets scheduled away in favour of a real thread, the "zombie" mm gets
- released because "mm_users" becomes zero.
+ released because "mm_count" becomes zero.
 
  Also, a new rule is that _nobody_ ever has "init_mm" as a real MM any
  more. "init_mm" should be considered just a "lazy context when no other
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


