Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04BEEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjFSX1c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjFSXZv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98FF1BD7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DCB760FC5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC7CC433C8;
        Mon, 19 Jun 2023 23:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217016;
        bh=u9vLJNcOnYTK2muVp4dukzW2PcwGH2TWN/BmUy3orxA=;
        h=Date:To:From:Subject:From;
        b=KTmgZJBXuGMeYnnEXBgzA+9uF//uscPn6GyNpHQvnytQUsU6LKrRmhWF3G885/G+4
         4Z4ufD4qA81cMZFmHvl5VgGOtnf/wtwzhHeeb2jcxI39Xgtwox78YX85gCy62rV+qT
         zyg89zafZx6w1JDWdT+6NDHyKsuesj+/5ixXqN3k=
Date:   Mon, 19 Jun 2023 16:23:36 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-the-ways-for-getting-monitoring-results.patch removed from -mm tree
Message-Id: <20230619232336.AEC7CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update the ways for getting monitoring results
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-the-ways-for-getting-monitoring-results.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


