Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFEADC43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A687621D7F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475088;
	bh=3vGvao9y5Km6AuadK2kkgxtODaB0cVr74M/1zNxjzP8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=w8PFHwGIrwb3vtzeRDaO7CGGgxk65aoYqtBxaLnxYvZZ0BXFhAZTTqC8q2LP2wc2W
	 UyDfCoK06z3sPS70z6hG5lNzN4E+OyjfT+84rZYL/XpJyj425q1iFZV5tjTaIHuhIk
	 247aMC2TLUO2H3ssgNOQgm+uQ3x+QqixHCanhzpM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgISAYs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:48 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1673521D7B;
        Sat, 19 Sep 2020 00:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475087;
        bh=3vGvao9y5Km6AuadK2kkgxtODaB0cVr74M/1zNxjzP8=;
        h=Date:From:To:Subject:From;
        b=vi+1uguLy915LQ+yCpGya4DWlYxd5hK+IfQNGoGCPJ4i+SUE1L+id9GlxJVEnqJgH
         rD4BMptvLzE71eBF2Iws0G+h/59rjWoZwRzTQMnfgjs0fzU886VlpktGmTwN9U+1jh
         DRODwTQ6BRmBUoQmYgQo4LfTLz63yqN+9U06LkPA=
Date:   Fri, 18 Sep 2020 17:24:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.de, osalvador@suse.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, naoya.horiguchi@nec.com
Subject:  [to-be-updated]
 mmhwpoison-double-check-page-count-in-__get_any_page.patch removed from -mm
 tree
Message-ID: <20200919002446.LaGdX%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: double-check page count in __get_any_page()
has been removed from the -mm tree.  Its filename was
     mmhwpoison-double-check-page-count-in-__get_any_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: double-check page count in __get_any_page()

Soft offlining could fail with EIO due to the race condition with hugepage
migration.  This issuse became visible due to the change by previous patch
that makes soft offline handler take page refcount by its own.  We have no
way to directly pin zero refcount page, and the page considered as a zero
refcount page could be allocated just after the first check.

This patch adds the second check to find the race and gives us chance to
handle it more reliably.

Link: http://lkml.kernel.org/r/20200806184923.7007-13-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Qian Cai <cai@lca.pw>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory-failure.c~mmhwpoison-double-check-page-count-in-__get_any_page
+++ a/mm/memory-failure.c
@@ -1709,6 +1709,9 @@ static int __get_any_page(struct page *p
 		} else if (is_free_buddy_page(p)) {
 			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
 			ret = 0;
+		} else if (page_count(p)) {
+			/* raced with allocation */
+			ret = -EBUSY;
 		} else {
 			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
 				__func__, pfn, p->flags);
@@ -1725,6 +1728,9 @@ static int get_any_page(struct page *pag
 {
 	int ret = __get_any_page(page, pfn, flags);
 
+	if (ret == -EBUSY)
+		ret = __get_any_page(page, pfn, flags);
+
 	if (ret == 1 && !PageHuge(page) &&
 	    !PageLRU(page) && !__PageMovable(page)) {
 		/*
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


