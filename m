Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2D6C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 18:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiEaSnz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 14:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbiEaSnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 14:43:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043BAB4E
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 11:43:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B604DB8121D
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 18:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693ACC385A9;
        Tue, 31 May 2022 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654022631;
        bh=aUZ60VYY+c/TknyrNqK4fBjke9XwPyZfCYhGnbj6uG4=;
        h=Date:To:From:Subject:From;
        b=yRjVzc//kftMXRE6qbK65F0DwB2ygZ/6lKVeEk2sRtjVtWv3b8r0njegFSyjHbC3m
         ap2X8IqV+vibyiTXHeavKqSDkqZ7Yr0Efdwl29M8zlwFs0G2T30U9IvFyHLEmUpiNF
         9Z3G0AOQBv0Kh1TYpXOB2Df4mkP2wiBmiOcWytps=
Date:   Tue, 31 May 2022 11:43:50 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-drop-reason-argument-from-check_pfn_span.patch added to mm-unstable branch
Message-Id: <20220531184351.693ACC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: drop 'reason' argument from check_pfn_span()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-drop-reason-argument-from-check_pfn_span.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-drop-reason-argument-from-check_pfn_span.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/memory_hotplug: drop 'reason' argument from check_pfn_span()
Date: Tue, 31 May 2022 14:34:41 +0530

In check_pfn_span(), a 'reason' string is being used to recreate the
caller function name, while printing the warning message.  It is really
unnecessary as the warning message could just be printed inside the caller
depending on the return code.  Currently there are just two callers for
check_pfn_span() i.e __add_pages() and __remove_pages().  Let's clean this
up.

Link: https://lkml.kernel.org/r/20220531090441.170650-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-reason-argument-from-check_pfn_span
+++ a/mm/memory_hotplug.c
@@ -237,8 +237,7 @@ static void release_memory_resource(stru
 	kfree(res);
 }
 
-static int check_pfn_span(unsigned long pfn, unsigned long nr_pages,
-		const char *reason)
+static int check_pfn_span(unsigned long pfn, unsigned long nr_pages)
 {
 	/*
 	 * Disallow all operations smaller than a sub-section and only
@@ -255,12 +254,8 @@ static int check_pfn_span(unsigned long
 		min_align = PAGES_PER_SUBSECTION;
 	else
 		min_align = PAGES_PER_SECTION;
-	if (!IS_ALIGNED(pfn, min_align)
-			|| !IS_ALIGNED(nr_pages, min_align)) {
-		WARN(1, "Misaligned __%s_pages start: %#lx end: #%lx\n",
-				reason, pfn, pfn + nr_pages - 1);
+	if (!IS_ALIGNED(pfn | nr_pages, min_align))
 		return -EINVAL;
-	}
 	return 0;
 }
 
@@ -337,9 +332,10 @@ int __ref __add_pages(int nid, unsigned
 		altmap->alloc = 0;
 	}
 
-	err = check_pfn_span(pfn, nr_pages, "add");
-	if (err)
-		return err;
+	if (check_pfn_span(pfn, nr_pages)) {
+		WARN(1, "Misaligned %s start: %#lx end: #%lx\n", __func__, pfn, pfn + nr_pages - 1);
+		return -EINVAL;
+	}
 
 	for (; pfn < end_pfn; pfn += cur_nr_pages) {
 		/* Select all remaining pages up to the next section boundary */
@@ -536,8 +532,10 @@ void __remove_pages(unsigned long pfn, u
 
 	map_offset = vmem_altmap_offset(altmap);
 
-	if (check_pfn_span(pfn, nr_pages, "remove"))
+	if (check_pfn_span(pfn, nr_pages)) {
+		WARN(1, "Misaligned %s start: %#lx end: #%lx\n", __func__, pfn, pfn + nr_pages - 1);
 		return;
+	}
 
 	for (; pfn < end_pfn; pfn += cur_nr_pages) {
 		cond_resched();
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-memory_hotplug-drop-reason-argument-from-check_pfn_span.patch

