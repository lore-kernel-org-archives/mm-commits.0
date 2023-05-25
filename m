Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0642C77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242019AbjEYVvf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241959AbjEYVvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:51:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3521BB
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2514064B8D
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D2BC433D2;
        Thu, 25 May 2023 21:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051424;
        bh=OuX066fg8FoDFk6USbCgLsHYaESdpjv7/fbrGIEHhGg=;
        h=Date:To:From:Subject:From;
        b=LLi2Es49Q6WJMu6DapW+HB+yq/Ee0cKl9eOiBWHo+blA3k1oznhwqoupc2clxC3Mo
         PNQ2yymFefMSlH22ncb50ulaIwLOQfHY3OxLe6uWbV79YoQleFUwFBDpo45FqEJR70
         kPXNLW1oefK7R6at8thTozGRHRV3mi3waBgaiNGk=
Date:   Thu, 25 May 2023 14:50:23 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-a-section-for-damon-core-api.patch added to mm-unstable branch
Message-Id: <20230525215024.79D2BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: add a section for DAMON core API
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-a-section-for-damon-core-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-a-section-for-damon-core-api.patch

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
Subject: Docs/mm/damon/design: add a section for DAMON core API
Date: Thu, 25 May 2023 21:43:13 +0000

Add a section covering the API of DAMON core layer on the design document.

Link: https://lkml.kernel.org/r/20230525214314.5204-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-a-section-for-damon-core-api
+++ a/Documentation/mm/damon/design.rst
@@ -358,3 +358,15 @@ example, the memory cgroup filter type a
 the memory cgroup for the filter.  Hence, users can apply specific schemes to
 only anonymous pages, non-anonymous pages, pages of specific cgroups, all pages
 excluding those of specific cgroups, and any combination of those.
+
+
+Application Programming Interface
+---------------------------------
+
+The programming interface for kernel space data access-aware applications.
+DAMON is a framework, so it does nothing by itself.  Instead, it only helps
+other kernel components such as subsystems and modules building their data
+access-aware applications using DAMON's core features.  For this, DAMON exposes
+its all features to other kernel components via its application programming
+interface, namely ``include/linux/damon.h``.  Please refer to the API
+:doc:`document </mm/damon/api>` for details of the interface.
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

