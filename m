Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF85C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8D392076D
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594935960;
	bh=gVuaOZ9w0injx+98d/kF6m1WUGeq3dfHutk0GAMvesE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gKNuBd7H04iW/1j8V3rr2rwp2iGDyBRbQH3G2dC8V+015jm7L7riQ/dyD3AlumXvc
	 02MUI/laAsk9+81jZ6KWEoHoZfdEhqpJGuIvka3+8iiWwqADjODqPzEJnNI9oH5ZCg
	 WoSu8X5fKpfqPdbZ945Roi+ZX1vKZpUBRyR9Drw8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgGPVqA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 17:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgGPVqA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 17:46:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E02E9207DD;
        Thu, 16 Jul 2020 21:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594935959;
        bh=gVuaOZ9w0injx+98d/kF6m1WUGeq3dfHutk0GAMvesE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LXIQt+zmf5JiCs3fboF9773qpTDOvvvyhfzEOFHsmHl4/8WWxkD9YwJM073Bi3SE8
         ydEZcOgquZFRQjTcfakbrdmRmrQCZ92X+uhbsMtPdMVO8BVGPRBEeaZEreXH3jKqKR
         UQ1udiY8ZHbA0G5hwYPtcQ53h4Hmi2aIDZWud+P4=
Date:   Thu, 16 Jul 2020 14:45:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, tony.luck@intel.com,
        zeil@yandex-team.ru
Subject:  + mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
 added to -mm tree
Message-ID: <20200716214558.i3TkW2wCG%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison-inject: don't pin for hwpoison_filter
has been added to the -mm tree.  Its filename is
     mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch

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
Subject: mm,hwpoison-inject: don't pin for hwpoison_filter

Another memory error injection interface debugfs:hwpoison/corrupt-pfn also
takes bogus refcount for hwpoison_filter().  It's justified because this
does a coarse filter, expecting that memory_failure() redoes the check for
sure.

Link: http://lkml.kernel.org/r/20200716123810.25292-6-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/hwpoison-inject.c~mmhwpoison-inject-dont-pin-for-hwpoison_filter
+++ a/mm/hwpoison-inject.c
@@ -26,11 +26,6 @@ static int hwpoison_inject(void *data, u
 
 	p = pfn_to_page(pfn);
 	hpage = compound_head(p);
-	/*
-	 * This implies unable to support free buddy pages.
-	 */
-	if (!get_hwpoison_page(p))
-		return 0;
 
 	if (!hwpoison_filter_enable)
 		goto inject;
@@ -40,23 +35,20 @@ static int hwpoison_inject(void *data, u
 	 * This implies unable to support non-LRU pages.
 	 */
 	if (!PageLRU(hpage) && !PageHuge(p))
-		goto put_out;
+		return 0;
 
 	/*
-	 * do a racy check with elevated page count, to make sure PG_hwpoison
-	 * will only be set for the targeted owner (or on a free page).
+	 * do a racy check to make sure PG_hwpoison will only be set for
+	 * the targeted owner (or on a free page).
 	 * memory_failure() will redo the check reliably inside page lock.
 	 */
 	err = hwpoison_filter(hpage);
 	if (err)
-		goto put_out;
+		return 0;
 
 inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
-	return memory_failure(pfn, MF_COUNT_INCREASED);
-put_out:
-	put_hwpoison_page(p);
-	return 0;
+	return memory_failure(pfn, 0);
 }
 
 static int hwpoison_unpoison(void *data, u64 val)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mmhwpoison-cleanup-unused-pagehuge-check.patch
mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

