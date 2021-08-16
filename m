Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410EDC432BE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E94760F58
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhHPXaN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 19:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234793AbhHPX37 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 19:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99F9A606A5;
        Mon, 16 Aug 2021 23:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629156567;
        bh=7L9rXGv3KxXs06L5bSMFnDhPcAim44b0a6O0m3Oggbw=;
        h=Date:From:To:Subject:From;
        b=hy50QUG7DSmWu8s2U2wB2joomc1CzDuvAL5bw+zdm6tPQnjiuU8JFP7kA7GG8fJQX
         oHguJuYaXRcZYphqxsbKo+RONKOl6rledUKM/Ep1VASAzXwgr/yUN7YkIGGvvESZdM
         GUHo0vClq2chFWh5rfCetzdRZdmcQpZCBd8B2MLo=
Date:   Mon, 16 Aug 2021 16:29:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        songmuchun@bytedance.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        mike.kravetz@oracle.com
Subject:  + hugetlb-document-the-demote-sysfs-interfaces.patch added
 to -mm tree
Message-ID: <20210816232927.CGY5S%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: document the demote sysfs interfaces
has been added to the -mm tree.  Its filename is
     hugetlb-document-the-demote-sysfs-interfaces.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-document-the-demote-sysfs-interfaces.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-document-the-demote-sysfs-interfaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: document the demote sysfs interfaces

Describe demote and demote_size interfaces.

Link: https://lkml.kernel.org/r/20210816224953.157796-6-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/hugetlbpage.rst |   29 +++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~hugetlb-document-the-demote-sysfs-interfaces
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -234,8 +234,12 @@ will exist, of the form::
 
 	hugepages-${size}kB
 
-Inside each of these directories, the same set of files will exist::
+Inside each of these directories, the set of files contained in ``/proc``
+will exist.  In addition, two additional interfaces for demoting huge
+pages will exist::
 
+        demote
+        demote_size
 	nr_hugepages
 	nr_hugepages_mempolicy
 	nr_overcommit_hugepages
@@ -243,7 +247,28 @@ Inside each of these directories, the sa
 	resv_hugepages
 	surplus_hugepages
 
-which function as described above for the default huge page-sized case.
+The demote interfaces provide the ability to split a huge page into
+smaller huge pages.  For example, the x86 architecture supports both
+1GB and 2MB huge pages sizes.  A 1GB huge page can be split into 512
+2MB huge pages.  The demote interfaces are:
+
+demote_size
+        is the size of demoted pages.  When a page is demoted a corresponding
+        number of huge pages of demote_size will be created.  For huge pages
+        of the smallest supported size (2MB on x86), demote_size will be the
+        system page size (PAGE_SIZE).  If demote_size is the system page size
+        then demoting a page will simply free the huge page.  demote_size is
+        a read only interface.
+
+demote
+        is used to demote a number of huge pages.  A user with root privileges
+        can write to this file.  It may not be possible to demote the
+        requested number of huge pages.  To determine how many pages were
+        actually demoted, compare the value of nr_hugepages before and after
+        writing to the demote interface.  demote is a write only interface.
+
+The interfaces which are the same as in ``/proc`` function as described
+above for the default huge page-sized case.
 
 .. _mem_policy_and_hp_alloc:
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch
hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-document-the-demote-sysfs-interfaces.patch
hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch
hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch
hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch

