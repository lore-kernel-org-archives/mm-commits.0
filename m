Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516BAC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjBCGfb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjBCGfX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DDB4FAD7
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D6861DA6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A11C433EF;
        Fri,  3 Feb 2023 06:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406120;
        bh=XZ0AYv0F9oFZ8VtcgEJld4tSeUj4y35OJYTUzvPejag=;
        h=Date:To:From:Subject:From;
        b=vg+vs0Th/5DOAaBhQXd5QbywWUAK83w/yuv3nJw/W9Xd/6DudLlvc30xYNeeOovZa
         bwfzm9Aj8Ta1Vj1qZRsN9b19U2SxctfPMcwDs+OUl/J7S58wfO5fichuLAdggswixG
         ex1j2FhGUDFL1tsp61TtvdNXuHxfexLimBriB0IY=
Date:   Thu, 02 Feb 2023 22:35:19 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-add-a-maintainer-profile-for-damon.patch removed from -mm tree
Message-Id: <20230203063520.73A11C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon: add a maintainer-profile for DAMON
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-add-a-maintainer-profile-for-damon.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon: add a maintainer-profile for DAMON
Date: Tue, 10 Jan 2023 19:03:57 +0000

Document the basic policies and expectations for DAMON development.

Link: https://lkml.kernel.org/r/20230110190400.119388-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/damon/index.rst~docs-mm-damon-add-a-maintainer-profile-for-damon
+++ a/Documentation/mm/damon/index.rst
@@ -32,3 +32,4 @@ operations with no code but simple confi
    faq
    design
    api
+   maintainer-profile
--- /dev/null
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -0,0 +1,62 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+DAMON Maintainer Entry Profile
+==============================
+
+The DAMON subsystem covers the files that listed in 'DATA ACCESS MONITOR'
+section of 'MAINTAINERS' file.
+
+The mailing lists for the subsystem are damon@lists.linux.dev and
+linux-mm@kvack.org.  Patches should be made against the mm-unstable tree [1]_
+whenever possible and posted to the mailing lists.
+
+SCM Trees
+---------
+
+There are multiple Linux trees for DAMON development.  Patches under
+development or testing are queued in damon/next [2]_ by the DAMON maintainer.
+Suffieicntly reviewed patches will be queued in mm-unstable [1]_ by the memory
+management subsystem maintainer.  After more sufficient tests, the patches will
+be queued in mm-stable [3]_ , and finally pull-requested to the mainline by the
+memory management subsystem maintainer.
+
+Note again the patches for review should be made against the mm-unstable
+tree[1] whenever possible.  damon/next is only for preview of others' works in
+progress.
+
+Submit checklist addendum
+-------------------------
+
+When making DAMON changes, you should do below.
+
+- Build changes related outputs including kernel and documents.
+- Ensure the builds introduce no new errors or warnings.
+- Run and ensure no new failures for DAMON selftests [4]_ and kunittests [5]_ .
+
+Further doing below and putting the results will be helpful.
+
+- Run damon-tests/corr [6]_ for normal changes.
+- Run damon-tests/perf [7]_ for performance changes.
+
+Key cycle dates
+---------------
+
+Patches can be sent anytime.  Key cycle dates of the mm-unstable[1] and
+mm-stable[3] trees depend on the memory management subsystem maintainer.
+
+Review cadence
+--------------
+
+The DAMON maintainer does the work on the usual work hour (09:00 to 17:00,
+Mon-Fri) in PST.  The response to patches will occasionally be slow.  Do not
+hesitate to send a ping if you have not heard back within a week of sending a
+patch.
+
+
+.. [1] https://git.kernel.org/akpm/mm/h/mm-unstable
+.. [2] https://git.kernel.org/sj/h/damon/next
+.. [3] https://git.kernel.org/akpm/mm/h/mm-stable
+.. [4] https://github.com/awslabs/damon-tests/blob/master/corr/run.sh#L49
+.. [5] https://github.com/awslabs/damon-tests/blob/master/corr/tests/kunit.sh
+.. [6] https://github.com/awslabs/damon-tests/tree/master/corr
+.. [7] https://github.com/awslabs/damon-tests/tree/master/perf
_

Patches currently in -mm which might be from sj@kernel.org are

scripts-spelling-add-a-few-more-typos.patch

