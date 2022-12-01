Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C954C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiLAAAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiLAAAX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DD358BC0
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6CC361E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3923AC433B5;
        Thu,  1 Dec 2022 00:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852818;
        bh=5gD6YkLwP6f21pttyHTRiaRGRqxzNANKKxU1YXifqQk=;
        h=Date:To:From:Subject:From;
        b=OwJnqBryjdJpES3AYkBCeuiy1dAtUqGR0rB4D6XvmUQ31dFGESY3UsB6ZjgIcuG2r
         W5x9CokoEWv/HTv/mG3kIH4xU7BDyRxNkJhXoneBLCWayTvtXkWeB6e3OckiBp/NE+
         fc+ALTdICUboTTKlZgsH35Z6v/s4jHGnPL1aKeRQ=
Date:   Wed, 30 Nov 2022 16:00:17 -0800
To:     mm-commits@vger.kernel.org, vpetrucci@gmail.com, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch removed from -mm tree
Message-Id: <20221201000018.3923AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix wrong usage example of init_regions file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix wrong usage example of init_regions file
Date: Mon, 24 Oct 2022 17:46:19 +0000

DAMON debugfs interface assumes the users will write all inputs at once. 
However, redirecting a string of multiple lines sometimes end up writing
line by line.  Therefore, the example usage of 'init_regions' file, which
writes input as a string of multiple lines can fail.  Fix it to use a
single line string instead.  Also update the description of the usage to
not assume users will write inputs in multiple lines.

Link: https://lkml.kernel.org/r/20221024174619.15600-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vinicius Petrucci <vpetrucci@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -468,8 +468,9 @@ regions in case of physical memory monit
 monitoring target regions by themselves.
 
 In such cases, users can explicitly set the initial monitoring target regions
-as they want, by writing proper values to the ``init_regions`` file.  Each line
-of the input should represent one region in below form.::
+as they want, by writing proper values to the ``init_regions`` file.  The input
+should be a sequence of three integers separated by white spaces that represent
+one region in below form.::
 
     <target idx> <start address> <end address>
 
@@ -484,9 +485,9 @@ ranges, ``20-40`` and ``50-100`` as that
     # cd <debugfs>/damon
     # cat target_ids
     42 4242
-    # echo "0   1       100
-            0   100     200
-            1   20      40
+    # echo "0   1       100 \
+            0   100     200 \
+            1   20      40  \
             1   50      100" > init_regions
 
 Note that this sets the initial monitoring target regions only.  In case of
_

Patches currently in -mm which might be from sj@kernel.org are


