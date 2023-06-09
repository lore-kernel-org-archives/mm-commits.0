Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6A0C7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjFIXdT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbjFIXcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECDF46AB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C51663EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707C3C433D2;
        Fri,  9 Jun 2023 23:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353386;
        bh=mMeEA1ZJ8Ta/8biKUFuExdw+0X6Q8Q65UxrzpowuwNM=;
        h=Date:To:From:Subject:From;
        b=0bpgJR9Z5GgBAhtVNoD3Oho02tBb1P2I3zFkkgJVDFSwkMjO/LjzH8Zbelbi2GW3H
         7J6I8L3Ambb2bcKnFFUWPVx0UMdmiDxkdAdvjYdTPGR/L5DUnE88WF0w2ktKVD7T/b
         /x5dNovIpyodHosOShqGZKLKpgAWkIi5L2iz5V+w=
Date:   Fri, 09 Jun 2023 16:29:45 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch removed from -mm tree
Message-Id: <20230609232946.707C3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: add sections for basic parts of DAMOS
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


