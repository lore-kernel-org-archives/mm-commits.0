Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E020C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjASBTc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjASBRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:17:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D343B6C540
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A731B81FBC
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9956C433D2;
        Thu, 19 Jan 2023 01:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090935;
        bh=H75ST6c4bHRwqomZrl9d4nTJ95sa1Wj8V9ffsJhs2f0=;
        h=Date:To:From:Subject:From;
        b=qZXrMAROn2KpyQxzbuIE1XcWugMi8m+pl9IMV+gflYxJSTKIUXY22WHd9F8ZYhaHS
         C91mL4boC+Ua3HIvV5wHKViVFPd1H6xIGKU0rM1RNnOqzvDDa2mdcsuDq8CWIh8kNy
         ve72+xK1QaTVkoIqOrj5/heTRpQn6w+lJgaj7xoU=
Date:   Wed, 18 Jan 2023 17:15:35 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, alexander.h.duyck@linux.intel.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch removed from -mm tree
Message-Id: <20230119011535.C9956C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_reporting: replace rcu_access_pointer() with rcu_dereference_protected()
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/page_reporting.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

