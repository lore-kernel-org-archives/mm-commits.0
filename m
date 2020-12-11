Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C23BC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 21:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 063EB24058
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 21:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391752AbgLKT1G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 14:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732836AbgLKT0u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 14:26:50 -0500
Date:   Fri, 11 Dec 2020 11:26:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607714764;
        bh=ijjJbDVJDpl4Vg6XN+SeSM9xkOwokayr+IKcsQK3G1A=;
        h=From:To:Subject:From;
        b=KhhN6S3mHj8Gi/t3gxkN7r1fiInJwZAAzpG0xxr6XDbS2OMnqbveE3GlkC+9YmH6n
         erkzk7YHjOuktyhKckEmh/U/+r0cG5RQzzmaj1nfvAd5dFRxKdE0nrhuOwQ1Ej6w+K
         ZCZ4Mkf/QRrQK2b3LeuxkEWYZIVLwCLll47g4gw0=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cheloha@linux.ibm.com, david@redhat.com,
        ldufour@linux.ibm.com, mm-commits@vger.kernel.org,
        nathanl@linux.ibm.com
Subject:  + mm-memory_hotplug-quieting-offline-operation.patch
 added to -mm tree
Message-ID: <20201211192603.F38pDKsAo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: quieting offline operation
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-quieting-offline-operation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-quieting-offline-operation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-quieting-offline-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: mm/memory_hotplug: quieting offline operation

On PowerPC, when dymically removing memory from a system we can see in the
console a lot of messages like this:

[  186.575389] Offlined Pages 4096

This message is displayed on each LMB (256MB) removed, which means that we
removing 1TB of memory, this message is displayed 4096 times.

Moving it to DEBUG to not flood the console.

Link: https://lkml.kernel.org/r/20201211150157.91399-1-ldufour@linux.ibm.com
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-quieting-offline-operation
+++ a/mm/memory_hotplug.c
@@ -1569,7 +1569,7 @@ int __ref offline_pages(unsigned long st
 
 	/* Mark all sections offline and remove free pages from the buddy. */
 	__offline_isolated_pages(start_pfn, end_pfn);
-	pr_info("Offlined Pages %ld\n", nr_pages);
+	pr_debug("Offlined Pages %ld\n", nr_pages);
 
 	/*
 	 * The memory sections are marked offline, and the pageblock flags
_

Patches currently in -mm which might be from ldufour@linux.ibm.com are

mm-memory_hotplug-quieting-offline-operation.patch

