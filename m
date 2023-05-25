Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8144C77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241992AbjEYVvE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjEYVu5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F34E44
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F76F64B7C
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F98C433D2;
        Thu, 25 May 2023 21:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051414;
        bh=yQYH844yi2OVLcPTZORIbSD/8bmZ2EtV/89Kv8Ajjk0=;
        h=Date:To:From:Subject:From;
        b=RSskgR6HThKaZipVjuQ3y/YEtqkwkd55REdWJYStD3HfirXSYwtrc0USBqQuOuc60
         xRtm7e+3Cxh8dSjPzPeziTr4iqZnsKJon0qfj1z/jTLOddkFlf814/evA3dqlmAfgg
         pxSXVR/9bmWxGFe37UVHKhaFQxQfRKiR2wXe6uP4=
Date:   Thu, 25 May 2023 14:50:13 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-a-section-for-overall-architecture.patch added to mm-unstable branch
Message-Id: <20230525215014.63F98C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: add a section for overall architecture
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-a-section-for-overall-architecture.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-a-section-for-overall-architecture.patch

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
Subject: Docs/mm/damon/design: add a section for overall architecture
Date: Thu, 25 May 2023 21:43:07 +0000

The design doc is missing overall picture of DAMON.  Add a section for
overall architeucture and layers.

Link: https://lkml.kernel.org/r/20230525214314.5204-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-a-section-for-overall-architecture
+++ a/Documentation/mm/damon/design.rst
@@ -4,6 +4,21 @@
 Design
 ======
 
+
+Overall Architecture
+====================
+
+DAMON subsystem is configured with three layers including
+
+- Operations Set: Implements fundamental operations for DAMON that depends on
+  the given monitoring target address-space and available set of
+  software/hardware primitives,
+- Core: Implements core logics including monitoring overhead/accurach control
+  and access-aware system operations on top of the operations set layer, and
+- Modules: Implements kernel modules for various purposes that provides
+  interfaces for the user space, on top of the core layer.
+
+
 Configurable Layers
 ===================
 
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

