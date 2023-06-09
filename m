Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA46C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjFIXdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjFIXcJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BF746B2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 186F661AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70828C433D2;
        Fri,  9 Jun 2023 23:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353387;
        bh=rDTc/q4R8/iV6Au8hVIO3IkTbHwho1nN8P79kGhdK7k=;
        h=Date:To:From:Subject:From;
        b=Ulk3m4W5poEE3/cRDz207PeYeJkZTgGREzQtA5GoqkhCd+TFIZmVvFJr4YewGrZI2
         fm9sWzyBfwtGUx/NaFt9wB7xKaX1VNEKQYov3EvtcuWnv6hxMb8LoORMPk2qyN/pRO
         J6Nutnh1YiP9phaAk8OVDvuRiD6zhWrdszKq6Ods=
Date:   Fri, 09 Jun 2023 16:29:46 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-sections-for-advanced-features-of-damos.patch removed from -mm tree
Message-Id: <20230609232947.70828C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: add sections for advanced features of DAMOS
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-sections-for-advanced-features-of-damos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add sections for advanced features of DAMOS
Date: Thu, 25 May 2023 21:43:12 +0000

Add sections for advanced features of DAMOS including quotas,
prioritization, watermarks, and filters of DAMOS on the design document.

Link: https://lkml.kernel.org/r/20230525214314.5204-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   86 ++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-sections-for-advanced-features-of-damos
+++ a/Documentation/mm/damon/design.rst
@@ -272,3 +272,89 @@ the access frequency, and the age.  User
 interest by setting minimum and maximum values of the three properties.  If a
 region's three properties are in the ranges, DAMOS classifies it as one of the
 regions that the scheme is having an interest in.
+
+
+Quotas
+~~~~~~
+
+DAMOS upper-bound overhead control feature.  DAMOS could incur high overhead if
+the target access pattern is not properly tuned.  For example, if a huge memory
+region having the access pattern of interest is found, applying the scheme's
+action to all pages of the huge region could consume unacceptably large system
+resources.  Preventing such issues by tuning the access pattern could be
+challenging, especially if the access patterns of the workloads are highly
+dynamic.
+
+To mitigate that situation, DAMOS provides an upper-bound overhead control
+feature called quotas.  It lets users specify an upper limit of time that DAMOS
+can use for applying the action, and/or a maximum bytes of memory regions that
+the action can be applied within a user-specified time duration.
+
+
+Prioritization
+^^^^^^^^^^^^^^
+
+A mechanism for making a good decision under the quotas.  When the action
+cannot be applied to all regions of interest due to the quotas, DAMOS
+prioritizes regions and applies the action to only regions having high enough
+priorities so that it will not exceed the quotas.
+
+The prioritization mechanism should be different for each action.  For example,
+rarely accessed (colder) memory regions would be prioritized for page-out
+scheme action.  In contrast, the colder regions would be deprioritized for huge
+page collapse scheme action.  Hence, the prioritization mechanisms for each
+action are implemented in each DAMON operations set, together with the actions.
+
+Though the implementation is up to the DAMON operations set, it would be common
+to calculate the priority using the access pattern properties of the regions.
+Some users would want the mechanisms to be personalized for their specific
+case.  For example, some users would want the mechanism to weigh the recency
+(``age``) more than the access frequency (``nr_accesses``).  DAMOS allows users
+to specify the weight of each access pattern property and passes the
+information to the underlying mechanism.  Nevertheless, how and even whether
+the weight will be respected are up to the underlying prioritization mechanism
+implementation.
+
+
+Watermarks
+~~~~~~~~~~
+
+Conditional DAMOS (de)activation automation.  Users might want DAMOS to run
+only under certain situations.  For example, when a sufficient amount of free
+memory is guaranteed, running a scheme for proactive reclamation would only
+consume unnecessary system resources.  To avoid such consumption, the user would
+need to manually monitor some metrics such as free memory ratio, and turn
+DAMON/DAMOS on or off.
+
+DAMOS allows users to offload such works using three watermarks.  It allows the
+users to configure the metric of their interest, and three watermark values,
+namely high, middle, and low.  If the value of the metric becomes above the
+high watermark or below the low watermark, the scheme is deactivated.  If the
+metric becomes below the mid watermark but above the low watermark, the scheme
+is activated.  If all schemes are deactivated by the watermarks, the monitoring
+is also deactivated.  In this case, the DAMON worker thread only periodically
+checks the watermarks and therefore incurs nearly zero overhead.
+
+
+Filters
+~~~~~~~
+
+Non-access pattern-based target memory regions filtering.  If users run
+self-written programs or have good profiling tools, they could know something
+more than the kernel, such as future access patterns or some special
+requirements for specific types of memory. For example, some users may know
+only anonymous pages can impact their program's performance.  They can also
+have a list of latency-critical processes.
+
+To let users optimize DAMOS schemes with such special knowledge, DAMOS provides
+a feature called DAMOS filters.  The feature allows users to set an arbitrary
+number of filters for each scheme.  Each filter specifies the type of target
+memory, and whether it should exclude the memory of the type (filter-out), or
+all except the memory of the type (filter-in).
+
+As of this writing, anonymous page type and memory cgroup type are supported by
+the feature.  Some filter target types can require additional arguments.  For
+example, the memory cgroup filter type asks users to specify the file path of
+the memory cgroup for the filter.  Hence, users can apply specific schemes to
+only anonymous pages, non-anonymous pages, pages of specific cgroups, all pages
+excluding those of specific cgroups, and any combination of those.
_

Patches currently in -mm which might be from sj@kernel.org are


