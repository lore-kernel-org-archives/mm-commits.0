Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1FFEB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 22:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343977AbjFPWHI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344628AbjFPWHA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 18:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97163AB5
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 15:06:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B877E629C8
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 22:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168C5C433C0;
        Fri, 16 Jun 2023 22:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686953211;
        bh=zv4Osd81/hCDdlw10G44/yJ3dLJo1LzpMzxjDTGQUZU=;
        h=Date:To:From:Subject:From;
        b=lN8R/KanJtxSqBh12D+sA0vVA7Qj/TgD5WoxPOe823Oek+DTwILht0UF3C55nMh7c
         Ix+bfcDdvt2vihrC4YNr2whVFIvnn65FAKgV8PTQWF5gLXdhXuqL0//ZzINuAxQGnO
         v6IZ3P5pqG5xzA15RIcvzVly3Kui1dOufJ9+9Tqc=
Date:   Fri, 16 Jun 2023 15:06:50 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-the-ways-for-getting-monitoring-results.patch added to mm-unstable branch
Message-Id: <20230616220651.168C5C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update the ways for getting monitoring results
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-the-ways-for-getting-monitoring-results.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-the-ways-for-getting-monitoring-results.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update the ways for getting monitoring results
Date: Fri, 16 Jun 2023 19:17:42 +0000

The recommended ways for getting DAMON monitoring results are using
tried_regions sysfs directory for partial snapshot of the results, and
DAMON tracepoint for full record of the results.  However, the
tried_regions sysfs directory usage has not sufficiently updated on some
sections of the DAMON usage document.  Update those.

Link: https://lkml.kernel.org/r/20230616191742.87531-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   20 ++++++++++-------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-the-ways-for-getting-monitoring-results
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -19,10 +19,7 @@ DAMON provides below interfaces for diff
   features by reading from and writing to special sysfs files.  Therefore,
   you can write and use your personalized DAMON sysfs wrapper programs that
   reads/writes the sysfs files instead of you.  The `DAMON user space tool
-  <https://github.com/awslabs/damo>`_ is one example of such programs.  Note
-  that this interface provides only simple :ref:`statistics <damos_stats>` for
-  the monitoring results.  For detailed monitoring results, DAMON provides a
-  :ref:`tracepoint <tracepoint>`.
+  <https://github.com/awslabs/damo>`_ is one example of such programs.
 - *debugfs interface. (DEPRECATED!)*
   :ref:`This <debugfs_interface>` is almost identical to :ref:`sysfs interface
   <sysfs_interface>`.  This is deprecated, so users should move to the
@@ -421,6 +418,11 @@ The directories will be removed when ano
 ``clear_schemes_tried_regions``, is written to the relevant
 ``kdamonds/<N>/state`` file.
 
+The expected usage of this directory is investigations of schemes' behaviors,
+and query-like efficient data access monitoring results retrievals.  For the
+latter use case, in particular, users can set the ``action`` as ``stat`` and
+set the ``access pattern`` as their interested pattern that they want to query.
+
 tried_regions/<N>/
 ------------------
 
@@ -771,10 +773,12 @@ root directory only.
 Tracepoint for Monitoring Results
 =================================
 
-DAMON provides the monitoring results via a tracepoint,
-``damon:damon_aggregated``.  While the monitoring is turned on, you could
-record the tracepoint events and show results using tracepoint supporting tools
-like ``perf``.  For example::
+Users can get the monitoring results via the :ref:`tried_regions
+<sysfs_schemes_tried_regions>` or a tracepoint, ``damon:damon_aggregated``.
+While the tried regions directory is useful for getting a snapshot, the
+tracepoint is useful for getting a full record of the results.  While the
+monitoring is turned on, you could record the tracepoint events and show
+results using tracepoint supporting tools like ``perf``.  For example::
 
     # echo on > monitor_on
     # perf record -e damon:damon_aggregated &
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

