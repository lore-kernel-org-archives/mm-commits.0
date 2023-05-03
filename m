Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E5FC7EE24
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjECAYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjECAX6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3273B35A4
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 17:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAC2661934
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 00:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5163BC433EF;
        Wed,  3 May 2023 00:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073436;
        bh=SrI3BaENEpvNfHsbqkuseGq9XCOSZPxVV6gW3ydz65w=;
        h=Date:To:From:Subject:From;
        b=1zNYmtpbBqd1LMqnjlp/ORyl6yiyoUDjWzaATdqDK37hovmFJj9aBwyKF2w63w7PE
         JB4SJI32hv7rOqMCIJwD29vikR3YcMoXdKa0j3yHwdB4CAm7yYpbO+wLZDUTE2pW8v
         9OZPX7wN6PnCVNHiagmQaq4Og0TNY3xoyUMimlB0=
Date:   Tue, 02 May 2023 17:23:55 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, lstoakes@gmail.com,
        david@redhat.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-change-per-vma-lock-statistics-to-be-disabled-by-default.patch removed from -mm tree
Message-Id: <20230503002356.5163BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change per-VMA lock statistics to be disabled by default
has been removed from the -mm tree.  Its filename was
     mm-change-per-vma-lock-statistics-to-be-disabled-by-default.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: change per-VMA lock statistics to be disabled by default
Date: Fri, 28 Apr 2023 10:35:33 -0700

Change CONFIG_PER_VMA_LOCK_STATS to be disabled by default, as most users
don't need it.  Add configuration help to clarify its usage.

Link: https://lkml.kernel.org/r/20230428173533.18158-1-surenb@google.com
Fixes: 52f238653e45 ("mm: introduce per-VMA lock statistics")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/Kconfig.debug~mm-change-per-vma-lock-statistics-to-be-disabled-by-default
+++ a/mm/Kconfig.debug
@@ -274,6 +274,12 @@ config DEBUG_KMEMLEAK_AUTO_SCAN
 config PER_VMA_LOCK_STATS
 	bool "Statistics for per-vma locks"
 	depends on PER_VMA_LOCK
-	default y
 	help
-	  Statistics for per-vma locks.
+	  Say Y here to enable success, retry and failure counters of page
+	  faults handled under protection of per-vma locks. When enabled, the
+	  counters are exposed in /proc/vmstat. This information is useful for
+	  kernel developers to evaluate effectiveness of per-vma locks and to
+	  identify pathological cases. Counting these events introduces a small
+	  overhead in the page fault path.
+
+	  If in doubt, say N.
_

Patches currently in -mm which might be from surenb@google.com are


