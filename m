Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11616C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED3721D7B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475058;
	bh=ajZdL6f/zfQshTou3hcW2I6FWLzruUFI0j4yDELuIWc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iG7CLNR2Vacxi2RmrOFrcOXPBkMsyN0/eXs6rYTnFWBb0RIdYkArV806pPiirMwb0
	 kjRNI033jk6mdUMI6SSeQgqxJ+YN8RIL3XBj/N6J0X9HurapJRKmp2V3anRrzRzfGV
	 u7d983/A01GstOkV1xWtnwCaLGBdtdcCu0s7gttc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgISAYS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:18 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10D7221D20;
        Sat, 19 Sep 2020 00:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475057;
        bh=ajZdL6f/zfQshTou3hcW2I6FWLzruUFI0j4yDELuIWc=;
        h=Date:From:To:Subject:From;
        b=DQ8fS0zwBgIXnE/Y/slYBLDY8RBuVz7+hAnkX0bCICh9UIIMRfgXP9nzQi73a/SBf
         JaZUNWn/kBlcsWkK3ExFucKcD04Rs5Ykl9m4UUB6u/2y7Nok/tFZaWXjHRgLlWB4JL
         /18CfZ5bS1T4vw4nNemdccHuY02EM+cYgc116ZQk=
Date:   Fri, 18 Sep 2020 17:24:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, osalvador@suse.de
Subject:  [to-be-updated]
 mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch removed from
 -mm tree
Message-ID: <20200919002416.plQjm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: unexport get_hwpoison_page and make it static
has been removed from the -mm tree.  Its filename was
     mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: unexport get_hwpoison_page and make it static

Since get_hwpoison_page is only used in memory-failure code now, let us
un-export it and make it private to that code.

Link: http://lkml.kernel.org/r/20200806184923.7007-5-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

 include/linux/mm.h  |    1 -
 mm/memory-failure.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-un-export-get_hwpoison_page-and-make-it-static
+++ a/include/linux/mm.h
@@ -3015,7 +3015,6 @@ extern int memory_failure(unsigned long
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
-extern int get_hwpoison_page(struct page *page);
 #define put_hwpoison_page(page)	put_page(page)
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
--- a/mm/memory-failure.c~mmhwpoison-un-export-get_hwpoison_page-and-make-it-static
+++ a/mm/memory-failure.c
@@ -924,7 +924,7 @@ static int page_action(struct page_state
  * Return: return 0 if failed to grab the refcount, otherwise true (some
  * non-zero value.)
  */
-int get_hwpoison_page(struct page *page)
+static int get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
@@ -953,7 +953,6 @@ int get_hwpoison_page(struct page *page)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
 /*
  * Do all that is necessary to remove user space mappings. Unmap
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

