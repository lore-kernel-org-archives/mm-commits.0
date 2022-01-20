Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4D2C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377898AbiATV3A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59154 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347624AbiATV3A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1A62B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D11BC340E0;
        Thu, 20 Jan 2022 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714137;
        bh=4nmGbAWBb9I6ZhyPbCH2JL0WyFHtxX3hGVKOI4tMaPY=;
        h=Date:From:To:Subject:From;
        b=X8MkyZacxkNi/StVMc2kLFhptLl5NK5jWvKN/Fqp8z44C//uoIjz7cOuqjO0N7LKS
         O55kzEJr7YAcZa+vBYmiumvwmL2lzmTosUqGMhLtQLZ69Idq941rHe/eJh7vMZhjYv
         4lfstoCLXK5CkVVqwklU2F6iwT50HGbjT9K80RkQ=
Date:   Thu, 20 Jan 2022 13:28:57 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch removed
 from -mm tree
Message-ID: <20220120212857.LT3v-4Mfp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for schemes statistics
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for schemes statistics

This commit updates DAMON debugfs interface for statistics of schemes
successfully applied regions and time/space quota limit exceeds counts.

Link: https://lkml.kernel.org/r/20211210150016.35349-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-schemes-statistics
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -223,12 +223,13 @@ is activated.
 Statistics
 ~~~~~~~~~~
 
-It also counts the total number and bytes of regions that each scheme is
-applied.  This statistics can be used for online analysis or tuning of the
-schemes.
+It also counts the total number and bytes of regions that each scheme is tried
+to be applied, the two numbers for the regions that each scheme is successfully
+applied, and the total number of the quota limit exceeds.  This statistics can
+be used for online analysis or tuning of the schemes.
 
 The statistics can be shown by reading the ``schemes`` file.  Reading the file
-will show each scheme you entered in each line, and the two numbers for the
+will show each scheme you entered in each line, and the five numbers for the
 statistics will be added at the end of each line.
 
 Example
_

Patches currently in -mm which might be from sj@kernel.org are


