Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECBDC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiGDBKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiGDBKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814FD6325
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40777B80C73
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2CAC341C7;
        Mon,  4 Jul 2022 01:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897000;
        bh=6yO4TdYX8MARUGw9ARF/bkpYVFYWpJsswvu7OWjfX5k=;
        h=Date:To:From:Subject:From;
        b=cCPDkC56ZmNfmKmCLNTWJD0LY65S/hLk8kFOxzUYAqcD8BOVLmfCjSzxza5wDsNdG
         t5swouPqxceqANA5pVmjs+GngPRO9VGbxNj134T2bHOv+u68nzJS116oqS5PM4e85E
         oYwpiBTM7sJP0QDlBUnM1zfkLa1aa2rcxXqP+d08=
Date:   Sun, 03 Jul 2022 18:09:59 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-schemes-add-lru_deprio-action.patch removed from -mm tree
Message-Id: <20220704010959.DD2CAC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/schemes: add 'LRU_DEPRIO' action
has been removed from the -mm tree.  Its filename was
     mm-damon-schemes-add-lru_deprio-action.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/schemes: add 'LRU_DEPRIO' action
Date: Mon, 13 Jun 2022 19:22:58 +0000

This commit adds a new DAMON-based operation scheme action called
'LRU_DEPRIO' for physical address space.  The action deprioritizes pages
in the memory area of the target access pattern on their LRU lists.  This
is hence supposed to be used for rarely accessed (cold) memory regions so
that cold pages could be more likely reclaimed first under memory
pressure.  Internally, it simply calls 'lru_deactivate()'.

Using this with 'LRU_PRIO' action for hot pages, users can proactively
sort LRU lists based on the access pattern.  That is, it can make the LRU
lists somewhat more trustworthy source of access temperature.  As a
result, efficiency of LRU-lists based mechanisms including the reclamation
target selection could be improved.

Link: https://lkml.kernel.org/r/20220613192301.8817-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/paddr.c      |   20 ++++++++++++++++++++
 mm/damon/sysfs.c      |    1 +
 3 files changed, 23 insertions(+)

--- a/include/linux/damon.h~mm-damon-schemes-add-lru_deprio-action
+++ a/include/linux/damon.h
@@ -87,6 +87,7 @@ struct damon_target {
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
+ * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
  * @DAMOS_STAT:		Do nothing but count the stat.
  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  */
@@ -97,6 +98,7 @@ enum damos_action {
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
 	DAMOS_LRU_PRIO,
+	DAMOS_LRU_DEPRIO,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
 	NR_DAMOS_ACTIONS,
 };
--- a/mm/damon/paddr.c~mm-damon-schemes-add-lru_deprio-action
+++ a/mm/damon/paddr.c
@@ -249,6 +249,22 @@ static unsigned long damon_pa_mark_acces
 	return applied * PAGE_SIZE;
 }
 
+static unsigned long damon_pa_deactivate_pages(struct damon_region *r)
+{
+	unsigned long addr, applied = 0;
+
+	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+		struct page *page = damon_get_page(PHYS_PFN(addr));
+
+		if (!page)
+			continue;
+		deactivate_page(page);
+		put_page(page);
+		applied++;
+	}
+	return applied * PAGE_SIZE;
+}
+
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme)
@@ -258,6 +274,8 @@ static unsigned long damon_pa_apply_sche
 		return damon_pa_pageout(r);
 	case DAMOS_LRU_PRIO:
 		return damon_pa_mark_accessed(r);
+	case DAMOS_LRU_DEPRIO:
+		return damon_pa_deactivate_pages(r);
 	default:
 		break;
 	}
@@ -273,6 +291,8 @@ static int damon_pa_scheme_score(struct
 		return damon_pageout_score(context, r, scheme);
 	case DAMOS_LRU_PRIO:
 		return damon_hot_score(context, r, scheme);
+	case DAMOS_LRU_DEPRIO:
+		return damon_pageout_score(context, r, scheme);
 	default:
 		break;
 	}
--- a/mm/damon/sysfs.c~mm-damon-schemes-add-lru_deprio-action
+++ a/mm/damon/sysfs.c
@@ -763,6 +763,7 @@ static const char * const damon_sysfs_da
 	"hugepage",
 	"nohugepage",
 	"lru_prio",
+	"lru_deprio",
 	"stat",
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

