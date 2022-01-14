Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3B1C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiANWKa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiANWKa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F90C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:10:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D46DCE2497
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43CFC36AE5;
        Fri, 14 Jan 2022 22:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198227;
        bh=+Liij4OSwUtj1wepAGX3ZoZnxl68z6mZqipSVj0FaI0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YsMNIwKowDHDrfcRGFZEs0nLwy95ZEpipbXDUTpImAobT7tJxPzm3HS22oi7bF9Te
         awHwYcuCKMGHbFEcKd/adYlqSAuF2Ir9zA6RtlQwu0XzsHC5GY0M2vN8oPiJkqjTS+
         DxHWMkJBru3F0X/FiJ0N8v3X1OUPI/SPtqEdxsD8=
Date:   Fri, 14 Jan 2022 14:10:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 138/146] Docs/admin-guide/mm/damon/reclaim:
 document statistics parameters
Message-ID: <20220114221026.JpjZy9r0m%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/reclaim: document statistics parameters

This commit adds descriptions for the DAMON_RECLAIM statistics parameters.

Link: https://lkml.kernel.org/r/20211210150016.35349-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |   25 +++++++++++++++
 1 file changed, 25 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-document-statistics-parameters
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -208,6 +208,31 @@ PID of the DAMON thread.
 If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.  Else,
 -1.
 
+nr_reclaim_tried_regions
+------------------------
+
+Number of memory regions that tried to be reclaimed by DAMON_RECLAIM.
+
+bytes_reclaim_tried_regions
+---------------------------
+
+Total bytes of memory regions that tried to be reclaimed by DAMON_RECLAIM.
+
+nr_reclaimed_regions
+--------------------
+
+Number of memory regions that successfully be reclaimed by DAMON_RECLAIM.
+
+bytes_reclaimed_regions
+-----------------------
+
+Total bytes of memory regions that successfully be reclaimed by DAMON_RECLAIM.
+
+nr_quota_exceeds
+----------------
+
+Number of times that the time/space quota limits have exceeded.
+
 Example
 =======
 
_
