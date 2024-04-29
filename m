Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50CA74400;
	Mon, 29 Apr 2024 16:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406469; cv=none; b=XQU4t06UHMjo+Uw+EeJvROEofBAoejKG5yDg9LMxW0Uo7UI4T/8MMGtttxeiPWhg3AUQjQudd4+YSau/lVYPQpdeFzdpdFcagCKIE6IynObb3gFke9965J1EXOrxVLYDBQbrmICvMoW36INgxh+Fvp8iTxEw5RdY2ZrTsnRlr9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406469; c=relaxed/simple;
	bh=lxDQhsRt5QjuY4+saXq3yCpJ6Jud3UILT4+yC+cLByM=;
	h=Date:To:From:Subject:Message-Id; b=dsUg0HvVk3iXY/xM8eTlApGGYsxFcbFeLMCVFNESOfUirwI599FkwdRaLw6B86+8fK0qn+s7fz6Q8TmjJjhQnLDmPHlNrVcbzHihGzIEOnWsCyhMckbre3CYsJ4ofyjoz69oPS5pIk1HrOE6gNIzsSR+UhAroJklPpBSZAee8Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dN4lJy6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dN4lJy6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B55C113CD;
	Mon, 29 Apr 2024 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714406468;
	bh=lxDQhsRt5QjuY4+saXq3yCpJ6Jud3UILT4+yC+cLByM=;
	h=Date:To:From:Subject:From;
	b=dN4lJy6bdbqDoXeH5+9KKTJIcoqXFnJMDEQ4K3Zf2s64huxGHIsuFSgUZPzosiDTX
	 +88FtElUbo1jC51YjkDpOvGdzfN5N1tOAZQJLu7yLNaMTgO+Yidj73JDVKlLjzkHk+
	 4OF9epO7gqMl/a3fL6Nf2y6RVuS+yHtkEI4MGpek=
Date: Mon, 29 Apr 2024 09:01:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,riel@surriel.com,peterz@infradead.org,m.novosyolov@rosalinux.ru,mingo@kernel.org,mgorman@techsingularity.net,i.gaptrakhmanov@rosalinux.ru,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bounds-use-the-right-number-of-bits-for-power-of-two-config_nr_cpus.patch added to mm-hotfixes-unstable branch
Message-Id: <20240429160108.56B55C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bounds: use the right number of bits for power-of-two CONFIG_NR_CPUS
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     bounds-use-the-right-number-of-bits-for-power-of-two-config_nr_cpus.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bounds-use-the-right-number-of-bits-for-power-of-two-config_nr_cpus.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: bounds: use the right number of bits for power-of-two CONFIG_NR_CPUS
Date: Mon, 29 Apr 2024 15:47:51 +0100

bits_per() rounds up to the next power of two when passed a power of two. 
This causes crashes on some machines and configurations.

Link: https://lkml.kernel.org/r/20240429144807.3012361-1-willy@infradead.org
Fixes: f2d5dcb48f7b (bounds: support non-power-of-two CONFIG_NR_CPUS)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Михаил Новоселов <m.novosyolov@rosalinux.ru>
Tested-by: Ильфат Гаптрахманов <i.gaptrakhmanov@rosalinux.ru>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3347
Link: https://lore.kernel.org/all/1c978cf1-2934-4e66-e4b3-e81b04cb3571@rosalinux.ru/
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/bounds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bounds.c~bounds-use-the-right-number-of-bits-for-power-of-two-config_nr_cpus
+++ a/kernel/bounds.c
@@ -19,7 +19,7 @@ int main(void)
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 #ifdef CONFIG_SMP
-	DEFINE(NR_CPUS_BITS, bits_per(CONFIG_NR_CPUS));
+	DEFINE(NR_CPUS_BITS, bits_per(CONFIG_NR_CPUS - 1));
 #endif
 	DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
 #ifdef CONFIG_LRU_GEN
_

Patches currently in -mm which might be from willy@infradead.org are

bounds-use-the-right-number-of-bits-for-power-of-two-config_nr_cpus.patch
doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch
mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch
mm-delay-the-check-for-a-null-anon_vma.patch
mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch
mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch
squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch

