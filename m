Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE5ACCA47F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbiFMUlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245728AbiFMUlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 16:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BEC654A
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 12:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7444361544
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 19:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2349C34114;
        Mon, 13 Jun 2022 19:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655149245;
        bh=6d7KMeHfSTWQfcLvHXNaGELfEZxIRDox9ppwHU96qMM=;
        h=Date:To:From:Subject:From;
        b=SckmklLP/DVNR4lrJbjncBnBdFmY8J49NqTyIEW59TSf5HVI7vo3a7KtjD8hhSPzd
         WeFEeO0SaYS/79DF9/RK7D9SR+kiDU9R7tSwTUyXxVXyW4W5xmgoqGJE2IFFThvjq8
         cd1DJ4wGNmzqmBbcv8uMrSHmgrD74E7mf41Z4NeU=
Date:   Mon, 13 Jun 2022 12:40:45 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-schemes-add-lru_deprio-action.patch added to mm-unstable branch
Message-Id: <20220613194045.C2349C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: add 'LRU_DEPRIO' action
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-schemes-add-lru_deprio-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-schemes-add-lru_deprio-action.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch
docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

