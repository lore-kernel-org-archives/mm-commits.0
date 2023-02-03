Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DA5C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjBCGme (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjBCGkv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137CC8FB62
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D42F61DAA
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1730C4339C;
        Fri,  3 Feb 2023 06:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406270;
        bh=kTY90VoI5Sv/0b3uvmbL8b0fDApK8bo6QLm4S/WjZrM=;
        h=Date:To:From:Subject:From;
        b=HRIoZnneA/rwjm4goHG/0iPyOmtUrGEiPlSyKqwWFW5G+4Uf+OcQebpc7+NeVUnvW
         9zhuaahY1sgHCkK76jbhrwQ1zInieCNlobc5OpF28JoPVyf+4ZE6XpyhobwIiD+57N
         wlycPYfR6ILwcBpmIXfXdWjddW3uHDiKFKBelQro=
Date:   Thu, 02 Feb 2023 22:37:49 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mgorman@suse.de,
        david@redhat.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-repalce-with-deferred_pages_enabled-wherever-applicable.patch removed from -mm tree
Message-Id: <20230203063749.F1730C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: use deferred_pages_enabled() wherever applicable
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-repalce-with-deferred_pages_enabled-wherever-applicable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/page_alloc: use deferred_pages_enabled() wherever applicable
Date: Thu, 5 Jan 2023 13:55:06 +0530

Instead of directly accessing static deferred_pages, replace such
instances with the helper deferred_pages_enabled().  No functional change
is intended.

Link: https://lkml.kernel.org/r/20230105082506.241529-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-page_alloc-repalce-with-deferred_pages_enabled-wherever-applicable
+++ a/mm/page_alloc.c
@@ -4288,7 +4288,7 @@ retry:
 			 * Watermark failed for this zone, but see if we can
 			 * grow this zone if it contains deferred pages.
 			 */
-			if (static_branch_unlikely(&deferred_pages)) {
+			if (deferred_pages_enabled()) {
 				if (_deferred_grow_zone(zone, order))
 					goto try_this_zone;
 			}
@@ -4337,7 +4337,7 @@ try_this_zone:
 		} else {
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 			/* Try again if zone has deferred pages */
-			if (static_branch_unlikely(&deferred_pages)) {
+			if (deferred_pages_enabled()) {
 				if (_deferred_grow_zone(zone, order))
 					goto try_this_zone;
 			}
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


