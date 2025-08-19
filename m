Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB62353349
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642432; cv=none; b=qew0FbeHl+2WzAZhS5POdjUS/aWzWuy8SF2yB/WQI963v20YQNnZJAl0MTgD9NG5vJdbOSTIf2EmVrPniCimPErciqiDtaHLCeywP0A2a27NfkH9LbOxBbCK0UnZdWdrMByrY0CrlFLQyVqRN7FYBmwX4ozxmMXD+rgQ9/b3sQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642432; c=relaxed/simple;
	bh=hFdgS6Axq0/ybCjYY3kxV+gS4MYK9GJrTTC4r/T5NIw=;
	h=Date:To:From:Subject:Message-Id; b=RQgf/0+r7nJDvTt4RmlT3LK6cHc/VjONxkle9HbJYex2X5EM2aZC65xV063RW9kpJ/+UJhlaqCW8alHa7JNXbSuwYR82q9gbk/Z0fdKXD1FMEdzGpXG46sSrJpP8T7B4nrMUJNhlyZA5PPeO4qTvHFt6+2/cyIzBtHf1R9gavto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1suLn5l+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1suLn5l+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8286CC4CEF1;
	Tue, 19 Aug 2025 22:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755642431;
	bh=hFdgS6Axq0/ybCjYY3kxV+gS4MYK9GJrTTC4r/T5NIw=;
	h=Date:To:From:Subject:From;
	b=1suLn5l+VLzZ35Zu0zujKhhjdV9qDM9PcJigVgZlNFtai/rQibeQI/61yHQtk1EGd
	 Co0y/0dZ/dxo5eHBGKDA3WvvATPkilb9ll+4LT3AnEkAes9Z27Xz5FITM2KgPtJqqB
	 6PPayEKIpxtT8bPda9rHZ+tEK0ipZhrSbamcFxHs=
Date: Tue, 19 Aug 2025 15:27:10 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-migratepage_unmap-fix.patch added to mm-unstable branch
Message-Id: <20250819222711.8286CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: mm/migrate: remove MIGRATEPAGE_UNMAP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-migratepage_unmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-migratepage_unmap-fix.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/migrate: remove MIGRATEPAGE_UNMAP
Date: Mon, 18 Aug 2025 13:26:05 +0200

no need to pass "reason" to migrate_folio_unmap(), per Lance

Link: https://lkml.kernel.org/r/3bb725f8-28d7-4aa2-b75f-af40d5cab280@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-migratepage_unmap-fix
+++ a/mm/migrate.c
@@ -1189,7 +1189,7 @@ static void migrate_folio_done(struct fo
 static int migrate_folio_unmap(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		enum migrate_reason reason, struct list_head *ret)
+		struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1876,8 +1876,7 @@ static int migrate_pages_batch(struct li
 			}
 
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, reason,
-					ret_folios);
+					private, folio, &dst, mode, ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,
_

Patches currently in -mm which might be from david@redhat.com are

mm-mremap-fix-warn-with-uffd-that-has-remap-events-disabled.patch
mm-migrate-remove-migratepage_unmap.patch
mm-migrate-remove-migratepage_unmap-fix.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch

