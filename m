Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4266EC7EE2C
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241962AbjEYVvG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241988AbjEYVvD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B655110E7
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6352964B78
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAAAC433D2;
        Thu, 25 May 2023 21:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051417;
        bh=lDuR78IR/PUoa2hw/BqhEcu6x6EvlAHhJbJcbCQjpTU=;
        h=Date:To:From:Subject:From;
        b=BKcPo7AYdDRmRVO2Idgf1EQJqUMeWDZVq+nVszVkiixe9nQ6gAugZJ5NGZpbGT0X0
         eel7O1asa39SnWQRjTvWIKsMoOKguHkSRSK8EUpj+1Cs78KPzjEPF2kYxQPI2joaiV
         2TboSix+lzDHKXtIELfd6vnVmUlsWZEWgzvpzpko=
Date:   Thu, 25 May 2023 14:50:17 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-rewrite-configurable-layers.patch added to mm-unstable branch
Message-Id: <20230525215017.BAAAAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: rewrite configurable layers
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-rewrite-configurable-layers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-rewrite-configurable-layers.patch

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
Subject: Docs/mm/damon/design: rewrite configurable layers
Date: Thu, 25 May 2023 21:43:09 +0000

The 'Configurable Operations Set' section is a little bit outdated. 
Update the text.

Link: https://lkml.kernel.org/r/20230525214314.5204-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-rewrite-configurable-layers
+++ a/Documentation/mm/damon/design.rst
@@ -22,24 +22,23 @@ DAMON subsystem is configured with three
 Configurable Operations Set
 ---------------------------
 
-DAMON provides data access monitoring functionality while making the accuracy
-and the overhead controllable.  The fundamental access monitorings require
-primitives that dependent on and optimized for the target address space.  On
-the other hand, the accuracy and overhead tradeoff mechanism, which is the core
-of DAMON, is in the pure logic space.  DAMON separates the two parts in
-different layers and defines its interface to allow various low level
-primitives implementations configurable with the core logic.  We call the low
-level primitives implementations monitoring operations.
+For data access monitoring and additional low level work, DAMON needs a set of
+implementations for specific operations that are dependent on and optimized for
+the given target address space.  On the other hand, the accuracy and overhead
+tradeoff mechanism, which is the core logic of DAMON, is in the pure logic
+space.  DAMON separates the two parts in different layers, namely DAMON
+Operations Set and DAMON Core Logics Layers, respectively.  It further defines
+the interface between the layers to allow various operations sets to be
+configured with the core logic.
 
-Due to this separated design and the configurable interface, users can extend
-DAMON for any address space by configuring the core logics with appropriate
-monitoring operations.  If appropriate one is not provided, users can implement
-the operations on their own.
+Due to this design, users can extend DAMON for any address space by configuring
+the core logic to use the appropriate operations set.  If any appropriate set
+is unavailable, users can implement one on their own.
 
 For example, physical memory, virtual memory, swap space, those for specific
 processes, NUMA nodes, files, and backing memory devices would be supportable.
-Also, if some architectures or devices support special optimized access check
-primitives, those will be easily configurable.
+Also, if some architectures or devices supporting special optimized access
+check primitives, those will be easily configurable.
 
 
 Operations Set Layer
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

