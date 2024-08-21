Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410C417C211
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724277489; cv=none; b=iCZyNTeIo5jBwOQ7sTTzuFtSWrbqyUduiYMO/p6j8nkorkYUNpTyHc//yX5lUC3uAgnSXd8mqAzRoysy6Pj4RmhBgpYMmgd8bDdCu4uziaYgHYMXjESGcbP5c+W0PYQhpYDOV/DQRyx/OTsIeBtfGqCuM33BDcWHV1RzftiepGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724277489; c=relaxed/simple;
	bh=ng1jNyrQPiTHiJ0s9CU7YiY6zfFECD4x1M6M3H4Fw0I=;
	h=Date:To:From:Subject:Message-Id; b=FmixYZ6RoMpM0k7FEjrXNy0wBo34fxeRPPxbgH/EX8UK3PAZVzO9f11SHg9LfEJCAcbI3NzoucFOjOrGhZzgVIiuhb8RxhwzPZOzoLyzMskTiu9ZW7eEAWcr5Y6UBWq8TkmY1maPYaRLnrXbuOi5wlIJHt0aI41aYdHgEXSpfjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=skocs2+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="skocs2+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC757C32781;
	Wed, 21 Aug 2024 21:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724277488;
	bh=ng1jNyrQPiTHiJ0s9CU7YiY6zfFECD4x1M6M3H4Fw0I=;
	h=Date:To:From:Subject:From;
	b=skocs2+d4U1yl3Z3curriNhL2LXxBniwdiFyK97ceWoktkENqFknymmYCu97oTz3e
	 2ry6eI/QZeBgz3JLnAWrD1rYGHtVbzoXa/wn+6dnneNdh8v5EjgzS0Fb2XV8GFRGWt
	 3do2+jY+zCPSIg8iH9xwXaAy3bup/7Jp0p1ih8AI=
Date: Wed, 21 Aug 2024 14:58:07 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@Huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-unmap_posioned_folio-fix.patch added to mm-unstable branch
Message-Id: <20240821215808.AC757C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-add-unmap_posioned_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-add-unmap_posioned_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-unmap_posioned_folio-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-add-unmap_posioned_folio-fix
Date: Wed Aug 21 02:55:01 PM PDT 2024

s/unmap_posioned_folio/unmap_posioned_folio/, per Miaohe Lin

Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    4 ++--
 mm/memory-failure.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-memory-failure-add-unmap_posioned_folio-fix
+++ a/mm/internal.h
@@ -1049,7 +1049,7 @@ static inline int find_next_best_node(in
  * mm/memory-failure.c
  */
 #ifdef CONFIG_MEMORY_FAILURE
-int unmap_posioned_folio(struct folio *folio, enum ttu_flags ttu);
+int unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu);
 void shake_folio(struct folio *folio);
 extern int hwpoison_filter(struct page *p);
 
@@ -1071,7 +1071,7 @@ void add_to_kill_ksm(struct task_struct
 unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
 #else
-static inline int unmap_posioned_folio(struct folio *folio, enum ttu_flags ttu)
+static inline int unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
 {
 	return 0;
 }
--- a/mm/memory-failure.c~mm-memory-failure-add-unmap_posioned_folio-fix
+++ a/mm/memory-failure.c
@@ -1554,7 +1554,7 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
-int unmap_posioned_folio(struct folio *folio, enum ttu_flags ttu)
+int unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
 {
 	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 		struct address_space *mapping;
@@ -1639,7 +1639,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (unmap_posioned_folio(folio, ttu))
+	if (unmap_poisoned_folio(folio, ttu))
 		pr_info("%#lx: could not lock mapping for mapped huge page\n", pfn);
 
 	unmap_success = !folio_mapped(folio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch
mm-memory-failure-add-unmap_posioned_folio-fix.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

