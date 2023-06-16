Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CC2EB64D8
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 22:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245310AbjFPWHI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344566AbjFPWHA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 18:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6132685
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 15:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DDF3625CA
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 22:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70564C433C0;
        Fri, 16 Jun 2023 22:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686953209;
        bh=DOAWuSB8V+Awf/hikQH3GQMXXfi3Ire+tCTMnXaixro=;
        h=Date:To:From:Subject:From;
        b=2wFJafgc9CYLfNxtSC5wxCuo3F+neP5Pi9N8IpMUdFPnqljbM4dv8mG+YQQt2AkoS
         q7p39WQ/aRa2ed0tceiGo++7xQt6vgrC5E03PrFp2z4IfFbI3lS2AGM0qCql0C11Vc
         ouhgqDc1/I+enyib8/QOSaLIOwaiH6WEq//9geL4=
Date:   Fri, 16 Jun 2023 15:06:48 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface.patch added to mm-unstable branch
Message-Id: <20230616220649.70564C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: clarify quotas and watermarks sysfs interface
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface.patch

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
Subject: Docs/admin-guide/mm/damon/usage: clarify quotas and watermarks sysfs interface
Date: Fri, 16 Jun 2023 19:17:41 +0000

Explanation of DAMOS quotas and watermarks are not clearly explaining the
meaning and expectation of each file.  Add more clarification for those.

Link: https://lkml.kernel.org/r/20230616191742.87531-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -306,7 +306,8 @@ Under the ``access_pattern`` directory,
 ``nr_accesses``, and ``age``) each having two files (``min`` and ``max``)
 exist.  You can set and get the access pattern for the given scheme by writing
 to and reading from the ``min`` and ``max`` files under ``sz``,
-``nr_accesses``, and ``age`` directories, respectively.
+``nr_accesses``, and ``age`` directories, respectively.  Note that the ``min``
+and the ``max`` form a closed interval.
 
 schemes/<N>/quotas/
 -------------------
@@ -320,7 +321,13 @@ Under ``quotas`` directory, three files
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
-respectively.  You can also set the :ref:`prioritization weights
+respectively.  Then, DAMON tries to use only up to ``time quota`` milliseconds
+for applying the ``action`` to memory regions of the ``access_pattern``, and to
+apply the action to only up to ``bytes`` bytes of memory regions within the
+``reset_interval_ms``.  Setting both ``ms`` and ``bytes`` zero disables the
+quota limits.
+
+You can also set the :ref:`prioritization weights
 <damon_design_damos_quotas_prioritization>` for size, access frequency, and age
 in per-thousand unit by writing the values to the three files under the
 ``weights`` directory.
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

