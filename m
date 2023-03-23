Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D75C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 21:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCWV0W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 17:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjCWV0M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 17:26:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739332FCDB
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 14:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6613FB8227B
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 21:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16542C433D2;
        Thu, 23 Mar 2023 21:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679606761;
        bh=6Ja1PnN7U8KGjyqjlpFODM+k+jeoIpMNkk47/WDPc/g=;
        h=Date:To:From:Subject:From;
        b=Ce8aaPjw39JMYUXYSTAfwVDPfxkiOTAH2bsZFhEuAr3bk07uDpM2z/vh+RqDB8S9o
         1D0+5r8fQ7TTgYgouDVBh7SXmAfZNzCyY5vvODsXYuCltmX3C+9ETA0GCugaWnvy8N
         C5IpSfds7F6TwgiR08Df1IYnTIzppvhotP0SHUP0=
Date:   Thu, 23 Mar 2023 14:26:00 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        jschoenh@amazon.de, david@redhat.com, krckatom@amazon.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-be-less-noisy-during-memory-hotplug.patch added to mm-unstable branch
Message-Id: <20230323212601.16542C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: be less noisy during memory hotplug
has been added to the -mm mm-unstable branch.  Its filename is
     mm-be-less-noisy-during-memory-hotplug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-be-less-noisy-during-memory-hotplug.patch

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
From: Tomas Krcka <krckatom@amazon.de>
Subject: mm: be less noisy during memory hotplug
Date: Thu, 23 Mar 2023 17:43:49 +0000

Turn a pr_info() into a pr_debug() to prevent dmesg spamming on systems
where memory hotplug is a frequent operation.

Link: https://lkml.kernel.org/r/20230323174349.35990-1-krckatom@amazon.de
Signed-off-by: Tomas Krcka <krckatom@amazon.de>
Suggested-by: Jan H. Schönherr <jschoenh@amazon.de>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-be-less-noisy-during-memory-hotplug
+++ a/mm/mm_init.c
@@ -1086,7 +1086,7 @@ void __ref memmap_init_zone_device(struc
 				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
-	pr_info("%s initialised %lu pages in %ums\n", __func__,
+	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
 #endif
_

Patches currently in -mm which might be from krckatom@amazon.de are

mm-be-less-noisy-during-memory-hotplug.patch

