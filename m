Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE3F34BA4D;
	Sun, 28 Sep 2025 18:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085541; cv=none; b=nakh3ax8CLmlwdVm3L8ESy6MGoBt6VGaXtDueo0EwNPb+1t2+Zc+4N83S3pjuAVYVvpUn32ZazciZZW+5HZM9Qi9wnneMni0Etv+bQdj+P5xH/qaJg8jNfXMpG3AqaWLAI3NN4rbO5P5NqAOnHMfk//ImLGjd8AsPuPsJlK5j0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085541; c=relaxed/simple;
	bh=7q5Mta8KAnp/6hXeXvDiEvhnXSIMkySBA9jBBlpHpIY=;
	h=Date:To:From:Subject:Message-Id; b=BBoo5cwcOiOF1HQByIGs4W/35mari/SfJrxRGrzo3fm/O3paL5fjZ4KTya+er+UtrUj+4ZuBU+bdq55MOjwd8xwydRv+utRg72jGabyCkxwvnidRT48lTNBTqHz0XY179EcWDjxyaQ5int82SrzBOZXLbmQcTffdNNseidii6vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HbzX4sMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HbzX4sMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF44C4CEF0;
	Sun, 28 Sep 2025 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085540;
	bh=7q5Mta8KAnp/6hXeXvDiEvhnXSIMkySBA9jBBlpHpIY=;
	h=Date:To:From:Subject:From;
	b=HbzX4sMYqyRiSOJe75paeMXp9USae2T/qzWHt7jNzvXrFkRs5HK203iTx9KhLufIx
	 X7anEq8LMAbveh/x85iYotr7qjHo+PuR9Fo7MFD1XSRjFXOPeMvbM+ar7Ev+M35ZVR
	 pVgK3+khve9Oi4Us2qiFG+Vo5wxICsz3aTHpK/Zs=
Date: Sun, 28 Sep 2025 11:52:20 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,stable@vger.kernel.org,ritesh.list@gmail.com,richard.weiyang@gmail.com,david@redhat.com,chengming.zhou@linux.dev,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch removed from -mm tree
Message-Id: <20250928185220.DBF44C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: fix incorrect KSM counter handling in mm_struct during fork
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/ksm: fix incorrect KSM counter handling in mm_struct during fork
Date: Wed, 24 Sep 2025 00:16:59 +0530

Patch series "mm/ksm: Fix incorrect accounting of KSM counters during
fork", v3.

The first patch in this series fixes the incorrect accounting of KSM
counters such as ksm_merging_pages, ksm_rmap_items, and the global
ksm_zero_pages during fork.

The following patch add a selftest to verify the ksm_merging_pages counter
was updated correctly during fork.

Test Results
============
Without the first patch
-----------------------
 # [RUN] test_fork_ksm_merging_page_count
 not ok 10 ksm_merging_page in child: 32

With the first patch
--------------------
 # [RUN] test_fork_ksm_merging_page_count
 ok 10 ksm_merging_pages is not inherited after fork


This patch (of 2):

Currently, the KSM-related counters in `mm_struct`, such as
`ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages`, are inherited
by the child process during fork.  This results in inconsistent
accounting.

When a process uses KSM, identical pages are merged and an rmap item is
created for each merged page.  The `ksm_merging_pages` and
`ksm_rmap_items` counters are updated accordingly.  However, after a fork,
these counters are copied to the child while the corresponding rmap items
are not.  As a result, when the child later triggers an unmerge, there are
no rmap items present in the child, so the counters remain stale, leading
to incorrect accounting.

A similar issue exists with `ksm_zero_pages`, which maintains both a
global counter and a per-process counter.  During fork, the per-process
counter is inherited by the child, but the global counter is not
incremented.  Since the child also references zero pages, the global
counter should be updated as well.  Otherwise, during zero-page unmerge,
both the global and per-process counters are decremented, causing the
global counter to become inconsistent.

To fix this, ksm_merging_pages and ksm_rmap_items are reset to 0 during
fork, and the global ksm_zero_pages counter is updated with the
per-process ksm_zero_pages value inherited by the child.  This ensures
that KSM statistics remain accurate and reflect the activity of each
process correctly.

Link: https://lkml.kernel.org/r/cover.1758648700.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/7b9870eb67ccc0d79593940d9dbd4a0b39b5d396.1758648700.git.donettom@linux.ibm.com
Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each process")
Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/ksm.h~mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork
+++ a/include/linux/ksm.h
@@ -56,8 +56,14 @@ static inline long mm_ksm_zero_pages(str
 static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	/* Adding mm to ksm is best effort on fork. */
-	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm))
+	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
+		long nr_ksm_zero_pages = atomic_long_read(&mm->ksm_zero_pages);
+
+		mm->ksm_merging_pages = 0;
+		mm->ksm_rmap_items = 0;
+		atomic_long_add(nr_ksm_zero_pages, &ksm_zero_pages);
 		__ksm_enter(mm);
+	}
 }
 
 static inline int ksm_execve(struct mm_struct *mm)
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


