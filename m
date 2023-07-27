Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09169EB64DD
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 22:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjG0WMk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjG0WMj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 18:12:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013F52D45
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 15:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8336361F6B
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 22:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBADCC433C8;
        Thu, 27 Jul 2023 22:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690495955;
        bh=KcVyWcLgS5Ex08j2hiLaJqNqh1i8t5/FuowPQa9e6bE=;
        h=Date:To:From:Subject:From;
        b=TNnchduHxZqoSFRSUBjUn3gJbP1ZYJ2uo80qHIP/0PxMI/q3N+d3M8AYvLe28ECF+
         BRPXNJuZ6TQMamBsK4HZYSceIb97PJXWlXd0e6umEcYAQgTE2gVWsGiL2mcYDK6JBN
         zvKrr9WWgg2BkPcPLV5QeMF4mfdgNSsE/xNrGE0Y=
Date:   Thu, 27 Jul 2023 15:12:34 -0700
To:     mm-commits@vger.kernel.org, kirill@shutemov.name, david@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-improve-the-comment-in-isolate_migratepages_block.patch added to mm-unstable branch
Message-Id: <20230727221234.DBADCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve the comment in isolate_migratepages_block()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-improve-the-comment-in-isolate_migratepages_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-improve-the-comment-in-isolate_migratepages_block.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm: improve the comment in isolate_migratepages_block()
Date: Thu, 27 Jul 2023 21:39:44 +0100

A recent patch shows that not everybody understands that "stabilise the
mapping" really means "prevent the mapping from being freed", so change
the wording to hopefully make that more clear.

Link: https://lkml.kernel.org/r/ZMLWEB4m3zvX6SBN@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/compaction.c~mm-improve-the-comment-in-isolate_migratepages_block
+++ a/mm/compaction.c
@@ -1095,13 +1095,13 @@ isolate_migratepages_block(struct compac
 			bool migrate_dirty;
 
 			/*
-			 * Only pages without mappings or that have a
-			 * ->migrate_folio callback are possible to migrate
-			 * without blocking. However, we can be racing with
-			 * truncation so it's necessary to lock the page
-			 * to stabilise the mapping as truncation holds
-			 * the page lock until after the page is removed
-			 * from the page cache.
+			 * Only folios without mappings or that have
+			 * a ->migrate_folio callback are possible to
+			 * migrate without blocking.  However, we may
+			 * be racing with truncation, which can free
+			 * the mapping.  Truncation holds the folio lock
+			 * until after the folio is removed from the page
+			 * cache so holding it ourselves is sufficient.
 			 */
 			if (!folio_trylock(folio))
 				goto isolate_fail_put;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-remove-config_per_vma_lock-ifdefs.patch
mm-allow-per-vma-locks-on-file-backed-vmas.patch
mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch
mm-handle-pud-faults-under-the-vma-lock.patch
mm-handle-some-pmd-faults-under-the-vma-lock.patch
mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch
mm-move-fault_flag_vma_lock-check-down-from-do_fault.patch
mm-run-the-fault-around-code-under-the-vma-lock.patch
mm-handle-swap-and-numa-pte-faults-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock-fix.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch

