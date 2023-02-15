Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86876C636D4
	for <mm-commits@archiver.kernel.org>; Wed, 15 Feb 2023 23:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjBOXag (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Feb 2023 18:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOXaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2023 18:30:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F6743457
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 15:30:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B1D0B8225F
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 23:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CECAC433EF;
        Wed, 15 Feb 2023 23:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676503832;
        bh=BpEQ+bSrY/MiSJ3v6gCQqF3JlB22deaOkpV6FJwkiVA=;
        h=Date:To:From:Subject:From;
        b=hbQ10KBT2nW4FfN4YBTwpdrHZPtcBxsadd/kLVBLXJ1/rU5Qv94Ui/ocoIUI2g4DB
         u3dwomBlgoBjIwTDqD3ysdQ8lv/0K9yPgmbsvqQ4HXFn13ZRFXFKL909+qgjbt6awn
         rHoPRU4f/XN9OhgUs2yWOWstKwnww4zXc2rU6vaE=
Date:   Wed, 15 Feb 2023 15:30:31 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-return-nothing-from-do_migrate_range.patch added to mm-unstable branch
Message-Id: <20230215233032.0CECAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: return nothing from do_migrate_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-return-nothing-from-do_migrate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-return-nothing-from-do_migrate_range.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/memory_hotplug: return nothing from do_migrate_range()
Date: Wed, 15 Feb 2023 23:02:59 +0000

Patch series "mm/memory_hotplug: cleanup do_migrate_range()".

Make do_migrate_range() return value mechanism simple.


This patch (of 2):

Return value mechanism of do_migrate_range() is not very simple, while
no caller of the function checks the return value.  Make the function
return nothing to be more simple.

Link: https://lkml.kernel.org/r/20230215230300.61125-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230215230300.61125-2-sj@kernel.org
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-return-nothing-from-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1620,8 +1620,7 @@ found:
 	return 0;
 }
 
-static int
-do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
+static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
 	struct page *page, *head;
@@ -1721,8 +1720,6 @@ do_migrate_range(unsigned long start_pfn
 			putback_movable_pages(&source);
 		}
 	}
-
-	return ret;
 }
 
 static int __init cmdline_parse_movable_node(char *p)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-memory_hotplug-return-nothing-from-do_migrate_range.patch
mm-memory_hotplug-cleanup-ret-variable-usage-in-do_migrate_range.patch

