Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA08C77B75
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbjELXUl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239656AbjELXUj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:20:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C78E2729
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 16:20:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8C8561D51
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 23:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CC6C4339B;
        Fri, 12 May 2023 23:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683933637;
        bh=awsr9/ABkE7S3J6wHxFzAelLWXueHkhh2nyv2XGUWII=;
        h=Date:To:From:Subject:From;
        b=nTVwe22qCDYZTb7q1AThdQCmddZWCc0nlT+WOoZ5k4dCZsLBgE9Yh4kDxT6elCSxU
         cwaZVzb67VBB72Ida8reEBNSIzxXNXppuRI9oLh73nZXDl95pDdb/jv4L1cn4xpkNN
         aIOaVgUqUnR3RSZQFPl+x+otGp0AtzLmy88ar/JY=
Date:   Fri, 12 May 2023 16:20:36 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        david@redhat.com, rick.wertenbroek@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-format-string-in-warnings.patch added to mm-unstable branch
Message-Id: <20230512232037.28CC6C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: fix format string in warnings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-fix-format-string-in-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-fix-format-string-in-warnings.patch

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
From: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Subject: mm: memory_hotplug: fix format string in warnings
Date: Wed, 10 May 2023 11:07:57 +0200

The format string in __add_pages and __remove_pages has a typo and prints
e.g., "Misaligned __add_pages start: 0xfc605 end: #fc609" instead of
"Misaligned __add_pages start: 0xfc605 end: 0xfc609" Fix "#%lx" => "%#lx"

Link: https://lkml.kernel.org/r/20230510090758.3537242-1-rick.wertenbroek@gmail.com
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-format-string-in-warnings
+++ a/mm/memory_hotplug.c
@@ -325,7 +325,7 @@ int __ref __add_pages(int nid, unsigned
 	}
 
 	if (check_pfn_span(pfn, nr_pages)) {
-		WARN(1, "Misaligned %s start: %#lx end: #%lx\n", __func__, pfn, pfn + nr_pages - 1);
+		WARN(1, "Misaligned %s start: %#lx end: %#lx\n", __func__, pfn, pfn + nr_pages - 1);
 		return -EINVAL;
 	}
 
@@ -525,7 +525,7 @@ void __remove_pages(unsigned long pfn, u
 	map_offset = vmem_altmap_offset(altmap);
 
 	if (check_pfn_span(pfn, nr_pages)) {
-		WARN(1, "Misaligned %s start: %#lx end: #%lx\n", __func__, pfn, pfn + nr_pages - 1);
+		WARN(1, "Misaligned %s start: %#lx end: %#lx\n", __func__, pfn, pfn + nr_pages - 1);
 		return;
 	}
 
_

Patches currently in -mm which might be from rick.wertenbroek@gmail.com are

mm-memory_hotplug-fix-format-string-in-warnings.patch

