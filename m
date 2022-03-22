Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9965EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiCVVuv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiCVVuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3335E750
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E09706149C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C1CC340EE;
        Tue, 22 Mar 2022 21:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985759;
        bh=nCid8sVTqW2FafLyabZL96EzaHpXLv8FFjNEEnTHbGg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=MC/ymDRvPoczwIF5EvSzu3FcUhSM5DGyjrZvSsk9zJkkcsO/Sk8s/wRA3eTAOVm5e
         TZ32YmSoxG2f+PfhHuFzCL7YWFddAUVCWP6OgP40Amjz3Rvzqf+r6xU5m40hwDNuco
         7hqwl2QGFoEgD8vv3TQGwfNquY120JY9aQ2tybjw=
Date:   Tue, 22 Mar 2022 14:49:18 -0700
To:     corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 213/227] Docs/damon: update outdated term 'regions update interval'
Message-Id: <20220322214919.48C1CC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: Docs/damon: update outdated term 'regions update interval'

Before DAMON is merged in the mainline, the concept of 'regions update
interval' has generalized to be used as the time interval for update of
any monitoring operations related data structure, but the document has not
updated properly.  This commit updates the document for better
consistency.

Link: https://lkml.kernel.org/r/20220222170100.17068-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    6 +++---
 Documentation/vm/damon/design.rst            |   12 +++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-damon-update-outdated-term-regions-update-interval
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -47,7 +47,7 @@ Attributes
 ----------
 
 Users can get and set the ``sampling interval``, ``aggregation interval``,
-``regions update interval``, and min/max number of monitoring target regions by
+``update interval``, and min/max number of monitoring target regions by
 reading from and writing to the ``attrs`` file.  To know about the monitoring
 attributes in detail, please refer to the :doc:`/vm/damon/design`.  For
 example, below commands set those values to 5 ms, 100 ms, 1,000 ms, 10 and
@@ -128,8 +128,8 @@ ranges, ``20-40`` and ``50-100`` as that
 
 Note that this sets the initial monitoring target regions only.  In case of
 virtual memory monitoring, DAMON will automatically updates the boundary of the
-regions after one ``regions update interval``.  Therefore, users should set the
-``regions update interval`` large enough in this case, if they don't want the
+regions after one ``update interval``.  Therefore, users should set the
+``update interval`` large enough in this case, if they don't want the
 update.
 
 
--- a/Documentation/vm/damon/design.rst~docs-damon-update-outdated-term-regions-update-interval
+++ a/Documentation/vm/damon/design.rst
@@ -95,8 +95,8 @@ Address Space Independent Core Mechanism
 
 Below four sections describe each of the DAMON core mechanisms and the five
 monitoring attributes, ``sampling interval``, ``aggregation interval``,
-``regions update interval``, ``minimum number of regions``, and ``maximum
-number of regions``.
+``update interval``, ``minimum number of regions``, and ``maximum number of
+regions``.
 
 
 Access Frequency Monitoring
@@ -169,6 +169,8 @@ The monitoring target address range coul
 virtual memory could be dynamically mapped and unmapped.  Physical memory could
 be hot-plugged.
 
-As the changes could be quite frequent in some cases, DAMON checks the dynamic
-memory mapping changes and applies it to the abstracted target area only for
-each of a user-specified time interval (``regions update interval``).
+As the changes could be quite frequent in some cases, DAMON allows the
+monitoring operations to check dynamic changes including memory mapping changes
+and applies it to monitoring operations-related data structures such as the
+abstracted monitoring target memory area only for each of a user-specified time
+interval (``update interval``).
_
