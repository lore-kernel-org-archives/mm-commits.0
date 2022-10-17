Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1ABC43219
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiJQUkG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiJQUjb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:39:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4104F4E862
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90EBD61284
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C72C433D7;
        Mon, 17 Oct 2022 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039014;
        bh=kTEA/u+0m9ptLgvxufhdJHs6/H/If87Q4uasFvFvWoQ=;
        h=Date:To:From:Subject:From;
        b=rmuOhvg+w3tZygBAHG9HDNK/31AhnS+8deLKH5+OBQrmkgs8Ap802ab6145Mdw2dO
         JftHMfukBMyvD0NNrKWaotRxNXV5AVN+KEpfZXN1WCw6G91WcrObQGdzMsPumaq81G
         DN1lJun+V0g2ePfFE+UtSV3IFn4tcV5T4zm+SlnI=
Date:   Mon, 17 Oct 2022 13:36:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-private-field-of-first-tail-to-struct-page-and-struct-folio.patch added to mm-unstable branch
Message-Id: <20221017203653.E0C72C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add private field of first tail to struct page and struct folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-private-field-of-first-tail-to-struct-page-and-struct-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-private-field-of-first-tail-to-struct-page-and-struct-folio.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: add private field of first tail to struct page and struct folio
Date: Thu, 22 Sep 2022 10:42:04 -0500

Allow struct folio to store hugetlb metadata that is contained in the
private field of the first tail page.  On 32-bit, _private_1 aligns with
page[1].private.

Link: https://lkml.kernel.org/r/20220922154207.1575343-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/mm_types.h~mm-add-private-field-of-first-tail-to-struct-page-and-struct-folio
+++ a/include/linux/mm_types.h
@@ -144,6 +144,7 @@ struct page {
 			atomic_t compound_pincount;
 #ifdef CONFIG_64BIT
 			unsigned int compound_nr; /* 1 << compound_order */
+			unsigned long _private_1;
 #endif
 		};
 		struct {	/* Second tail page of compound page */
@@ -264,6 +265,7 @@ struct page {
  * @_total_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
  * @_folio_nr_pages: Do not use directly, call folio_nr_pages().
+ * @_private_1: Do not use directly, call folio_get_private_1().
  *
  * A folio is a physically, virtually and logically contiguous set
  * of bytes.  It is a power-of-two in size, and it is aligned to that
@@ -311,6 +313,7 @@ struct folio {
 #ifdef CONFIG_64BIT
 	unsigned int _folio_nr_pages;
 #endif
+	unsigned long _private_1;
 };
 
 #define FOLIO_MATCH(pg, fl)						\
@@ -338,6 +341,7 @@ FOLIO_MATCH(compound_mapcount, _total_ma
 FOLIO_MATCH(compound_pincount, _pincount);
 #ifdef CONFIG_64BIT
 FOLIO_MATCH(compound_nr, _folio_nr_pages);
+FOLIO_MATCH(_private_1, _private_1);
 #endif
 #undef FOLIO_MATCH
 
@@ -383,6 +387,16 @@ static inline void *folio_get_private(st
 	return folio->private;
 }
 
+static inline void folio_set_private_1(struct folio *folio, unsigned long private)
+{
+	folio->_private_1 = private;
+}
+
+static inline unsigned long folio_get_private_1(struct folio *folio)
+{
+	return folio->_private_1;
+}
+
 struct page_frag_cache {
 	void * va;
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-add-folio-support-to-hugetlb-specific-flag-macros.patch
mm-add-private-field-of-first-tail-to-struct-page-and-struct-folio.patch
mm-hugetlb-add-hugetlb_folio_subpool-helpers.patch
hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch
mm-hugetlb-add-folio_hstate.patch
mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

