Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8467EC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536C3207DE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597866877;
	bh=gtC4T3UadAvFbcuL8eKuaU0zuZbX4Rv13SHM9HQGbWI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mZjGQFCI9IYTZ8+HUtHEB71y61eybODyPVF0nP7Zrl1mtnPfO3pHXaRzqQkN+IIOl
	 PyvjhvzEdosIARm/k0gRN80c53yz0d00HvBULkmoVuceZNUYpme6JLyz/7oa9WEXHc
	 Q7ZU8hO4h/17v1M2HcSmJKnFL1tjK7RBjQnU3/iM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgHSTyg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHSTyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:54:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C975B207DA;
        Wed, 19 Aug 2020 19:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597866875;
        bh=gtC4T3UadAvFbcuL8eKuaU0zuZbX4Rv13SHM9HQGbWI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y36vmQ/BR6SEA7rsFGSaDZ28fxDsE0t+6khpzSznLbf1dkExBPaOi5fOwqxAmfA79
         xb6stV1ulGwxfa8AsOaGOhYZRWJOKzepDfS/pqYY08ztk1Yj8B03oEgavJqF6Pu+G4
         2m355PjA7ttXHVGZC1yGcNaIUMy+hh/eLzYKIZW8=
Date:   Wed, 19 Aug 2020 12:54:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     agordeev@linux.ibm.com, corbet@lwn.net, mm-commits@vger.kernel.org
Subject:  +
 docs-vm-fix-mm_count-vs-mm_users-counter-confusion.patch added to -mm tree
Message-ID: <20200819195434._QdFl_2CH%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs/vm: fix 'mm_count' vs 'mm_users' counter confusion
has been added to the -mm tree.  Its filename is
     docs-vm-fix-mm_count-vs-mm_users-counter-confusion.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-vm-fix-mm_count-vs-mm_users-counter-confusion.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-vm-fix-mm_count-vs-mm_users-counter-confusion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

docs-vm-fix-mm_count-vs-mm_users-counter-confusion.patch

