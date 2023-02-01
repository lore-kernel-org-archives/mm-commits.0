Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D402C636CC
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjBAAit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjBAAis (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:38:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275F93A91
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:38:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6F9EB81ED8
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BACC433D2;
        Wed,  1 Feb 2023 00:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675211924;
        bh=7GFTF9dqvjM53eHOfHsW0xUFhDTk//Izq8cF6TB1mJ0=;
        h=Date:To:From:Subject:From;
        b=M6SMPQ22dHKRei8UF8xC/t+E/L5HW5bJxtu0Rk7Y7tTSGptXhJtQO4UyoEUjeR7vh
         DkavNrfPbDiGRppyiI3+Xdap8VyP1VNYhfnbBgusuMY9c2TxuuhxFRK2Dgywtic8I/
         DOFoFkMCDMg/v7y746gmKGyyMpO45UxdePchYChs=
Date:   Tue, 31 Jan 2023 16:38:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, songmuchun@bytedance.com,
        shy828301@gmail.com, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, mhocko@suse.com, lkp@intel.com,
        jthoughton@google.com, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2.patch removed from -mm tree
Message-Id: <20230201003844.82BACC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2.patch

This patch was dropped because it was folded into mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2
Date: Sun Jan 29 01:08:55 PM PST 2023

hugetlb.h: include page_ref.h for page_count()

Reported-by: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2
+++ a/include/linux/hugetlb.h
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
+#include <linux/page_ref.h>
 #include <linux/list.h>
 #include <linux/kref.h>
 #include <linux/pgtable.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

