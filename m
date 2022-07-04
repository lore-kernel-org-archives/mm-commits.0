Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB69CC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiGDBKq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiGDBKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED376321
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86E7861303
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9A7C341C6;
        Mon,  4 Jul 2022 01:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897000;
        bh=nXtvqkyTTGJo2Sre0XrzjPvqmVSOTsj14t1TxxLdetU=;
        h=Date:To:From:Subject:From;
        b=oV13/WYJHaQP2Qa9NuiWoTh7hOfchFNfPMHcMZ4TAHbOicak7JZa4abysB3OIS5vH
         wLjseLYluAGzTwdjzm9P/ouFlqd8JJSR/HRF6SlK3Vfd+UMFObzowDYQTADG9BADLn
         MQUNeuArVs6HWDFtDhj1ZSuLyycVugHpFiEBcUg8=
Date:   Sun, 03 Jul 2022 18:10:00 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch removed from -mm tree
Message-Id: <20220704011000.DA9A7C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/damon/sysfs: document 'LRU_DEPRIO' scheme action
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/damon/sysfs: document 'LRU_DEPRIO' scheme action
Date: Mon, 13 Jun 2022 19:22:59 +0000

This commit documents the 'LRU_DEPRIO' scheme action for DAMON sysfs
interface.`

Link: https://lkml.kernel.org/r/20220613192301.8817-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -265,6 +265,7 @@ that can be written to and read from the
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
  - ``lru_prio``: Prioritize the region on its LRU lists.
+ - ``lru_deprio``: Deprioritize the region on its LRU lists.
  - ``stat``: Do nothing but count the statistics
 
 schemes/<N>/access_pattern/
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

