Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5F6C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbjEYVu4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241625AbjEYVuz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFE81A6
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC0AC64AF3
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EACC433D2;
        Thu, 25 May 2023 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051411;
        bh=5K3SUVOEPP50WqdxndXvi1iXm59DlkBvaSXuP3M2Btc=;
        h=Date:To:From:Subject:From;
        b=FlrY/Im+9pFVH1yJA+gmh2ihvgm4Y97rk4w7Y4uszqMDWyRNSsoo/y7Mo2708YCxi
         JD9D8avGnBtZv7/Ii3dBXTPpXSacr+n8JrUIUUkrKtGwGlzHr1FkgoTYvyMIq1S78M
         fN7rKbNO0+XomzR0kAV4m2+xk00F5fX+AAr5LlNk=
Date:   Thu, 25 May 2023 14:50:10 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-faq-remove-old-questions.patch added to mm-unstable branch
Message-Id: <20230525215011.23EACC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/faq: remove old questions
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-faq-remove-old-questions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-faq-remove-old-questions.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/faq: remove old questions
Date: Thu, 25 May 2023 21:43:05 +0000

Patch series "Docs/mm/damon: Minor fixes and design doc update".

Some of the DAMON documents are outdated, or having minor typos or grammar
erros.  Especially, the design doc has not updated for DAMOS, which is an
important part of DAMON.  Fix the minor issues and update documents.


This patch (of 10):

The first two questions of DAMON faqs have raised when DAMON patches were
first submitted.  More than one year has passed since DAMON patches get
merged in the mainline, and that kind of questions are not asked nowadays.
Remove the questions.

Link: https://lkml.kernel.org/r/20230525214314.5204-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230525214314.5204-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/faq.rst |   23 -----------------------
 1 file changed, 23 deletions(-)

--- a/Documentation/mm/damon/faq.rst~docs-mm-damon-faq-remove-old-questions
+++ a/Documentation/mm/damon/faq.rst
@@ -4,29 +4,6 @@
 Frequently Asked Questions
 ==========================
 
-Why a new subsystem, instead of extending perf or other user space tools?
-=========================================================================
-
-First, because it needs to be lightweight as much as possible so that it can be
-used online, any unnecessary overhead such as kernel - user space context
-switching cost should be avoided.  Second, DAMON aims to be used by other
-programs including the kernel.  Therefore, having a dependency on specific
-tools like perf is not desirable.  These are the two biggest reasons why DAMON
-is implemented in the kernel space.
-
-
-Can 'idle pages tracking' or 'perf mem' substitute DAMON?
-=========================================================
-
-Idle page tracking is a low level primitive for access check of the physical
-address space.  'perf mem' is similar, though it can use sampling to minimize
-the overhead.  On the other hand, DAMON is a higher-level framework for the
-monitoring of various address spaces.  It is focused on memory management
-optimization and provides sophisticated accuracy/overhead handling mechanisms.
-Therefore, 'idle pages tracking' and 'perf mem' could provide a subset of
-DAMON's output, but cannot substitute DAMON.
-
-
 Does DAMON support virtual memory only?
 =======================================
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-faq-remove-old-questions.patch
docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch
docs-mm-damon-design-add-a-section-for-overall-architecture.patch
docs-mm-damon-design-update-the-layout-based-on-the-layers.patch
docs-mm-damon-design-rewrite-configurable-layers.patch
docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch
docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch
docs-mm-damon-design-add-sections-for-advanced-features-of-damos.patch
docs-mm-damon-design-add-a-section-for-damon-core-api.patch
docs-mm-damon-design-add-a-section-for-the-modules-layer.patch

