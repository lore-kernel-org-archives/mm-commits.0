Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC74C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjBCGnx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbjBCGmN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4542313A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46CC5CE2EC6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849DEC4339C;
        Fri,  3 Feb 2023 06:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406306;
        bh=I4rFp3cF6fHgVrEWypo145gJAi3JFYUiRpiTskElUp0=;
        h=Date:To:From:Subject:From;
        b=sUKrUS9Bh3i9e4D4C1xQ6WPBSGF5zH55JQzKgaAmOg8OH4An1I17G3yv8uPvprTrj
         PI74iw9qEt2AJEdjwEIdNAK9vMvJqi20Ey56uyjHiKxPKKaMx+KzMQx9JIpbRqF7DR
         Fg4t6eNATAs/S8uuNVKAtc9qRGPZlgO/gcKAG7Gc=
Date:   Thu, 02 Feb 2023 22:38:25 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-finish-scanning-the-current-pageblock-if-requested.patch removed from -mm tree
Message-Id: <20230203063826.849DEC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, compaction: finish scanning the current pageblock if requested
has been removed from the -mm tree.  Its filename was
     mm-compaction-finish-scanning-the-current-pageblock-if-requested.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, compaction: finish scanning the current pageblock if requested
Date: Wed, 25 Jan 2023 13:44:33 +0000

cc->finish_pageblock is set when the current pageblock should be rescanned
but fast_find_migrateblock can select an alternative block.  Disable
fast_find_migrateblock when the current pageblock scan should be
completed.

Link: https://lkml.kernel.org/r/20230125134434.18017-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-finish-scanning-the-current-pageblock-if-requested
+++ a/mm/compaction.c
@@ -1762,6 +1762,13 @@ static unsigned long fast_find_migratebl
 		return pfn;
 
 	/*
+	 * If the pageblock should be finished then do not select a different
+	 * pageblock.
+	 */
+	if (cc->finish_pageblock)
+		return pfn;
+
+	/*
 	 * If the migrate_pfn is not at the start of a zone or the start
 	 * of a pageblock then assume this is a continuation of a previous
 	 * scan restarted due to COMPACT_CLUSTER_MAX.
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


