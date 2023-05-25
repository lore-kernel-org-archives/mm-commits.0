Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4020C77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbjEYVvb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjEYVva (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:51:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD711B1
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3C4B64B92
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F35C433EF;
        Thu, 25 May 2023 21:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051421;
        bh=I6ZDFn+qp8YczWSR+V7xECf0h7MFpRI4S507xE8FFQo=;
        h=Date:To:From:Subject:From;
        b=b2UDXnohA8+LaHqIsef1k2v7K2+w3hBJvoOfLSFhOsybBbKq4wzXX2OIrX5uSxrGD
         mj7GDQEw48l+0FvvYeb068p9klOl9Nq7Zy1CymH7+VlOBJwkm+QP4DPd8md/5FXHoZ
         8/9IBEaLzGbms8tYUywggt/hqnGE53Da8ray7ygg=
Date:   Thu, 25 May 2023 14:50:20 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch added to mm-unstable branch
Message-Id: <20230525215021.24F35C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: add sections for basic parts of DAMOS
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch

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
Subject: Docs/mm/damon/design: add sections for basic parts of DAMOS
Date: Thu, 25 May 2023 21:43:11 +0000

DAMOS is an important part of DAMON, but the design doc is not covering
it.  Add sections for covering the basic part of DAMOS.

Link: https://lkml.kernel.org/r/20230525214314.5204-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   70 ++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-sections-for-basic-parts-of-damos
+++ a/Documentation/mm/damon/design.rst
@@ -202,3 +202,73 @@ monitoring operations to check dynamic c
 and applies it to monitoring operations-related data structures such as the
 abstracted monitoring target memory area only for each of a user-specified time
 interval (``update interval``).
+
+
+Operation Schemes
+-----------------
+
+One common purpose of data access monitoring is access-aware system efficiency
+optimizations.  For example,
+
+    paging out memory regions that are not accessed for more than two minutes
+
+or
+
+    using THP for memory regions that are larger than 2 MiB and showing a high
+    access frequency for more than one minute.
+
+One straightforward approach for such schemes would be profile-guided
+optimizations.  That is, getting data access monitoring results of the
+workloads or the system using DAMON, finding memory regions of special
+characteristics by profiling the monitoring results, and making system
+operation changes for the regions.  The changes could be made by modifying or
+providing advice to the software (the application and/or the kernel), or
+reconfiguring the hardware.  Both offline and online approaches could be
+available.
+
+Among those, providing advice to the kernel at runtime would be flexible and
+effective, and therefore widely be used.   However, implementing such schemes
+could impose unnecessary redundancy and inefficiency.  The profiling could be
+redundant if the type of interest is common.  Exchanging the information
+including monitoring results and operation advice between kernel and user
+spaces could be inefficient.
+
+To allow users to reduce such redundancy and inefficiencies by offloading the
+works, DAMON provides a feature called Data Access Monitoring-based Operation
+Schemes (DAMOS).  It lets users specify their desired schemes at a high
+level.  For such specifications, DAMON starts monitoring, finds regions having
+the access pattern of interest, and applies the user-desired operation actions
+to the regions as soon as found.
+
+
+Operation Action
+~~~~~~~~~~~~~~~~
+
+The management action that the users desire to apply to the regions of their
+interest.  For example, paging out, prioritizing for next reclamation victim
+selection, advising ``khugepaged`` to collapse or split, or doing nothing but
+collecting statistics of the regions.
+
+The list of supported actions is defined in DAMOS, but the implementation of
+each action is in the DAMON operations set layer because the implementation
+normally depends on the monitoring target address space.  For example, the code
+for paging specific virtual address ranges out would be different from that for
+physical address ranges.  And the monitoring operations implementation sets are
+not mandated to support all actions of the list.  Hence, the availability of
+specific DAMOS action depends on what operations set is selected to be used
+together.
+
+Applying an action to a region is considered as changing the region's
+characteristics.  Hence, DAMOS resets the age of regions when an action is
+applied to those.
+
+
+Target Access Pattern
+~~~~~~~~~~~~~~~~~~~~~
+
+The access pattern of the schemes' interest.  The patterns are constructed with
+the properties that DAMON's monitoring results provide, specifically the size,
+the access frequency, and the age.  Users can describe their access pattern of
+interest by setting minimum and maximum values of the three properties.  If a
+region's three properties are in the ranges, DAMOS classifies it as one of the
+regions that the scheme is having an interest in.
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

