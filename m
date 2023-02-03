Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89F0C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjBCGmI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbjBCGkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BEB8FB47
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56BF9B828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02992C4339B;
        Fri,  3 Feb 2023 06:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406258;
        bh=K1O3r+EaQWaxRWThfcyJi/Qc2CMjRQKybyDPYzA0NK4=;
        h=Date:To:From:Subject:From;
        b=RVQcd5yfUTMfhfjMO/Qer5/DzeoCPw2SiDvDP2dJUaq5vJ1U3ihjGYTsnt7Wlwsyf
         0x128TyoYl1n5ZfygweOmllphLRXpo0SsqzBbuw6aMApZ6hdIoiPh+Vt4VmFNXYUlF
         ejNWgAEz9WumnUqUdQX8bpv7XJg6JW27paE2cel4=
Date:   Thu, 02 Feb 2023 22:37:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_evictable.patch removed from -mm tree
Message-Id: <20230203063738.02992C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove page_evictable()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_evictable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_evictable()
Date: Mon, 16 Jan 2023 19:28:24 +0000

Patch series "Remove leftover mlock/munlock page wrappers".

We no longer need the various mlock page functions as all callers have
folios.


This patch (of 4):

This function now has no users.  Also update the unevictable-lru
documentation to discuss folios instead of pages (mostly).

[akpm@linux-foundation.org: fix Documentation/mm/unevictable-lru.rst underlining]
  Link: https://lkml.kernel.org/r/20230117145106.585b277b@canb.auug.org.au
Link: https://lkml.kernel.org/r/20230116192827.2146732-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230116192827.2146732-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/unevictable-lru.rst~mm-remove-page_evictable
+++ a/Documentation/mm/unevictable-lru.rst
@@ -12,7 +12,7 @@ Introduction
 
 This document describes the Linux memory manager's "Unevictable LRU"
 infrastructure and the use of this to manage several types of "unevictable"
-pages.
+folios.
 
 The document attempts to provide the overall rationale behind this mechanism
 and the rationale for some of the design decisions that drove the
@@ -27,8 +27,8 @@ The Unevictable LRU
 ===================
 
 The Unevictable LRU facility adds an additional LRU list to track unevictable
-pages and to hide these pages from vmscan.  This mechanism is based on a patch
-by Larry Woodman of Red Hat to address several scalability problems with page
+folios and to hide these folios from vmscan.  This mechanism is based on a patch
+by Larry Woodman of Red Hat to address several scalability problems with folio
 reclaim in Linux.  The problems have been observed at customer sites on large
 memory x86_64 systems.
 
@@ -52,40 +52,41 @@ The infrastructure may also be able to h
 unevictable, either by definition or by circumstance, in the future.
 
 
-The Unevictable LRU Page List
------------------------------
+The Unevictable LRU Folio List
+------------------------------
 
-The Unevictable LRU page list is a lie.  It was never an LRU-ordered list, but a
-companion to the LRU-ordered anonymous and file, active and inactive page lists;
-and now it is not even a page list.  But following familiar convention, here in
-this document and in the source, we often imagine it as a fifth LRU page list.
+The Unevictable LRU folio list is a lie.  It was never an LRU-ordered
+list, but a companion to the LRU-ordered anonymous and file, active and
+inactive folio lists; and now it is not even a folio list.  But following
+familiar convention, here in this document and in the source, we often
+imagine it as a fifth LRU folio list.
 
 The Unevictable LRU infrastructure consists of an additional, per-node, LRU list
-called the "unevictable" list and an associated page flag, PG_unevictable, to
-indicate that the page is being managed on the unevictable list.
+called the "unevictable" list and an associated folio flag, PG_unevictable, to
+indicate that the folio is being managed on the unevictable list.
 
 The PG_unevictable flag is analogous to, and mutually exclusive with, the
-PG_active flag in that it indicates on which LRU list a page resides when
+PG_active flag in that it indicates on which LRU list a folio resides when
 PG_lru is set.
 
-The Unevictable LRU infrastructure maintains unevictable pages as if they were
+The Unevictable LRU infrastructure maintains unevictable folios as if they were
 on an additional LRU list for a few reasons:
 
- (1) We get to "treat unevictable pages just like we treat other pages in the
+ (1) We get to "treat unevictable folios just like we treat other folios in the
      system - which means we get to use the same code to manipulate them, the
      same code to isolate them (for migrate, etc.), the same code to keep track
      of the statistics, etc..." [Rik van Riel]
 
- (2) We want to be able to migrate unevictable pages between nodes for memory
+ (2) We want to be able to migrate unevictable folios between nodes for memory
      defragmentation, workload management and memory hotplug.  The Linux kernel
-     can only migrate pages that it can successfully isolate from the LRU
+     can only migrate folios that it can successfully isolate from the LRU
      lists (or "Movable" pages: outside of consideration here).  If we were to
-     maintain pages elsewhere than on an LRU-like list, where they can be
-     detected by isolate_lru_page(), we would prevent their migration.
+     maintain folios elsewhere than on an LRU-like list, where they can be
+     detected by folio_isolate_lru(), we would prevent their migration.
 
