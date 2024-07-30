Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCEB18E030
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722377846; cv=none; b=SZrvymeEkWOB9Pta0WXNYG6o7pS41Oa0FcwoiGl5GSGp4F2g+1ZU+9LL2ydOsDR+1l4kGYscO8xRYReGguH69VgpVF40XbHg8mASDvLEJiqr5za4ieTcewPlp4PX0duHGfHTDbBeZw/u7DOYJnTIADfQ7V7TIxNXtVbaRormYBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722377846; c=relaxed/simple;
	bh=ZB+zMmE9XocdagS/+xnUjoTAnzcTs+XxfoMoPkKN2kw=;
	h=Date:To:From:Subject:Message-Id; b=tzTwhZG/YACpv4r3/lcJT3hh+y+pySNU4+HR8WoizhfGTaoV3aiHua0HzZ7Ef8p0ulg50yIPUBS6tM/t0XLf//CaSta5Yka1FNUbWs/0kO7/ZuieyW0pkRc3mzg4425nmzwP80mMrFbq8Kmswb8Rp5btNoBHCTCRHovsw1QQiHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dsHof1uo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dsHof1uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B002C4AF09;
	Tue, 30 Jul 2024 22:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722377846;
	bh=ZB+zMmE9XocdagS/+xnUjoTAnzcTs+XxfoMoPkKN2kw=;
	h=Date:To:From:Subject:From;
	b=dsHof1uomzh1Z0m7t4UAmRrwLiRp9DV1B9erOEKjFd7FcEjPVkZPZaawsEe7IKvTs
	 UOvhOpp2ndzcIdTD1T3VlokY1XFxdLnztMUHGVqyOvhQgRCJOdyR+GxU68l+s98hEO
	 kY2y2GYyOwajz0+ldlhDrJNWigQzxT4L0MVFtsBI=
Date: Tue, 30 Jul 2024 15:17:25 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-let-pte_lockptr-consume-a-pte_t-pointer-fix.patch removed from -mm tree
Message-Id: <20240730221726.2B002C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-let-pte_lockptr-consume-a-pte_t-pointer-fix
has been removed from the -mm tree.  Its filename was
     mm-let-pte_lockptr-consume-a-pte_t-pointer-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-let-pte_lockptr-consume-a-pte_t-pointer-fix
Date: Mon, 29 Jul 2024 10:43:34 +0200

Let's adjust the comment, passing a pte to pte_lockptr() and dropping
a detail about changed *pmd, which no longer applies.

Link: https://lkml.kernel.org/r/498c936f-fa30-4670-9bbc-4cd8b7995091@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/pgtable-generic.c~mm-let-pte_lockptr-consume-a-pte_t-pointer-fix
+++ a/mm/pgtable-generic.c
@@ -350,11 +350,11 @@ pte_t *pte_offset_map_nolock(struct mm_s
  * pte_offset_map_nolock(mm, pmd, addr, ptlp), above, is like pte_offset_map();
  * but when successful, it also outputs a pointer to the spinlock in ptlp - as
  * pte_offset_map_lock() does, but in this case without locking it.  This helps
- * the caller to avoid a later pte_lockptr(mm, *pmd), which might by that time
- * act on a changed *pmd: pte_offset_map_nolock() provides the correct spinlock
- * pointer for the page table that it returns.  In principle, the caller should
- * recheck *pmd once the lock is taken; in practice, no callsite needs that -
- * either the mmap_lock for write, or pte_same() check on contents, is enough.
+ * the caller to avoid a later pte_lockptr(mm, pte): pte_offset_map_nolock()
+ * provides the correct spinlock pointer for the page table that it returns.
+ * In principle, the caller should recheck *pmd once the lock is taken; in
+ * practice, no callsite needs that - either the mmap_lock for write, or
+ * pte_same() check on contents, is enough.
  *
  * Note that free_pgtables(), used after unmapping detached vmas, or when
  * exiting the whole mm, does not take page table lock before freeing a page
_

Patches currently in -mm which might be from david@redhat.com are

mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch
mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch

