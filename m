Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73ECC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbjHKXDu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbjHKXCu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ACB421A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B8A6492D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC684C433C7;
        Fri, 11 Aug 2023 23:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794864;
        bh=gmHyeEpPbp237KMFIHbI4hUnJ/uzSihoA0n3PWZ38Qc=;
        h=Date:To:From:Subject:From;
        b=KLFbAxBDJLk+5S2ViAJsKubgzpHVzNgiXa6VSdtkmqpLmS+0KfiBmRqHE/bm6O0O4
         cDl69gOyPa5rSuIKHBVPZ2rNWq9iyY10vfbX94BsPBdXcB+btpGwfqncRHeGv5D4GZ
         feGSB1RX1nPy1oroV6RLS4OUaGfngBmseWwjAtxQ=
Date:   Fri, 11 Aug 2023 16:01:03 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        agruenba@redhat.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch removed from -mm tree
Message-Id: <20230811230103.EC684C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: highmem: add memcpy_to_folio() and memcpy_from_folio()
has been removed from the -mm tree.  Its filename was
     highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: highmem: add memcpy_to_folio() and memcpy_from_folio()
Date: Thu, 13 Jul 2023 04:55:06 +0100

Patch series "More filesystem folio conversions for 6.6".

Remove the only spots in affs which actually use a struct page; there
are a few places where one is mentioned, but it's part of the interface.

The rest of this is removing the remaining calls to set_bh_page(),
and then removing the function before any new users show up.


This patch (of 7):

These are the folio equivalent of memcpy_to_page() and memcpy_from_page().

[agruenba@redhat.com: use correct chunk size in memcpy()]
  Link: https://lkml.kernel.org/r/20230802144354.1023099-1-agruenba@redhat.com
Link: https://lkml.kernel.org/r/20230713035512.4139457-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230713035512.4139457-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   44 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/include/linux/highmem.h~highmem-add-memcpy_to_folio-and-memcpy_from_folio
+++ a/include/linux/highmem.h
@@ -439,6 +439,50 @@ static inline void memzero_page(struct p
 	kunmap_local(addr);
 }
 
+static inline void memcpy_from_folio(char *to, struct folio *folio,
+		size_t offset, size_t len)
+{
+	VM_BUG_ON(offset + len > folio_size(folio));
+
+	do {
+		const char *from = kmap_local_folio(folio, offset);
+		size_t chunk = len;
+
+		if (folio_test_highmem(folio) &&
+		    chunk > PAGE_SIZE - offset_in_page(offset))
+			chunk = PAGE_SIZE - offset_in_page(offset);
+		memcpy(to, from, chunk);
+		kunmap_local(from);
+
+		from += chunk;
+		offset += chunk;
+		len -= chunk;
+	} while (len > 0);
+}
+
+static inline void memcpy_to_folio(struct folio *folio, size_t offset,
+		const char *from, size_t len)
+{
+	VM_BUG_ON(offset + len > folio_size(folio));
+
+	do {
+		char *to = kmap_local_folio(folio, offset);
+		size_t chunk = len;
+
+		if (folio_test_highmem(folio) &&
+		    chunk > PAGE_SIZE - offset_in_page(offset))
+			chunk = PAGE_SIZE - offset_in_page(offset);
+		memcpy(to, from, chunk);
+		kunmap_local(to);
+
+		from += chunk;
+		offset += chunk;
+		len -= chunk;
+	} while (len > 0);
+
+	flush_dcache_folio(folio);
+}
+
 /**
  * memcpy_from_file_folio - Copy some bytes from a file folio.
  * @to: The destination buffer.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

