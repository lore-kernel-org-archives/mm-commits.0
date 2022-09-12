Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4079FECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiILDgE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiILDdx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D218286D2
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46DFDB80C81
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75EDC433D7;
        Mon, 12 Sep 2022 03:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953451;
        bh=d1/TbLVr70Ulnu+Ouy0WURPC1dF6Bpi92CSWasoISB0=;
        h=Date:To:From:Subject:From;
        b=e9Fvd5dR0BFYDsCfoLx3haZ+q2ZnAwf4sFvpY789n6NeyfH2SvUh3oY5vjk9A6vvn
         PY5vdq9Ak3Rpfk8qqBUpYxGIBiPkWDMkpUdsHOyiOPDoyY88YEx9dmQMNNMjEwCHBn
         DP/XsX/jZuuh2mAh/Jk+b7z4swr63sbRQVzzPGlQ=
Date:   Sun, 11 Sep 2022 20:30:51 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch removed from -mm tree
Message-Id: <20220912033051.D75EDC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: make hugetlb depends on SYSFS or SYSCTL
has been removed from the -mm tree.  Its filename was
     hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: make hugetlb depends on SYSFS or SYSCTL
Date: Thu, 1 Sep 2022 20:00:30 +0800

If CONFIG_SYSFS and CONFIG_SYSCTL are both undefined, hugetlb doesn't work
now as there's no way to set max huge pages. Make sure at least one of the
above configs is defined to make hugetlb works as expected.

Link: https://lkml.kernel.org/r/20220901120030.63318-11-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/Kconfig~hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl
+++ a/fs/Kconfig
@@ -235,6 +235,7 @@ config ARCH_SUPPORTS_HUGETLBFS
 config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
+	depends on (SYSFS || SYSCTL)
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
 	  ramfs. For architectures that support it, say Y here and read
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

