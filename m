Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAD8C77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 19:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjEBTvj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 15:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEBTvj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 15:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EF11BE5
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 12:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D44E6236B
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 19:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BE6C433EF;
        Tue,  2 May 2023 19:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683057096;
        bh=V3vCa0YO7jJI0Q4Ws30NC7eWaeoViFcaeqaLtgOzTpM=;
        h=Date:To:From:Subject:From;
        b=lgwObrcfAvHY/bzhlUctcDyJ5NTBaeiGOpwhBBXwFzGdDZNrw9Ouu0apPSeZyx7Cb
         Am0I6eoIA/GQnE6tTcZfutlbKpG5DalUjlUPC/aL4aTg5twBu6WQwJ3uo9M9DU7QVn
         LsFdJ+4SUL9/caxaZox4dHp25hpuJ5dU5j1GL73Y=
Date:   Tue, 02 May 2023 12:51:36 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, lstoakes@gmail.com,
        david@redhat.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-per-vma-lock-statistics-to-be-disabled-by-default.patch added to mm-hotfixes-unstable branch
Message-Id: <20230502195136.B5BE6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change per-VMA lock statistics to be disabled by default
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-change-per-vma-lock-statistics-to-be-disabled-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-per-vma-lock-statistics-to-be-disabled-by-default.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-change-per-vma-lock-statistics-to-be-disabled-by-default.patch

