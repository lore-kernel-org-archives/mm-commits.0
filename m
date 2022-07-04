Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E48C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiGDBKi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiGDBKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8783F631E
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E2E7B803F6
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBEAC341C6;
        Mon,  4 Jul 2022 01:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896999;
        bh=cNAgQ+jYOQMFVEeZw396mN4JlgE7cWn/ZP3BEckn9y0=;
        h=Date:To:From:Subject:From;
        b=wL5Jn8X0/HPzVAc78Yt+pFV5hK2QJGMUfseZE9j+nhiF+y1nGTtROuRrkzXU5G3Gp
         aTBWnZmu1E/NiZrpLa5Do9Nas/9496iGBW3NqXC4sSYy1A2FmkH5qqbf5SlGBrp937
         l3A8/ylxoYSNaKBCVn3bwBGrT/8xmbnRhrOy4D6M=
Date:   Sun, 03 Jul 2022 18:09:58 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch removed from -mm tree
Message-Id: <20220704010958.DFBEAC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/damon/sysfs: document 'LRU_PRIO' scheme action
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/damon/sysfs: document 'LRU_PRIO' scheme action
Date: Mon, 13 Jun 2022 19:22:57 +0000

This commit documents the 'lru_prio' scheme action for DAMON sysfs
interface.

Link: https://lkml.kernel.org/r/20220613192301.8817-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -264,6 +264,7 @@ that can be written to and read from the
  - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
+ - ``lru_prio``: Prioritize the region on its LRU lists.
  - ``stat``: Do nothing but count the statistics
 
 schemes/<N>/access_pattern/
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

