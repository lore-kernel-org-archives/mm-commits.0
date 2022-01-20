Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18229C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347943AbiATV24 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59122 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347624AbiATV24 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA358B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94023C340E0;
        Thu, 20 Jan 2022 21:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714133;
        bh=1vkLifyLYyf+hu8BPjVO0D/vuiFXhPFn8BuD8hSeQ08=;
        h=Date:From:To:Subject:From;
        b=oh+ckAXPWUzak+QGzYWbQ9uq0lcMqTJQCevZ/biK6MI0fJN72bGkFkFLdjuGQDVsz
         MLy4oomym0+i2f3qMiwvagzjT1dXMCD4b3j2uQsKjJHCPl1wQEFkOKhJ5l4dvEb+Zm
         uZLFuoK4/wTBt2705P5pBthwYlN3av+EpqQXrS34=
Date:   Thu, 20 Jan 2022 13:28:53 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch
 removed from -mm tree
Message-ID: <20220120212853.TLm-Xp-mL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: document statistics parameters
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are


