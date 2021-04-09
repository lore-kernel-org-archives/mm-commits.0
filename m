Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0076C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8991061182
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhDIUHn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233674AbhDIUHn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:07:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAD00610FC;
        Fri,  9 Apr 2021 20:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617998849;
        bh=A2ZpxWwwEHHIINjdoiB2U6/Z75Ht3Zog+fTQuYpT4Gk=;
        h=Date:From:To:Subject:From;
        b=B4mtI9Zsz470XImeYfI9LaHfUlzG37hFCoB6pHHDYnzLVTNpPlXULihww5FKecmIx
         Z0OiSv5avSvauKOSIUnvM7ieqaH0E5uTXnfKWstWXNIeK1ruXyhTLhRfOFQFoCh9DL
         nslnio+aZVn3bkY8gH7p3DHRjMN/9s84CPED/TWo=
Date:   Fri, 09 Apr 2021 13:07:29 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, willy@infradead.org, yaoaili@kingsoft.com
Subject:  [folded-merged]
 mm-gup-check-page-posion-status-for-coredump-v4.patch removed from -mm tree
Message-ID: <20210409200729.8HonXY-uZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-check-page-posion-status-for-coredump-v4
has been removed from the -mm tree.  Its filename was
     mm-gup-check-page-posion-status-for-coredump-v4.patch

This patch was dropped because it was folded into mm-gup-check-page-posion-status-for-coredump.patch

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

