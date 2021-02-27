Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061C6C4332B
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C690064F1F
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhB0Cdl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhB0Cde (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:33:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7199C64F34;
        Sat, 27 Feb 2021 02:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393161;
        bh=dtjfKolQ/m+CVPcCaDcHA9KHo9FoxMzmxra5DL7t9Eo=;
        h=Date:From:To:Subject:From;
        b=AC1ivAMYGQw4mK3cWqB+vI7k7l/hN2+n6AjZ+rAVYYhhGCj6wNuqjbSE+rk606VRn
         Q+vj1/BNn702lDajl1qN8C0JZ67WmzpKYB3q6eH14R1j9al48OFnHbkLR09wismh7u
         5B9XiqB9aGmWyr17yL3f0rVUh4EmBM28Wa085irY=
Date:   Fri, 26 Feb 2021 18:32:41 -0800
From:   akpm@linux-foundation.org
To:     ira.weiny@intel.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged] fs-coredump-use-kmap_local_page.patch removed
 from -mm tree
Message-ID: <20210227023241.kzTi7E1NG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coredump: use kmap_local_page()
has been removed from the -mm tree.  Its filename was
     fs-coredump-use-kmap_local_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: fs/coredump: use kmap_local_page()

In dump_user_range() there is no reason for the mapping to be global.  Use
kmap_local_page() rather than kmap.

Link: https://lkml.kernel.org/r/20210203223328.558945-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/coredump.c~fs-coredump-use-kmap_local_page
+++ a/fs/coredump.c
@@ -897,10 +897,10 @@ int dump_user_range(struct coredump_para
 		 */
 		page = get_dump_page(addr);
 		if (page) {
-			void *kaddr = kmap(page);
+			void *kaddr = kmap_local_page(page);
 
 			stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
-			kunmap(page);
+			kunmap_local(kaddr);
 			put_page(page);
 		} else {
 			stop = !dump_skip(cprm, PAGE_SIZE);
_

Patches currently in -mm which might be from ira.weiny@intel.com are

mm-highmem-remove-deprecated-kmap_atomic.patch