-The unevictable list does not differentiate between file-backed and anonymous,
-swap-backed pages.  This differentiation is only important while the pages are,
-in fact, evictable.
+The unevictable list does not differentiate between file-backed and
+anonymous, swap-backed folios.  This differentiation is only important
+while the folios are, in fact, evictable.
 
 The unevictable list benefits from the "arrayification" of the per-node LRU
 lists and statistics originally proposed and posted by Christoph Lameter.
@@ -158,7 +159,7 @@ These are currently used in three places
 Detecting Unevictable Pages
 ---------------------------
 
-The function page_evictable() in mm/internal.h determines whether a page is
+The function folio_evictable() in mm/internal.h determines whether a folio is
 evictable or not using the query function outlined above [see section
 :ref:`Marking address spaces unevictable <mark_addr_space_unevict>`]
 to check the AS_UNEVICTABLE flag.
@@ -167,7 +168,7 @@ For address spaces that are so marked af
 might be), the lock action (e.g. SHM_LOCK) can be lazy, and need not populate
 the page tables for the region as does, for example, mlock(), nor need it make
 any special effort to push any pages in the SHM_LOCK'd area to the unevictable
-list.  Instead, vmscan will do this if and when it encounters the pages during
+list.  Instead, vmscan will do this if and when it encounters the folios during
 a reclamation scan.
 
 On an unlock action (such as SHM_UNLOCK), the unlocker (e.g. shmctl()) must scan
@@ -176,41 +177,43 @@ condition is keeping them unevictable.
 the pages are also "rescued" from the unevictable list in the process of
 freeing them.
 
-page_evictable() also checks for mlocked pages by testing an additional page
-flag, PG_mlocked (as wrapped by PageMlocked()), which is set when a page is
-faulted into a VM_LOCKED VMA, or found in a VMA being VM_LOCKED.
+folio_evictable() also checks for mlocked folios by calling
+folio_test_mlocked(), which is set when a folio is faulted into a
+VM_LOCKED VMA, or found in a VMA being VM_LOCKED.
 
 
-Vmscan's Handling of Unevictable Pages
---------------------------------------
+Vmscan's Handling of Unevictable Folios
+---------------------------------------
 
-If unevictable pages are culled in the fault path, or moved to the unevictable
-list at mlock() or mmap() time, vmscan will not encounter the pages until they
+If unevictable folios are culled in the fault path, or moved to the unevictable
+list at mlock() or mmap() time, vmscan will not encounter the folios until they
 have become evictable again (via munlock() for example) and have been "rescued"
 from the unevictable list.  However, there may be situations where we decide,
-for the sake of expediency, to leave an unevictable page on one of the regular
+for the sake of expediency, to leave an unevictable folio on one of the regular
 active/inactive LRU lists for vmscan to deal with.  vmscan checks for such
-pages in all of the shrink_{active|inactive|page}_list() functions and will
-"cull" such pages that it encounters: that is, it diverts those pages to the
+folios in all of the shrink_{active|inactive|page}_list() functions and will
+"cull" such folios that it encounters: that is, it diverts those folios to the
 unevictable list for the memory cgroup and node being scanned.
 
-There may be situations where a page is mapped into a VM_LOCKED VMA, but the
-page is not marked as PG_mlocked.  Such pages will make it all the way to
-shrink_active_list() or shrink_page_list() where they will be detected when
-vmscan walks the reverse map in folio_referenced() or try_to_unmap().  The page
-is culled to the unevictable list when it is released by the shrinker.
-
-To "cull" an unevictable page, vmscan simply puts the page back on the LRU list
-using putback_lru_page() - the inverse operation to isolate_lru_page() - after
-dropping the page lock.  Because the condition which makes the page unevictable
-may change once the page is unlocked, __pagevec_lru_add_fn() will recheck the
-unevictable state of a page before placing it on the unevictable list.
+There may be situations where a folio is mapped into a VM_LOCKED VMA,
+but the folio does not have the mlocked flag set.  Such folios will make
+it all the way to shrink_active_list() or shrink_page_list() where they
+will be detected when vmscan walks the reverse map in folio_referenced()
+or try_to_unmap().  The folio is culled to the unevictable list when it
+is released by the shrinker.
+
+To "cull" an unevictable folio, vmscan simply puts the folio back on
+the LRU list using folio_putback_lru() - the inverse operation to
+folio_isolate_lru() - after dropping the folio lock.  Because the
+condition which makes the folio unevictable may change once the folio
+is unlocked, __pagevec_lru_add_fn() will recheck the unevictable state
+of a folio before placing it on the unevictable list.
 
 
 MLOCKED Pages
 =============
 
-The unevictable page list is also useful for mlock(), in addition to ramfs and
+The unevictable folio list is also useful for mlock(), in addition to ramfs and
 SYSV SHM.  Note that mlock() is only available in CONFIG_MMU=y situations; in
 NOMMU situations, all mappings are effectively mlocked.
 
--- a/mm/internal.h~mm-remove-page_evictable
+++ a/mm/internal.h
@@ -159,17 +159,6 @@ static inline bool folio_evictable(struc
 	return ret;
 }
 
-static inline bool page_evictable(struct page *page)
-{
-	bool ret;
-
-	/* Prevent address_space of inode and swap cache from being freed */
-	rcu_read_lock();
-	ret = !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
-	rcu_read_unlock();
-	return ret;
-}
-
 /*
  * Turn a non-refcounted page (->_refcount == 0) into refcounted with
  * a count of one.
_

Patches currently in -mm which might be from willy@infradead.org are


