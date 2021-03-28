Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F9AC433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6839A6195D
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhC1VqB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 17:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhC1Vpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 17:45:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AC476194B;
        Sun, 28 Mar 2021 21:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616967940;
        bh=ynK8ECM51ppiGTRmNk0bR/wIgM9Ty0gJmOIqSGtCPDM=;
        h=Date:From:To:Subject:From;
        b=u8izHa1AHbrxFuCQFN3/1KwMFzeHChqkGeYrUsT6/v0TU7iNR3FsRECRaE5S7MIzb
         CrV34wCF/tzcTOb+WyaN0I3Zd4gCGq6hLZoOD4Ei9VL8ctp6mipAg11Dh8PRliGNoB
         zm2j1xE7c2H+VJMXn7Tc9ybjSyU/jWYsYIpkNUEo=
Date:   Sun, 28 Mar 2021 14:45:39 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, willy@infradead.org, yaoaili@kingsoft.com
Subject:  + mm-gup-check-page-posion-status-for-coredump-v4.patch
 added to -mm tree
Message-ID: <20210328214539.yKAP2fh8Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-check-page-posion-status-for-coredump-v4
has been added to the -mm tree.  Its filename is
     mm-gup-check-page-posion-status-for-coredump-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-check-page-posion-status-for-coredump-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-check-page-posion-status-for-coredump-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aili Yao <yaoaili@kingsoft.com>
Subject: mm-gup-check-page-posion-status-for-coredump-v4

is_page_poisoned() arg cannot be null, per Matthew

Link: https://lkml.kernel.org/r/20210319104437.6f30e80d@alex-virtual-machine
Link: https://lkml.kernel.org/r/20210322115233.05e4e82a@alex-virtual-machine
Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/internal.h~mm-gup-check-page-posion-status-for-coredump-v4
+++ a/mm/internal.h
@@ -109,12 +109,11 @@ static inline void set_page_refcounted(s
  */
 static inline bool is_page_poisoned(struct page *page)
 {
-	if (page != NULL) {
-		if (PageHWPoison(page))
-			return true;
-		else if (PageHuge(page) && PageHWPoison(compound_head(page)))
-			return true;
-	}
+	if (PageHWPoison(page))
+		return true;
+	else if (PageHuge(page) && PageHWPoison(compound_head(page)))
+		return true;
+
 	return false;
 }
 
_

Patches currently in -mm which might be from yaoaili@kingsoft.com are

mm-gup-check-page-posion-status-for-coredump.patch
mm-gup-check-page-posion-status-for-coredump-v4.patch

