Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D59A31
	for <mm-commits@vger.kernel.org>; Sun,  8 Sep 2024 04:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725769283; cv=none; b=JkGtZK0tWe8MqIhhcikBsEnMErb1AogPe6yljTM48KS95bNHmedyHpG0KKRluzjiL36uxEIF20XeAT+tgu5snL48O2deGNjMl0kRTTZ+iaA/xz3G5t3X3Y3FdOfmqahYSabaX8PERS/wq7/3XnkcD79Dk8OfcPhhuoxy2zRTCXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725769283; c=relaxed/simple;
	bh=Y642D2n3PthR+/V+bpkpt8S3eSOoTwlpxsl6CgI+HEU=;
	h=Date:To:From:Subject:Message-Id; b=cGnQY/ux0Hw0c9v5E4Yhme82A+/sybzvA45e9I25wEk0hhOwiU+0n/vInvh8OPrY4dT4H2jyzUEGtsBnNOvhsEAmXtkZnhIqq5Yw8ZW72E0kUQng2rhvtkA407yG8F/34nsJS5OwjDxF+u5RabSpbEh3AL9L/rGYGwKNBMt1ujQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fwXsJo10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fwXsJo10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88058C4CEC3;
	Sun,  8 Sep 2024 04:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725769282;
	bh=Y642D2n3PthR+/V+bpkpt8S3eSOoTwlpxsl6CgI+HEU=;
	h=Date:To:From:Subject:From;
	b=fwXsJo10cZfPuBKiWJEU+dHbDtoPKpNZp+qN5e0jmVI200tl06GtNbbYBuLjqI5QI
	 K9v1gJyNtRxKav60fuLlhZV2NfZHaGrVqslQ/+cluGVjNma3PYWP4DMXfibp6DKrm4
	 5onmp4TgfRPCrAHCMznDVMTyyJN7BXH/yNEWXiOU=
Date: Sat, 07 Sep 2024 21:21:21 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jiaqiyan@google.com,jane.chu@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-poison-recovery-from-copy_present_page.patch added to mm-unstable branch
Message-Id: <20240908042122.88058C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support poison recovery from copy_present_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-poison-recovery-from-copy_present_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-poison-recovery-from-copy_present_page.patch

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
Subject: mm: support poison recovery from copy_present_page()
Date: Fri, 6 Sep 2024 10:42:01 +0800

Similar to other poison recovery, use copy_mc_user_highpage() to avoid
potentially kernel panic during copy page in copy_present_page() from
fork, once copy failed due to hwpoison in source page, we need to break
out of copy in copy_pte_range() and release prealloc folio, so
copy_mc_user_highpage() is moved ahead before set *prealloc to NULL.

Link: https://lkml.kernel.org/r/20240906024201.1214712-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-support-poison-recovery-from-copy_present_page
+++ a/mm/memory.c
@@ -926,8 +926,11 @@ copy_present_page(struct vm_area_struct
 	 * We have a prealloc page, all good!  Take it
 	 * over and copy the page & arm it.
 	 */
+
+	if (copy_mc_user_highpage(&new_folio->page, page, addr, src_vma))
+		return -EHWPOISON;
+
 	*prealloc = NULL;
-	copy_user_highpage(&new_folio->page, page, addr, src_vma);
 	__folio_mark_uptodate(new_folio);
 	folio_add_new_anon_rmap(new_folio, dst_vma, addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(new_folio, dst_vma);
@@ -1166,8 +1169,9 @@ again:
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
+		 * If copy failed due to hwpoison in source page, break out.
 		 */
-		if (unlikely(ret == -EAGAIN))
+		if (unlikely(ret == -EAGAIN || ret == -EHWPOISON))
 			break;
 		if (unlikely(prealloc)) {
 			/*
@@ -1197,7 +1201,7 @@ again:
 			goto out;
 		}
 		entry.val = 0;
-	} else if (ret == -EBUSY) {
+	} else if (ret == -EBUSY || unlikely(ret == -EHWPOISON)) {
 		goto out;
 	} else if (ret ==  -EAGAIN) {
 		prealloc = folio_prealloc(src_mm, src_vma, addr, false);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch
mm-migrate-remove-unused-includes.patch
mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-copy_present_page.patch

