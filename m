Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F5BEB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 22:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbjFPWGu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbjFPWGo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 18:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D2A35A6
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 15:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 913FB6259A
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 22:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB33CC433C0;
        Fri, 16 Jun 2023 22:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686953201;
        bh=75PGoUn97cgDf6cLowqN60ecdhkVa0YVe4f1x/uvNuU=;
        h=Date:To:From:Subject:From;
        b=x61wgQA8kjlTh0QDLiICSzTl04PN5r2211xHjymBroAuW+cXaw8Q9PISZdO9Z4t1A
         4ibbCxTPHAW9AN61/jUU1ewDjk6hV6imnjWPqV0sLp6Pvkj8nvyczq2JZI/aYC0rDh
         /iSzY56USrl+glO7M99ADTmERTLXyfBoSirig8uk=
Date:   Fri, 16 Jun 2023 15:06:40 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-age-of-region.patch added to mm-unstable branch
Message-Id: <20230616220640.EB33CC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: document 'age' of region
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-age-of-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-age-of-region.patch

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

mm-damon-core-test-add-a-test-for-damon_set_attrs.patch
docs-mm-damon-design-document-age-of-region.patch
docs-admin-guide-mm-damon-start-update-damos-example-command.patch
docs-admin-guide-mm-damon-usage-fix-typos-in-references-and-commas.patch
docs-admin-guide-mm-damon-usage-remove-unnecessary-sentences-about-supported-address-spaces.patch
docs-admin-guide-mm-damon-usage-link-design-document-for-damos.patch
docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface.patch
docs-admin-guide-mm-damon-usage-update-the-ways-for-getting-monitoring-results.patch

