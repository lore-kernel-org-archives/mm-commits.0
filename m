Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C39C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiILDf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiILDdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E542A271
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80737611AD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64FCC433D7;
        Mon, 12 Sep 2022 03:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953446;
        bh=oJkbnwp3JYzNUONQSxlRjYo0ha+w2cdlecvAfq9tUDs=;
        h=Date:To:From:Subject:From;
        b=fIsmO3qyxAKUSMWE3nX3G5RmNILIQKuJdNAkyysDKXYMkgydyGbzNe6i+Z+PYd2um
         qCJ7GIVLY7EhQJmlKtQMLxwaygINWsarh+g4Vhm/5K7Ple3GOCoI+ZcJkBBkeyFN/+
         javwN3KpdeBYDDjIu0Pp+1vGLIkYvp0SxDUVLh3U=
Date:   Sun, 11 Sep 2022 20:30:46 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-pass-null-to-kobj_to_hstate-if-nid-is-unused.patch removed from -mm tree
Message-Id: <20220912033046.D64FCC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: pass NULL to kobj_to_hstate() if nid is unused
has been removed from the -mm tree.  Its filename was
     hugetlb-pass-null-to-kobj_to_hstate-if-nid-is-unused.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: pass NULL to kobj_to_hstate() if nid is unused
Date: Thu, 1 Sep 2022 20:00:26 +0800

We can pass NULL to kobj_to_hstate() directly when nid is unused to
simplify the code. No functional change intended.

Link: https://lkml.kernel.org/r/20220901120030.63318-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-pass-null-to-kobj_to_hstate-if-nid-is-unused
+++ a/mm/hugetlb.c
@@ -3763,8 +3763,7 @@ HSTATE_ATTR_WO(demote);
 static ssize_t demote_size_show(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
-	int nid;
-	struct hstate *h = kobj_to_hstate(kobj, &nid);
+	struct hstate *h = kobj_to_hstate(kobj, NULL);
 	unsigned long demote_size = (PAGE_SIZE << h->demote_order) / SZ_1K;
 
 	return sysfs_emit(buf, "%lukB\n", demote_size);
@@ -3777,7 +3776,6 @@ static ssize_t demote_size_store(struct
 	struct hstate *h, *demote_hstate;
 	unsigned long demote_size;
 	unsigned int demote_order;
-	int nid;
 
 	demote_size = (unsigned long)memparse(buf, NULL);
 
@@ -3789,7 +3787,7 @@ static ssize_t demote_size_store(struct
 		return -EINVAL;
 
 	/* demote order must be smaller than hstate order */
-	h = kobj_to_hstate(kobj, &nid);
+	h = kobj_to_hstate(kobj, NULL);
 	if (demote_order >= h->order)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

