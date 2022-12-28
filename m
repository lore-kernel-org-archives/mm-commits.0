Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE75C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 21:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiL1VzL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 16:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiL1VzK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 16:55:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AABBE1F
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 13:55:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8326EB818FF
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 21:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15190C433D2;
        Wed, 28 Dec 2022 21:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672264506;
        bh=aKahZGIG925GdghlYOtxoFwuUCkVNVje/KILXLQ89e4=;
        h=Date:To:From:Subject:From;
        b=Tdp7o2FiB1XmvwRqkrXQQ0pfvlDk/jZKGP5vLnzuJlm3YdxTn+FBGAoTpS1FHh5Wx
         Y5lu10Ru7suuk6lN9oPLrvSjigYJgDnM8ebY8Bv9Otc+Bvp+P2hE+5FXgm9x/uIRQW
         SmqoraXart378HkojmGCKfjUvIG/pt+Do7tH5Ep8=
Date:   Wed, 28 Dec 2022 13:55:05 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, alexander.h.duyck@linux.intel.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch added to mm-unstable branch
Message-Id: <20221228215506.15190C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: replace rcu_access_pointer() with rcu_dereference_protected()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch

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
Subject: mm/page_reporting: replace rcu_access_pointer() with rcu_dereference_protected()
Date: Wed, 28 Dec 2022 17:59:42 +0000

Page reporting fetches pr_dev_info using rcu_access_pointer(), which is
for safely fetching a pointer that will not be dereferenced but could
concurrently updated.  The code indeed does not dereference pr_dev_info
after fetching it using rcu_access_pointer(), but it fetches the pointer
while concurrent updates to the pointer is avoided by holding the update
side lock, page_reporting_mutex.

In the case, rcu_dereference_protected() should be used instead because it
provides better readability and performance on some cases, as
rcu_dereference_protected() avoids use of READ_ONCE().  Replace the
rcu_access_pointer() calls with rcu_dereference_protected().

Link: https://lkml.kernel.org/r/20221228175942.149491-1-sj@kernel.org
Fixes: 36e66c554b5c ("mm: introduce Reported pages")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_reporting.c~mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected
+++ a/mm/page_reporting.c
@@ -356,7 +356,8 @@ int page_reporting_register(struct page_
 	mutex_lock(&page_reporting_mutex);
 
 	/* nothing to do if already in use */
-	if (rcu_access_pointer(pr_dev_info)) {
+	if (rcu_dereference_protected(pr_dev_info,
+				lockdep_is_held(&page_reporting_mutex))) {
 		err = -EBUSY;
 		goto err_out;
 	}
@@ -401,7 +402,8 @@ void page_reporting_unregister(struct pa
 {
 	mutex_lock(&page_reporting_mutex);
 
-	if (rcu_access_pointer(pr_dev_info) == prdev) {
+	if (prdev == rcu_dereference_protected(pr_dev_info,
+				lockdep_is_held(&page_reporting_mutex))) {
 		/* Disable page reporting notification */
 		RCU_INIT_POINTER(pr_dev_info, NULL);
 		synchronize_rcu();
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
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch

