Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14543C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F045B61528
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346940AbhI2X1v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 19:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347556AbhI2X1u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Sep 2021 19:27:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5C06611C3;
        Wed, 29 Sep 2021 23:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632957968;
        bh=nqTPjWn69EhKXpO0DjhOPyTFbl5hp2ued7CI6VcJtR0=;
        h=Date:From:To:Subject:From;
        b=KfP+E+6AypA8mu1qJSjUHNFvb3OCgah3BMvghUZBKbXloFg5yZQds6aqJt2vl9xiQ
         2WNJQaJz8yi8jLe5rAl72osl+IcefVZpCd8XUtjBezBom63nK7yM+7qatPtoHHhwd1
         IEXSdLLmdqd/9WVFe9x3sBA+MssuQivJy1lU3K3k=
Date:   Wed, 29 Sep 2021 16:26:07 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        corbet@lwn.net, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        rppt@kernel.org, willy@infradead.org, yaozhenguo1@gmail.com
Subject:  +
 =?US-ASCII?Q?hugetlbfs-extend-the-definition-of-hugepages-parameter-to-s?=
 =?US-ASCII?Q?upport-node-allocation-fix.patch?= added to -mm tree
Message-ID: <20210929232607.4Gir0IbWl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix
has been added to the -mm tree.  Its filename is
     hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix

suppress clang warning

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix
+++ a/mm/hugetlb.c
@@ -2939,7 +2939,7 @@ int alloc_bootmem_huge_page(struct hstat
 	__attribute__ ((weak, alias("__alloc_bootmem_huge_page")));
 int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
-	struct huge_bootmem_page *m;
+	struct huge_bootmem_page *m = NULL;	/* initialize for clang */
 	int nr_nodes, node;
 
 	if (nid >= nr_online_nodes)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix.patch
kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

