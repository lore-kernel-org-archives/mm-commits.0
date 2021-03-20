Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF439C433C1
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 00:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E67C61983
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 00:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhCTAWr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 20:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhCTAWj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 20:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D0A061983;
        Sat, 20 Mar 2021 00:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616199759;
        bh=X+zd4gkCxBoGHXItJZfFsExMgqf+9k5d6gg0MbddZPU=;
        h=Date:From:To:Subject:From;
        b=fVEV2+FyxQTVu6DrnAwZMj/83aSSXHVbnVRiGv/EvG0CA6X0YtFs2UzPc8NNwD2Io
         KOYyQxfiRXtNJOGThaKPvfIRJgttIN4fnn7cIjSM8ScFaWCwD8MzFDtk9y8lK0BdGw
         kkED7K10NajB8BmXygvm+CHuwoRAmY8l0BrXOWKY=
Date:   Fri, 19 Mar 2021 17:22:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, willy@infradead.org,
        yaoaili@kingsoft.com
Subject:  + mm-gup-check-page-posion-status-for-coredump-fix.patch
 added to -mm tree
Message-ID: <20210320002238.hHjZEha58%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-check-page-posion-status-for-coredump-fix
has been added to the -mm tree.  Its filename is
     mm-gup-check-page-posion-status-for-coredump-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-check-page-posion-status-for-coredump-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-check-page-posion-status-for-coredump-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

