Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D506EC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E2561165
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhDIUHm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232855AbhDIUHk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:07:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 198146105A;
        Fri,  9 Apr 2021 20:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617998847;
        bh=cSGuc42KhHFfkPHJyxMY/PN/8NTq4Sy5j45hrOA6k5o=;
        h=Date:From:To:Subject:From;
        b=SA954zW6WMP75207DOGBSOy4XVgXEZqehfwH82ihEdNeiFrrRc+DqNQBcTGr/8fIk
         ffj2Xex4Pw44GDA3slOhVgNL/bp0/C9gf550RMIHvC9zfZYU8ReqSGms2ahbvyLyF8
         Rt6b2x9um8dPGU03zgqwy+8jkrVJRJRAOMBmXmRI=
Date:   Fri, 09 Apr 2021 13:07:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, willy@infradead.org,
        yaoaili@kingsoft.com
Subject:  [folded-merged]
 mm-gup-check-page-posion-status-for-coredump-fix.patch removed from -mm
 tree
Message-ID: <20210409200726.Ctq4PbMrM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-check-page-posion-status-for-coredump-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-check-page-posion-status-for-coredump-fix.patch

This patch was dropped because it was folded into mm-gup-check-page-posion-status-for-coredump.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-check-page-posion-status-for-coredump-fix

s/0/false/

Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-gup-check-page-posion-status-for-coredump-fix
+++ a/mm/internal.h
@@ -115,7 +115,7 @@ static inline bool is_page_poisoned(stru
 		else if (PageHuge(page) && PageHWPoison(compound_head(page)))
 			return true;
 	}
-	return 0;
+	return false;
 }
 
 extern unsigned long highest_memmap_pfn;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-check-page-posion-status-for-coredump.patch
lib-test_kasan_modulec-suppress-unused-var-warning.patch
scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

