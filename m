Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB05C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 01:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32DB72177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 01:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596762421;
	bh=TArZV5hdJIl6GEAHBIAiMSQErKxARpZDgbwRkezhG/I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=05fGd48c2f6v1bmljtaylox5Qq/+PAIFTYek2Bo6LBdOEq1bSwDrTEKUoXhqVthKx
	 GV/4fRjd/jbi9uIenWxQaxseRCDM7Yr5dCYtA0ZATe6E4XF3gKxkv7XgOBkxQJxEYo
	 w9m6fBrPhlSJ+0mivV6BOA81gTb/gI999uk5NAmQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgHGBHA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Aug 2020 21:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgHGBHA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 Aug 2020 21:07:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D3E621744;
        Fri,  7 Aug 2020 01:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596762419;
        bh=TArZV5hdJIl6GEAHBIAiMSQErKxARpZDgbwRkezhG/I=;
        h=Date:From:To:Subject:From;
        b=DXejUhQ7M+cjA0ZKC9TR6hDpnDuyzgt79jiXoeanbJ3E8jkKqT+1zZN4GBzo64PDF
         +Lp4O/A09ArB6xD+ar/eoBs9cr1m/UbuqxvKN57wNjdLbQ7S28XwpR98jnodKPUIjt
         3ldYG/fPUh8s2EY33QBNQm9lPzkFcarQBDPQvQVQ=
Date:   Thu, 06 Aug 2020 18:06:58 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, tony.luck@intel.com, zeil@yandex-team.ru
Subject:  + mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
 added to -mm tree
Message-ID: <20200807010658.eBQhuo6Bc%akpm@linux-foundation.org>
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
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison-inject: don't pin for hwpoison_filter

Another memory error injection interface debugfs:hwpoison/corrupt-pfn also
takes bogus refcount for hwpoison_filter().  It's justified because this
does a coarse filter, expecting that memory_failure() redoes the check for
sure.

Link: http://lkml.kernel.org/r/20200806184923.7007-4-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
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

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-cleanup-unused-pagehuge-check.patch
mm-hwpoison-remove-recalculating-hpage.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

