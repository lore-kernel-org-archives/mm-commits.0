Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2700BC7EE2C
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241940AbjEYVvb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjEYVvb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37061B3
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DD8B64B77
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BD1C433D2;
        Thu, 25 May 2023 21:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051419;
        bh=I/dvfcR+mVzbINOttkQxpzKWTCW3uorLIKW1Pxs2RY4=;
        h=Date:To:From:Subject:From;
        b=tXtJIZdki6KA5aiheSiePyo8CXe0IaFVZRE2SD/V55T3xEy6N1UkcGwQS1go46RPO
         arMk5H1ds9wCh8VtiHjCSuB2+8C9sVcXfj00Y927nc3AZvnMsoYfFjJziCRg+RRB1P
         NrAHPoz4sDqpaKlFahxyln3/7GDcC4dE35VMbVQg=
Date:   Thu, 25 May 2023 14:50:18 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch added to mm-unstable branch
Message-Id: <20230525215019.70BD1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: add a section for the relation between Core and Modules layer
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch

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
Subject: Docs/mm/damon/design: add a section for the relation between Core and Modules layer
Date: Thu, 25 May 2023 21:43:10 +0000

Add overall desription of the interface and the relation between the Core
and the Modules layer under 'Overall Architecture' section.

Link: https://lkml.kernel.org/r/20230525214314.5204-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer
+++ a/Documentation/mm/damon/design.rst
@@ -41,6 +41,16 @@ Also, if some architectures or devices s
 check primitives, those will be easily configurable.
 
 
+Programmable Modules
+--------------------
+
+Core layer of DAMON is implemented as a framework, and exposes its application
+programming interface to all kernel space components such as subsystems and
+modules.  For common use cases of DAMON, DAMON subsystem provides kernel
+modules that built on top of the core layer using the API, which can be easily
+used by the user space end users.
+
+
 Operations Set Layer
 ====================
 
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

