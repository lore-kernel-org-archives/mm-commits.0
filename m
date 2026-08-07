Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E330B3A6417
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068096; cv=none; b=J9QIZMv8o7wFlSTKdWK61YWHiHtFcIQNuTisGEulSECT5UX+j2Xtietsn7qtQOBdbVi5RkUAQdHSbHz5WaVkisdee2BRe4cgE6NY+2nYiGr5h+CmqrG0/hT/pTf6IxtNnFKeYG1Ed4OZPCEnWS5YD8lv4HZk0or+K8Z7Y9IhqUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068096; c=relaxed/simple;
	bh=8Aq48uK6RYVJ5apwg6aghKsVZC7qaIIg3vToGVAy41g=;
	h=Date:To:From:Subject:Message-Id; b=XxjwjliDnvCIveeKRkOaaEEaB1g+HZfpr0ApSRstlh8VEFnWDKMynRAvLJ1i2sY+URTv92mDatnBG7uWXbcjFNirED/Fe1ZdZh1pXXYvkPXsABq7xUqYjPYI0MU0EziI9/jSkW2dFrENAKSq0uyWXt/pbUJXY0fvod2b/m6n1lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Siu0/ae1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Siu0/ae1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03181F00ACF;
	Fri,  7 Aug 2026 02:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068094;
	bh=dgS4zKE1jGaNbyRNcob6AIFrfMZdPirfCJ7JO2RwFJk=;
	h=Date:To:From:Subject;
	b=Siu0/ae14vh8NmlZ0FpdNFaqwi50Rp2bpjQmQ9jzcwQHPVUrsKQqzURE4tg2Z5Hjx
	 t7mNT/pTMajqcu3hejqrnWGGLYqTo8mUV+u6pkaHuLCfR0NpspYHtF/47wTbEOV6hu
	 Dn5O0D7Xt7pYgJYmh6gX08p+Ybulpx912iSyFHOU=
Date: Thu, 06 Aug 2026 19:01:34 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,kees@kernel.org,jannh@google.com,jack@suse.cz,david@kernel.org,brauner@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch removed from -mm tree
Message-Id: <20260807020134.B03181F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: limit scope of mseal address zero to address zero
has been removed from the -mm tree.  Its filename was
     mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mseal: limit scope of mseal address zero to address zero
Date: Fri, 17 Jul 2026 18:27:10 +0100

Commit 44f65d900698 ("binfmt_elf: mseal address zero") unconditionally
provided do_mseal() to any internal kernel caller in order to address a
corner case slated for possible removal.

It also incorrectly attempts to mseal without checking to see whether the
mapping even succeeded.

Restrict the scope to the corner case by providing mseal_mmap_page_zero()
which asserts the MMAP_PAGE_ZERO personality.

Avoid unnecessary checks in the start, end range by abstracting the actual
mseal()'ing to mseal_range() and have mseal_mmap_page_zero() call that
instead.

Also only try to seal the VMA if we mapped the VMA.  This isn't strictly
necessary as the operation would error out anyway, but it's useless work
and could be problematic if me make future changes to mseal semantics.

Link: https://lore.kernel.org/20260717-mseal-fixups-v2-2-0daa0014b813@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c    |    7 +-----
 include/linux/mm.h |    8 +------
 mm/mseal.c         |   49 ++++++++++++++++++++++++++++++-------------
 3 files changed, 39 insertions(+), 25 deletions(-)

--- a/fs/binfmt_elf.c~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/fs/binfmt_elf.c
@@ -1353,11 +1353,8 @@ out_free_interp:
 		   emulate the SVr4 behavior. Sigh. */
 		error = vm_mmap(NULL, 0, PAGE_SIZE, PROT_READ | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE, 0);
-
-		retval = do_mseal(0, PAGE_SIZE, 0);
-		if (retval)
-			pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
-					    task_pid_nr(current), retval);
+		if (!error)
+			mseal_mmap_page_zero();
 	}
 
 	regs = current_pt_regs();
--- a/include/linux/mm.h~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/include/linux/mm.h
@@ -5291,13 +5291,9 @@ int reserve_mem_find_by_name(const char
 int reserve_mem_release_by_name(const char *name);
 
 #ifdef CONFIG_64BIT
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags);
+void mseal_mmap_page_zero(void);
 #else
-static inline int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
-{
-	/* noop on 32 bit */
-	return 0;
-}
+static inline void mseal_mmap_page_zero(void) {}
 #endif
 
 /*
--- a/mm/mseal.c~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/mm/mseal.c
@@ -32,7 +32,7 @@ static bool range_contains_unmapped(unsi
 	return prev_end < end;
 }
 
-static int mseal_apply(unsigned long start, unsigned long end)
+static int __mseal_range(unsigned long start, unsigned long end)
 {
 	VMA_ITERATOR(vmi, current->mm, start);
 	struct vm_area_struct *vma, *prev;
@@ -66,6 +66,38 @@ static int mseal_apply(unsigned long sta
 	return 0;
 }
 
+static int mseal_range(unsigned long start, unsigned long end)
+{
+	int err;
+
+	err = mmap_write_lock_killable(current->mm);
+	if (err)
+		return err;
+	if (range_contains_unmapped(start, end))
+		err = -ENOMEM;
+	else
+		err = __mseal_range(start, end);
+	mmap_write_unlock(current->mm);
+	return err;
+}
+
+/**
+ * mseal_mmap_page_zero() - If the MMAP_PAGE_ZERO personality is set, mseal()
+ * the page mapped at address zero.
+ */
+void mseal_mmap_page_zero(void)
+{
+	int err;
+
+	if (WARN_ON_ONCE(!(current->personality & MMAP_PAGE_ZERO)))
+		return;
+
+	err = mseal_range(0, PAGE_SIZE);
+	if (err)
+		pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
+				    task_pid_nr(current), err);
+}
+
 /*
  * mseal(2) seals the VM's meta data from
  * selected syscalls.
@@ -118,11 +150,9 @@ static int mseal_apply(unsigned long sta
  *
  *  unseal() is not supported.
  */
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
-	struct mm_struct *mm = current->mm;
 	unsigned long end;
-	int ret = 0;
 	size_t len;
 
 	/* Verify flags not set. */
@@ -145,16 +175,7 @@ int do_mseal(unsigned long start, size_t
 	if (end == start)
 		return 0;
 
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
-	if (range_contains_unmapped(start, end))
-		ret = -ENOMEM;
-	else
-		ret = mseal_apply(start, end);
-
-	mmap_write_unlock(mm);
-	return ret;
+	return mseal_range(start, end);
 }
 
 SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

