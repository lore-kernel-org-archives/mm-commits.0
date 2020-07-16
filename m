Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD19C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F3B20809
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594935948;
	bh=25QFRIF0wT73zO/jVlchVmS8aem6yABogv3pvuQvZOM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=T0NT39v9SPMCKuMH21snQwlXIJEPPakEjwAzSsTX3bM7ixVk/svxvUS3Q+9H2WbsY
	 dLZWI1PjgsOxv/SiYv8HEmMnyt9d5glrm7hTYHqr6vsX4o8gYEuPsHeqPGBH5XSan2
	 9VqjY6SECFmbEFVi6QeFYLrIXZZlv4ywTJ20HbYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgGPVps (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 17:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgGPVps (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 17:45:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12CC52076D;
        Thu, 16 Jul 2020 21:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594935947;
        bh=25QFRIF0wT73zO/jVlchVmS8aem6yABogv3pvuQvZOM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vltZ3ywjMJrEBNNahAfx/jnujooUgYNrXCrbSn3nprM7I/rWPVn7dy8bTz+Z27Sk0
         fxRlfqe3KX0FsrlY8orUSQCAOj+st/1mzj5f+3nOA77L89JD+vdmxfod+ubtR6LgxI
         HCHghXfQ2NSSkP79DEmKUgGx2li1pazUVDnQwzso=
Date:   Thu, 16 Jul 2020 14:45:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, tony.luck@intel.com,
        zeil@yandex-team.ru
Subject:  + mmhwpoison-cleanup-unused-pagehuge-check.patch added to
 -mm tree
Message-ID: <20200716214546.RuFtF9b_8%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: cleanup unused PageHuge() check
has been added to the -mm tree.  Its filename is
     mmhwpoison-cleanup-unused-pagehuge-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-cleanup-unused-pagehuge-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-cleanup-unused-pagehuge-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm,hwpoison: cleanup unused PageHuge() check

Patch series "Hwpoison soft-offline rework", v4.

This patchset was initially based on Naoya's hwpoison rework [1], so
thanks to him for the initial work.  I would also like to think Naoya for
testing the patchset off-line, and report any issues he found, that was
quite helpful.

This patchset aims to fix some issues laying in soft-offline handling, but
it also takes the chance and takes some further steps to perform cleanups
and some refactoring as well.


 - Motivation:

   A customer and I were facing an issue were processes were killed
   after having soft-offlined some of their pages.  This should not happen
   when soft-offlining, as it is meant to be non-disruptive.  I was able
   to reproduce the issue when I stressed the memory + soft offlining
   pages in the meantime.

   After debugging the issue, I saw that the problem was that pages
   were returned back to user-space after having offlined them properly. 
   So, when those pages were faulted in, the fault handler returned
   VM_FAULT_POISON all the way down to the arch handler, and it simply
   killed the process.

   After a further anaylsis, it became clear that the problem was that
   when kcompactd kicked in to migrate pages over, compaction_alloc
   callback was handing poisoned pages to the migrate routine.

   All this could happen because isolate_freepages_block and
   fast_isolate_freepages just check for the page to be PageBuddy, and
   since 1) poisoned pages can be part of a higher order page and 2)
   poisoned pages are also Page Buddy, they can sneak in easily.

   I also saw some other problems with sawap pages, but I suspected it
   to be the same sort of problem, so I did not follow that trace.

   The above refers to soft-offline.  But I also saw problems with
   hard-offline, specially hugetlb corruption, and some other weird stuff.
   (I could paste the logs)

   The full explanation refering to the soft-offline case can be found at [2].

 - Approach:

   The taken approach is to contain those pages and never let them hit
   neither pcplists nor buddy freelists.  Only when they are completely
   out of reach, we flag them as poisoned.

   A full explanation of this can be found in patch#11 and patch#12

 - Outcome:

   With this patchset, I no longer see the issues with soft-offline.

[1] https://lore.kernel.org/linux-mm/1541746035-13408-1-git-send-email-n-horiguchi@ah.jp.nec.com/
[2] https://lore.kernel.org/linux-mm/20190826104144.GA7849@linux/T/#u


This patch (of 15):

Drop the PageHuge check since memory_failure forks into memory_failure_hugetlb()
for hugetlb pages.

Link: http://lkml.kernel.org/r/20200716123810.25292-1-osalvador@suse.de
Link: http://lkml.kernel.org/r/20200716123810.25292-2-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-cleanup-unused-pagehuge-check
+++ a/mm/memory-failure.c
@@ -1382,10 +1382,7 @@ int memory_failure(unsigned long pfn, in
 	 * page_remove_rmap() in try_to_unmap_one(). So to determine page status
 	 * correctly, we save a copy of the page flags at this time.
 	 */
-	if (PageHuge(p))
-		page_flags = hpage->flags;
-	else
-		page_flags = p->flags;
+	page_flags = p->flags;
 
 	/*
 	 * unpoison always clear PG_hwpoison inside page lock
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mmhwpoison-cleanup-unused-pagehuge-check.patch
mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

