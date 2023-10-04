Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EB0E7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244027AbjJDUSd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244024AbjJDUS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6004CCE
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B7AC433C7;
        Wed,  4 Oct 2023 20:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450702;
        bh=1/j3ZbCXr37IE9rXQohzZYE8hO44bv6n734bZcXlhrk=;
        h=Date:To:From:Subject:From;
        b=WA9xy7KbykhrwXM0WeED1Gwn8sz+InnvMV1cNlCvn2Qk+zsepl90eSTt4AGioMo11
         4UolL0NHL8FQ5lXbZmDuwKl6m6S8tsWDdkCkWob7lMEQnhz1kN3jlC9k1epBqRCXCO
         zW31v/eedWykwIbc5MG5iD/QrB43wySuyb9PLlA8=
Date:   Wed, 04 Oct 2023 13:18:20 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch removed from -mm tree
Message-Id: <20231004201821.C4B7AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: explain the format of damon_aggregate tracepoint
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: explain the format of damon_aggregate tracepoint
Date: Thu, 7 Sep 2023 02:29:23 +0000

The example of the section for damon_aggregated tracepoint is not
explaining how the output looks like, and how it can be interpreted.
Add it.

Link: https://lkml.kernel.org/r/20230907022929.91361-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   14 ++++++++++++++
 Documentation/mm/damon/design.rst            |    4 ++++
 2 files changed, 18 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -513,6 +513,20 @@ results using tracepoint supporting tool
     # kill 9 $(pidof perf)
     # echo off > monitor_on
     # perf script
+    kdamond.0 46568 [027] 79357.842179: damon:damon_aggregated: target_id=0 nr_regions=11 122509119488-135708762112: 0 864
+    [...]
+
+Each line of the perf script output represents each monitoring region.  The
+first five fields are as usual other tracepoint outputs.  The sixth field
+(``target_id=X``) shows the ide of the monitoring target of the region.  The
+seventh field (``nr_regions=X``) shows the total number of monitoring regions
+for the target.  The eighth field (``X-Y:``) shows the start (``X``) and end
+(``Y``) addresses of the region in bytes.  The ninth field (``X``) shows the
+``nr_accesses`` of the region (refer to
+:ref:`design <damon_design_region_based_sampling>` for more details of the
+counter).  Finally the tenth field (``X``) shows the ``age`` of the region
+(refer to :ref:`design <damon_design_age_tracking>` for more details of the
+counter).
 
 .. _debugfs_interface:
 
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint
+++ a/Documentation/mm/damon/design.rst
@@ -154,6 +154,8 @@ The monitoring overhead of this mechanis
 size of the target workload grows.
 
 
+.. _damon_design_region_based_sampling:
+
 Region Based Sampling
 ~~~~~~~~~~~~~~~~~~~~~
 
@@ -191,6 +193,8 @@ In this way, DAMON provides its best-eff
 keeping the bounds users set for their trade-off.
 
 
+.. _damon_design_age_tracking:
+
 Age Tracking
 ~~~~~~~~~~~~
 
_

Patches currently in -mm which might be from sj@kernel.org are


