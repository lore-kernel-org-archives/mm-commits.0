Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5F5C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiANWKf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33162 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiANWKf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26EFEB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E03C36AEC;
        Fri, 14 Jan 2022 22:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198233;
        bh=BwaypfJBGN7aih/LesEouJ+/BAb2lC33TQCh8P5CKoo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wmzgu228bQvN9EfQIPJQJlfn9xiNcugYrZir/OnWKlYp8mNNqHPZOrpXHo9Nc/Uht
         +TJsM+Eu4Eb77KDDMeN1ylVTwrdZNLwcku3teeO8YBh410U/vrav5g46g9TBE9ROob
         DMx0MRY08327gWHUSLFCk+3dIQc37/d4geSLvXm0=
Date:   Fri, 14 Jan 2022 14:10:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 140/146] Docs/admin-guide/mm/damon/usage: update
 for schemes statistics
Message-ID: <20220114221032.36H2uejCs%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
