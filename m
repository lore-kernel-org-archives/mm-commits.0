Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B77C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjBCGfa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjBCGfW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9489C1C591
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25B5461D9B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78578C433D2;
        Fri,  3 Feb 2023 06:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406119;
        bh=LKURxQNGsmyakhTnQwfLNeQSuBPF2wO/v+F6skd2hwE=;
        h=Date:To:From:Subject:From;
        b=KSGeyxKseRZ+HpmzvKSDiSo7y6e8BRFROMbkjzNNBrIDq5tYvbCn+A5Q1YedraHWf
         GG/IecWlUl5Zc6kngljpKzhLYap5omgQLWkZYByewSQ8YD0XMGckKCEGDqFi/78Jh2
         /kPGrxwroeeUwEm50OhSUkznHhZZXpsuezyMLtCU=
Date:   Thu, 02 Feb 2023 22:35:18 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch removed from -mm tree
Message-Id: <20230203063519.78578C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update DAMOS actions/filters supports of each DAMON operations set
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update DAMOS actions/filters supports of each DAMON operations set
Date: Tue, 10 Jan 2023 19:03:56 +0000

Supports of each DAMOS action and filters are up to DAMON operations set
implementation, but it's not mentioned in detail on the documentation. 
Update the information on the usage document.

Link: https://lkml.kernel.org/r/20230110190400.119388-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -279,14 +279,25 @@ The ``action`` file is for setting and g
 memory regions having specific access pattern of the interest.  The keywords
 that can be written to and read from the file and their meaning are as below.
 
- - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``
- - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``
- - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``
- - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
- - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
+Note that support of each action depends on the running DAMON operations set
+`implementation <sysfs_contexts>`.
+
+ - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
+   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
+ - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
  - ``lru_prio``: Prioritize the region on its LRU lists.
+   Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
- - ``stat``: Do nothing but count the statistics
+   Supported by ``paddr`` operations set.
+ - ``stat``: Do nothing but count the statistics.
+   Supported by all operations sets.
 
 schemes/<N>/access_pattern/
 ---------------------------
@@ -388,8 +399,8 @@ pages of all memory cgroups except ``/ha
     echo /having_care_already > 1/memcg_path
     echo N > 1/matching
 
-Note that filters could be ignored depend on the running DAMON operations set
-`implementation <sysfs_contexts>`.
+Note that filters are currently supported only when ``paddr``
+`implementation <sysfs_contexts>` is being used.
 
 .. _sysfs_schemes_stats:
 
@@ -618,11 +629,15 @@ The ``<action>`` is a predefined integer
 DAMON will apply to the regions having the target access pattern.  The
 supported numbers and their meanings are as below.
 
- - 0: Call ``madvise()`` for the region with ``MADV_WILLNEED``
- - 1: Call ``madvise()`` for the region with ``MADV_COLD``
- - 2: Call ``madvise()`` for the region with ``MADV_PAGEOUT``
- - 3: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
- - 4: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
+ - 0: Call ``madvise()`` for the region with ``MADV_WILLNEED``.  Ignored if
+   ``target`` is ``paddr``.
+ - 1: Call ``madvise()`` for the region with ``MADV_COLD``.  Ignored if
+   ``target`` is ``paddr``.
+ - 2: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
+ - 3: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.  Ignored if
+   ``target`` is ``paddr``.
+ - 4: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.  Ignored if
+   ``target`` is ``paddr``.
  - 5: Do nothing but count the statistics
 
 Quota
_

Patches currently in -mm which might be from sj@kernel.org are

scripts-spelling-add-a-few-more-typos.patch

