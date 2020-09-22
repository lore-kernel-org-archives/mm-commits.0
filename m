Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE3FC4727C
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E27CA238D6
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600803801;
	bh=zChx7siZ3uCBoPzcCbUMDHDk8GKZFLQUfX5ayXm8FWE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IytiQ/+7z9DHmMXF81tgY/cLRw3ksBSVyOU0SEsgXCXiHEpjPKH8Nca/Tb9Tbk86e
	 pvUFsne0qkBxAtzVhGpc2nG7BsVWgrYDSV61QuCQZ6FIM7fX5v6W9sGA+lVC/i2DKJ
	 AIv/qqqjaVEgjyMCLai56Wd5dvXzK8AZJiQU4M4M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIVTnV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 15:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVTnV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 15:43:21 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E65E2221E8;
        Tue, 22 Sep 2020 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600803801;
        bh=zChx7siZ3uCBoPzcCbUMDHDk8GKZFLQUfX5ayXm8FWE=;
        h=Date:From:To:Subject:From;
        b=vx6Xu6WEBBeEMyEzCW4XeHAlYDwY8gnCPJzpkz8qiSsGzpHf7ouDIqTJLMI85AImu
         LOn2uYX/2AD3372O5HqXhoetgZr9E9IjjZiCCJJft3gg+q1QTxBNW3ZmKzbHDTk/tk
         P8ZMkJvQcI6/J/FFrHMWhwKj9+RewSeUp3voKO/A=
Date:   Tue, 22 Sep 2020 12:43:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        osalvador@suse.com, naoya.horiguchi@nec.com, mhocko@kernel.org,
        cai@lca.pw, osalvador@suse.de
Subject:  [to-be-updated]
 =?us-ascii?Q?mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-?=
 =?us-ascii?Q?zero-refcount-page.patch?= removed from -mm tree
Message-ID: <20200922194320._PNLM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: drain pcplists before bailing out for non-buddy zero-refcount page
has been removed from the -mm tree.  Its filename was
     mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: drain pcplists before bailing out for non-buddy zero-refcount page

A page with 0-refcount and !PageBuddy could perfectly be a pcppage. 
Currently, we bail out with an error if we encounter such a page, meaning
that we do not handle pcppages neither from hard-offline nor from
soft-offline path.

Fix this by draining pcplists whenever we find this kind of page and retry
the check again.  It might be that pcplists have been spilled into the
buddy allocator and so we can handle it.

Link: https://lkml.kernel.org/r/20200908075626.11976-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page
+++ a/mm/memory-failure.c
@@ -948,13 +948,13 @@ static int page_action(struct page_state
 }
 
 /**
- * get_hwpoison_page() - Get refcount for memory error handling:
+ * __get_hwpoison_page() - Get refcount for memory error handling:
  * @page:	raw error page (hit by memory error)
  *
  * Return: return 0 if failed to grab the refcount, otherwise true (some
  * non-zero value.)
  */
-static int get_hwpoison_page(struct page *page)
+static int __get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
@@ -984,6 +984,26 @@ static int get_hwpoison_page(struct page
 	return 0;
 }
 
+static int get_hwpoison_page(struct page *p)
+{
+	int ret;
+	bool drained = false;
+
+retry:
+	ret = __get_hwpoison_page(p);
+	if (!ret && !is_free_buddy_page(p) && !page_count(p) && !drained) {
+		/*
+		 * The page might be in a pcplist, so try to drain those
+		 * and see if we are lucky.
+		 */
+		drain_all_pages(page_zone(p));
+		drained = true;
+		goto retry;
+	}
+
+	return ret;
+}
+
 /*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

