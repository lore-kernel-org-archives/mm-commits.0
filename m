Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6F6C4167B
	for <mm-commits@archiver.kernel.org>; Fri,  1 Dec 2023 20:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379559AbjLAUCE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Dec 2023 15:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379578AbjLAUCD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Dec 2023 15:02:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBE810F0
        for <mm-commits@vger.kernel.org>; Fri,  1 Dec 2023 12:02:09 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FABEC433C9;
        Fri,  1 Dec 2023 20:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701460929;
        bh=+nGiLLTnEPBsREUmbVmUC1Y00yspQII9tQOAu8wnue4=;
        h=Date:To:From:Subject:From;
        b=Bqlr5BMIWdnA9mfkwX+67WeRs3iOIDc8rEpgv7Q8/9eIMOsg56wiq9Rzy3Gk+1Nyd
         7BzeIv+gmwsHYAeKMW1iR4o+UfloGzrUItnAH/J1h4wJj1Pc+aRO2j+lsZ/Sp0Nb9k
         pNtkCJZTeHAh3QFLmLXNnjIz8NDWI6HzGTc67Fd4=
Date:   Fri, 01 Dec 2023 12:02:08 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, david@redhat.com,
        rostedt@goodmis.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-misplaced-parenthesis-of-a-likely.patch added to mm-unstable branch
Message-Id: <20231201200209.5FABEC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix misplaced parenthesis of a likely()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-fix-misplaced-parenthesis-of-a-likely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-misplaced-parenthesis-of-a-likely.patch

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
From: Steven Rostedt <rostedt@goodmis.org>
Subject: mm/rmap: fix misplaced parenthesis of a likely()
Date: Fri, 1 Dec 2023 14:59:36 -0500


Running my yearly branch profiler to see where likely/unlikely annotation
may be added or removed, I discovered this:

correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0   457918 100 page_try_dup_anon_rmap         rmap.h               264
[..]
  458021        0   0 page_try_dup_anon_rmap         rmap.h               265

I thought it was interesting that line 264 of rmap.h had a 100% incorrect
annotation, but the line directly below it was 100% correct. Looking at the
code:

	if (likely(!is_device_private_page(page) &&
	    unlikely(page_needs_cow_for_dma(vma, page))))

It didn't make sense. The "likely()" was around the entire if statement
(not just the "!is_device_private_page(page)"), which also included the
"unlikely()" portion of that if condition.

If the unlikely portion is unlikely to be true, that would make the entire
if condition unlikely to be true, so it made no sense at all to say the
entire if condition is true.

What is more likely to be likely is just the first part of the if statement
before the && operation. It's likely to be a misplaced parenthesis. And
after making the if condition broken into a likely() && unlikely(), both
now appear to be correct!

Link: https://lkml.kernel.org/r/20231201145936.5ddfdb50@gandalf.local.home
Fixes:fb3d824d1a46c ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-fix-misplaced-parenthesis-of-a-likely
+++ a/include/linux/rmap.h
@@ -266,8 +266,8 @@ static inline int page_try_dup_anon_rmap
 	 * guarantee the pinned page won't be randomly replaced in the
 	 * future on write faults.
 	 */
-	if (likely(!is_device_private_page(page) &&
-	    unlikely(page_needs_cow_for_dma(vma, page))))
+	if (likely(!is_device_private_page(page)) &&
+	    unlikely(page_needs_cow_for_dma(vma, page)))
 		return -EBUSY;
 
 	ClearPageAnonExclusive(page);
_

Patches currently in -mm which might be from rostedt@goodmis.org are

mm-rmap-fix-misplaced-parenthesis-of-a-likely.patch

