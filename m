Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE7EC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 20:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiLSUZA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 15:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiLSUY7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 15:24:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46831E6
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 12:24:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFA24B80E18
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 20:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9216EC433EF;
        Mon, 19 Dec 2022 20:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671481495;
        bh=Hn4NkNO4Rlqpud0QFSPDMivToVQXrfKKeIslvcoGBuE=;
        h=Date:To:From:Subject:From;
        b=rFfGdykFbSahFA+MR2TcHQZm74GU8NLX1/IDWCHgpJYZ5UkW9MwV1wDpL0cz0uHqs
         XOuE0Yghm1grq7CEKRTtWYChN5NnJNi8EKYXNFS9uOqR6CXl79HfHRiIyLR8Hf3atV
         RPKv7I/4Ip8FUxs/FkCj2u+M7SC3Erxvoex8eqd0=
Date:   Mon, 19 Dec 2022 12:24:54 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch added to mm-unstable branch
Message-Id: <20221219202455.9216EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: return an error for filter memcg path id lookup failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch

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
Subject: mm/damon/sysfs-schemes: return an error for filter memcg path id lookup failure
Date: Mon, 19 Dec 2022 17:18:07 +0000

Commit f36f860207ef ("mm/damon/sysfs-schemes: implement scheme filters")
on mm-unstable introduced damon_sysfs_memcg_path_to_id(), which returns
non-error even if it didn't find the memcg of the given path.  Caller
could check the failure by seeing if the 'id' has really set or not, but
it's unnecessarily complicated.  Return an error for the case instead.

Link: https://lkml.kernel.org/r/20221219171807.55708-3-sj@kernel.org
Fixes: f36f860207ef ("mm/damon/sysfs-schemes: implement scheme filters") on mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2
+++ a/mm/damon/sysfs-schemes.c
@@ -1418,6 +1418,7 @@ static int damon_sysfs_memcg_path_to_id(
 {
 	struct mem_cgroup *memcg;
 	char *path;
+	bool found = false;
 
 	if (!memcg_path)
 		return -EINVAL;
@@ -1433,12 +1434,13 @@ static int damon_sysfs_memcg_path_to_id(
 			continue;
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
 			*id = mem_cgroup_id(memcg);
+			found = true;
 			break;
 		}
 	}
 
 	kfree(path);
-	return 0;
+	return found ? 0 : -EINVAL;
 }
 
 static int damon_sysfs_set_scheme_filters(struct damos *scheme,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch

