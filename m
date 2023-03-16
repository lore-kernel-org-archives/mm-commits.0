Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B126FC6FD1F
	for <mm-commits@archiver.kernel.org>; Thu, 16 Mar 2023 22:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCPWkT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Mar 2023 18:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCPWkT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2023 18:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37916E20C1
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 15:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51F856206F
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 22:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F80EC433EF;
        Thu, 16 Mar 2023 22:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679006390;
        bh=lU5n0DzjM+870E+keRsEetWtH/X0xdVHBOnjSiSW5s4=;
        h=Date:To:From:Subject:From;
        b=az8z9Ppbt6uuZn4z48qUcOiAEBRAGZTYU8/BPE6WHRTABDJmrGnrxkCdKFIBtJrb3
         G+LryYJJLXNhTJkIqrKEBrRCTgTIJPLYFke5ABIwOqdpebWGl7TbZQ+RNy+xTDXb0S
         d0EJri3L+JDW3YHkx926+2oCiB5dOaK4UMypdSVg=
Date:   Thu, 16 Mar 2023 15:39:49 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, david@redhat.com,
        aneesh.kumar@linux.ibm.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch added to mm-unstable branch
Message-Id: <20230316223950.9F80EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix
Date: Thu, 16 Mar 2023 11:18:25 -0400

fix comment, per David.

Link: https://lkml.kernel.org/r/ZBMzQW674oHQJV7F@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/huge_memory.c~mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix
+++ a/mm/huge_memory.c
@@ -460,10 +460,6 @@ static int __init hugepage_init(void)
 	struct kobject *hugepage_kobj;
 
 	if (!has_transparent_hugepage()) {
-		/*
-		 * Hardware doesn't support hugepages, hence disable
-		 * DAX PMD support.
-		 */
 		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from peterx@redhat.com are

kselftest-vm-fix-unused-variable-warning.patch
tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

