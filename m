Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888DDEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjFSX13 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjFSXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2618C10D7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74F1760FBF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB96C433C0;
        Mon, 19 Jun 2023 23:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217010;
        bh=ZsPj0LJdCHJBXuGXq4C3DgjLY0pMYahUtNPwUB7bXvg=;
        h=Date:To:From:Subject:From;
        b=GJuaFOtJdwZ9jo7NNyHahwNL8lBCw3w8m27NrQ+OjQSRCUUN7gizRO015QpM176/e
         tizU1Di+p6r9C35jXu0+Y1IIjBAE60d9GRBN3EtNP7ljCX8F/3NLkwhA5PywQhNtSL
         Kj9f4lRkYOlKXsRYGQY7zFsB3wVkjDMr/ycc3dDw=
Date:   Mon, 19 Jun 2023 16:23:30 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-age-of-region.patch removed from -mm tree
Message-Id: <20230619232330.CEB96C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: document 'age' of region
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-age-of-region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document 'age' of region
Date: Fri, 16 Jun 2023 19:17:36 +0000

Patch series "Docs/{mm,admin-guide}damon: update design and usage docs".

Update DAMON design and usage documents for outdated and unnecessarily
duplicated parts.


This patch (of 7):

The 'age' of each region in DAMON monitoring results is an important
concept for both monitoring part and DAMOS.  And DAMOS section of the
design document is mentioning it.  However, the age itself is not
explained in the document.  Add a section for that.

Link: https://lkml.kernel.org/r/20230616191742.87531-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230616191742.87531-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-age-of-region
+++ a/Documentation/mm/damon/design.rst
@@ -190,6 +190,20 @@ In this way, DAMON provides its best-eff
 keeping the bounds users set for their trade-off.
 
 
+Age Tracking
+~~~~~~~~~~~~
+
+By analyzing the monitoring results, users can also find how long the current
+access pattern of a region has maintained.  That could be used for good
+understanding of the access pattern.  For example, page placement algorithm
+utilizing both the frequency and the recency could be implemented using that.
+To make such access pattern maintained period analysis easier, DAMON maintains
+yet another counter called ``age`` in each region.  For each ``aggregation
+interval``, DAMON checks if the region's size and access frequency
+(``nr_accesses``) has significantly changed.  If so, the counter is reset to
+zero.  Otherwise, the counter is increased.
+
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
_

Patches currently in -mm which might be from sj@kernel.org are


