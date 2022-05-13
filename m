Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49722C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383801AbiEMTVp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383851AbiEMTVQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE6238B0
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1CC63CE330E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745DDC34100;
        Fri, 13 May 2022 19:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469672;
        bh=WBw1RLQ5h2g1YApZZIUzdsnk3YlyjLJ6lFAjeAppuNc=;
        h=Date:To:From:Subject:From;
        b=e3WYO+iXe26fBwo6cZP4VRi/7y7j/E7ea/4n5wKuAWdfxeL8+wMKrP1FtdH5wpjC1
         PdC53Oz41OoK7h+65C38QVeZkz7awflDBPkglQEJjoaDkoKtddKUcYwYTGGcWRicsf
         QBrbYCV8un5JBCV3Oc4wur/X1h4gKms3ZNFI4t2I=
Date:   Fri, 13 May 2022 12:21:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-enable-pte-markers-by-default.patch removed from -mm tree
Message-Id: <20220513192112.745DDC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: enable PTE markers by default
has been removed from the -mm tree.  Its filename was
     mm-enable-pte-markers-by-default.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: enable PTE markers by default

Enable PTE markers by default.  On x86_64 it means it'll auto-enable
PTE_MARKER_UFFD_WP as well.

[peterx@redhat.com: hide PTE_MARKER option]
  Link: https://lkml.kernel.org/r/20220419202531.27415-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220405014929.15158-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/Kconfig~mm-enable-pte-markers-by-default
+++ a/mm/Kconfig
@@ -910,14 +910,16 @@ config ANON_VMA_NAME
 	  difference in their name.
 
 config PTE_MARKER
-	bool "Marker PTEs support"
+	bool
 
 	help
 	  Allows to create marker PTEs for file-backed memory.
 
 config PTE_MARKER_UFFD_WP
-	bool "Marker PTEs support for userfaultfd write protection"
-	depends on PTE_MARKER && HAVE_ARCH_USERFAULTFD_WP
+	bool "Userfaultfd write protection support for shmem/hugetlbfs"
+	default y
+	depends on HAVE_ARCH_USERFAULTFD_WP
+	select PTE_MARKER
 
 	help
 	  Allows to create marker PTEs for userfaultfd write protection
_

Patches currently in -mm which might be from peterx@redhat.com are


