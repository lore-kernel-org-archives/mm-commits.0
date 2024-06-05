Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1907A55E49
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 03:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717558299; cv=none; b=a50QZ+v1rcvkezUJHY7+Brpfg1189zd+4yIHHkCCvWt08kNzK3xwFJstiKo6tg9k0ZSNOGv8yWEBYyTnVkAtRsSs+sgXuWvcRkvKvE5TsAevGbW8pzHmb0RjoBp/ZZnbLMcgBgw4aJjJEb4tuurLnzcXMBbBsIjF4TWkbGYeYCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717558299; c=relaxed/simple;
	bh=D+rONpxmViYhT7px9GQT75UhL/o2A2/gqE8Jpp7Zlns=;
	h=Date:To:From:Subject:Message-Id; b=l+4xbd4l0z04lvKMLTdXXpK7SVJulMIPHkTzTnwoImf8Z7z6lIggBQoEhLltcgwFNeHDW0wlaqiRg8WosgH7HbLgzx/4S1PQ7SvPz3UpHB/umhcnc0tQqGerDYTmgzBjTEH+D+gvUy/3+Uxdn+J5ziWsseQRaHI3YbwGKEuJum0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SJugIuZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SJugIuZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B24CC32781;
	Wed,  5 Jun 2024 03:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717558298;
	bh=D+rONpxmViYhT7px9GQT75UhL/o2A2/gqE8Jpp7Zlns=;
	h=Date:To:From:Subject:From;
	b=SJugIuZF+AspdFTNyQt0M2SVpB1wWOzsuWmDabjiKUOuVlnPRTqhPGwRm48SOwyH+
	 OdmxOR3qzakDDoMkzSe2SMmJ5VBCo37UGUKox0l8W1B1Fd9PZmR1OuqEcxJ7ZCHjgC
	 w0/NviZ3UiMw4QngqdPw4ZZAEuL5Pp6erM9IRr5c=
Date: Tue, 04 Jun 2024 20:31:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_mc_copy.patch added to mm-unstable branch
Message-Id: <20240605033138.9B24CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add folio_mc_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_mc_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_mc_copy.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add folio_mc_copy()
Date: Mon, 3 Jun 2024 17:24:35 +0800

Add a #MC variant of folio_copy() which uses copy_mc_highpage() to support
#MC handled during folio copy, it will be used in folio migration soon.

Link: https://lkml.kernel.org/r/20240603092439.3360652-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/util.c          |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/mm.h~mm-add-folio_mc_copy
+++ a/include/linux/mm.h
@@ -1311,6 +1311,7 @@ void put_pages_list(struct list_head *pa
 
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
+int folio_mc_copy(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
--- a/mm/util.c~mm-add-folio_mc_copy
+++ a/mm/util.c
@@ -828,6 +828,23 @@ void folio_copy(struct folio *dst, struc
 }
 EXPORT_SYMBOL(folio_copy);
 
+int folio_mc_copy(struct folio *dst, struct folio *src)
+{
+	long nr = folio_nr_pages(src);
+	long i = 0;
+
+	for (;;) {
+		if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
+			return -EHWPOISON;
+		if (++i == nr)
+			break;
+		cond_resched();
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(folio_mc_copy);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 int sysctl_overcommit_ratio __read_mostly = 50;
 unsigned long sysctl_overcommit_kbytes __read_mostly;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

