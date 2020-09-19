Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9702CC43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63343221EC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475082;
	bh=+tE2omcmrr0YpBGFM3qbWLMJxPiimmQz99CdgWfbdIY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2BtvN/BsIxkEZ30DRjvZWJOGY7UN517tYz6kgnCKaRa7VeaLNgPyjjpcOXvaro/oV
	 q3jZjeirbuI4c3NMT8XMYHI2ZmfLGnmTy5DTOttcXQDWVrVB96GiSF3u6s+y7dNKbF
	 fT9Mur+Ecn2t/BKKZfnUobC8uem6fwibFOJXhMco=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgISAYm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:42 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B99FB21D7B;
        Sat, 19 Sep 2020 00:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475081;
        bh=+tE2omcmrr0YpBGFM3qbWLMJxPiimmQz99CdgWfbdIY=;
        h=Date:From:To:Subject:From;
        b=b1JCiQ08TCOVZlEFOK7+Zx3EJgRp5wNUynPanu7aQWwXpzD3LEEWs/+wML90JitW4
         yJ72X/PqaHTMk21zuOWB42saTA3szz6YVYmMUwoXT6UpfCpjQyIoJsUBhQY4L9trgJ
         jPHqPAaikgAUtOpcinYYJFKUpL39A42JruDptEDc=
Date:   Fri, 18 Sep 2020 17:24:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, osalvador@suse.de
Subject:  [to-be-updated]
 mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
 removed from -mm tree
Message-ID: <20200919002440.bnGM-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline
has been removed from the -mm tree.  Its filename was
     mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline

Currently, there is an inconsistency when calling soft-offline from
different paths on a page that is already poisoned.

1) madvise:

        madvise_inject_error skips any poisoned page and continues
        the loop.
        If that was the only page to madvise, it returns 0.

2) /sys/devices/system/memory/:

        When calling soft_offline_page_store()->soft_offline_page(),
        we return -EBUSY in case the page is already poisoned.
        This is inconsistent with a) the above example and b)
        memory_failure, where we return 0 if the page was poisoned.

Fix this by dropping the PageHWPoison() check in madvise_inject_error, and
let soft_offline_page return 0 if it finds the page already poisoned.

Please, note that this represents a user-api change, since now the return
error when calling soft_offline_page_store()->soft_offline_page() will be
different.

Link: http://lkml.kernel.org/r/20200806184923.7007-11-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.com>
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

 mm/madvise.c        |    5 -----
 mm/memory-failure.c |    4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/madvise.c
@@ -896,11 +896,6 @@ static int madvise_inject_error(int beha
 		 */
 		size = page_size(compound_head(page));
 
-		if (PageHWPoison(page)) {
-			put_page(page);
-			continue;
-		}
-
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 					pfn, start);
--- a/mm/memory-failure.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/memory-failure.c
@@ -1804,7 +1804,7 @@ static int __soft_offline_page(struct pa
 		unlock_page(page);
 		put_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		return 0;
 	}
 
 	if (!PageHuge(page))
@@ -1908,7 +1908,7 @@ int soft_offline_page(unsigned long pfn,
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		if (flags & MF_COUNT_INCREASED)
 			put_page(page);
-		return -EBUSY;
+		return 0;
 	}
 
 	get_online_mems();
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

