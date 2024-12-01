Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB2C14A84
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 07:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733036514; cv=none; b=Bjn1I0FoXHJq8IH2juqDpwmfPAJ2fXn3KPkVmIJosWnJKjS3Q4OUkNhvAV7GLKQpEbcmudS9HqA8pr6GPJUGrARrQt3O4uzIqiuodFpDyntPS3aw3RtCRoB2JvzYjQIzAkOE5BaGksqiRMS6s1y0vZo5VLHtIOvtOmG9qMaLi7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733036514; c=relaxed/simple;
	bh=A9WiwUOBdqJ51hh4e6nyZBInvKv+WRx0HzwLSnfGW3s=;
	h=Date:To:From:Subject:Message-Id; b=f8HwjtgVGmUXDNPGZwGgUSbJ25TodohYA5WohlJHDm95jlkyGxUQUoAyGpamcQGs59nbWTm0iG5JtULLumFh3SK9vfeezPz9oYZUC6kWwqPoNNC3lzR3UIXSeDHxzepzLnpjCZlYMA6pFkhW0WCo84sU4BB4zxzPIviOp9ZwDRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bDalUfbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bDalUfbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46702C4CECF;
	Sun,  1 Dec 2024 07:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733036514;
	bh=A9WiwUOBdqJ51hh4e6nyZBInvKv+WRx0HzwLSnfGW3s=;
	h=Date:To:From:Subject:From;
	b=bDalUfbtCDyS6aNdfEMjl9hD0PYryDepJjDHNQMmPXcyawxTEomahRJaMOG6vlvBM
	 TPyiBifT/TUVk1BSLilP90HhL4ZoXA393pEwjHg16nZTN+eSX8RIn4ficVXq3cDpz5
	 d0ZCHqegkM6Fpzte2tf/FEjH0ytk+6vjX5GtagGQ=
Date: Sat, 30 Nov 2024 23:01:53 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,matteorizzo@google.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,hdanton@sina.com,corbet@lwn.net,boqun.feng@gmail.com,bagasdotme@gmail.com,aliceryhl@google.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-add-more-warnings-around-page-table-access.patch removed from -mm tree
Message-Id: <20241201070154.46702C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: add more warnings around page table access
has been removed from the -mm tree.  Its filename was
     docs-mm-add-more-warnings-around-page-table-access.patch

This patch was dropped because it was folded into docs-mm-add-vma-locks-documentation-v3.patch

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: docs/mm: add more warnings around page table access
Date: Mon, 18 Nov 2024 17:47:08 +0100

Make it clearer that holding the mmap lock in read mode is not enough to
traverse page tables, and that just having a stable VMA is not enough to
read PTEs.

Link: https://lkml.kernel.org/r/20241118-vma-docs-addition1-onv3-v2-1-c9d5395b72ee@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Suggested-by: Matteo Rizzo <matteorizzo@google.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |   46 +++++++++++++++++++++------
 1 file changed, 36 insertions(+), 10 deletions(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-add-more-warnings-around-page-table-access
+++ a/Documentation/mm/process_addrs.rst
@@ -339,6 +339,11 @@ When **installing** page table entries,
 keep the VMA stable. We explore why this is in the page table locking details
 section below.
 
+.. warning:: Page tables are normally only traversed in regions covered by VMAs.
+             If you want to traverse page tables in areas that might not be
+             covered by VMAs, heavier locking is required.
+             See :c:func:`!walk_page_range_novma` for details.
+
 **Freeing** page tables is an entirely internal memory management operation and
 has special requirements (see the page freeing section below for more details).
 
@@ -450,6 +455,9 @@ the time of writing of this document.
 Locking Implementation Details
 ------------------------------
 
+.. warning:: Locking rules for PTE-level page tables are very different from
+             locking rules for page tables at other levels.
+
 Page table locking details
 --------------------------
 
@@ -470,8 +478,12 @@ additional locks dedicated to page table
 These locks represent the minimum required to interact with each page table
 level, but there are further requirements.
 
-Importantly, note that on a **traversal** of page tables, no such locks are
-taken. Whether care is taken on reading the page table entries depends on the
+Importantly, note that on a **traversal** of page tables, sometimes no such
+locks are taken. However, at the PTE level, at least concurrent page table
+deletion must be prevented (using RCU) and the page table must be mapped into
+high memory, see below.
+
+Whether care is taken on reading the page table entries depends on the
 architecture, see the section on atomicity below.
 
 Locking rules
@@ -489,12 +501,6 @@ We establish basic locking rules when in
   the warning below).
 * As mentioned previously, zapping can be performed while simply keeping the VMA
   stable, that is holding any one of the mmap, VMA or rmap locks.
-* Special care is required for PTEs, as on 32-bit architectures these must be
-  mapped into high memory and additionally, careful consideration must be
-  applied to racing with THP, migration or other concurrent kernel operations
-  that might steal the entire PTE table from under us. All this is handled by
-  :c:func:`!pte_offset_map_lock` (see the section on page table installation
-  below for more details).
 
 .. warning:: Populating previously empty entries is dangerous as, when unmapping
              VMAs, :c:func:`!vms_clear_ptes` has a window of time between
@@ -509,8 +515,28 @@ We establish basic locking rules when in
 There are additional rules applicable when moving page tables, which we discuss
 in the section on this topic below.
 
-.. note:: Interestingly, :c:func:`!pte_offset_map_lock` holds an RCU read lock
-          while the PTE page table lock is held.
+PTE-level page tables are different from page tables at other levels, and there
+are extra requirements for accessing them:
+
+* On 32-bit architectures, they may be in high memory (meaning they need to be
+  mapped into kernel memory to be accessible).
+* When empty, they can be unlinked and RCU-freed while holding an mmap lock or
+  rmap lock for reading in combination with the PTE and PMD page table locks.
+  In particular, this happens in :c:func:`!retract_page_tables` when handling
+  :c:macro:`!MADV_COLLAPSE`.
+  So accessing PTE-level page tables requires at least holding an RCU read lock;
+  but that only suffices for readers that can tolerate racing with concurrent
+  page table updates such that an empty PTE is observed (in a page table that
+  has actually already been detached and marked for RCU freeing) while another
+  new page table has been installed in the same location and filled with
+  entries. Writers normally need to take the PTE lock and revalidate that the
+  PMD entry still refers to the same PTE-level page table.
+
+To access PTE-level page tables, a helper like :c:func:`!pte_offset_map_lock` or
+:c:func:`!pte_offset_map` can be used depending on stability requirements.
+These map the page table into kernel memory if required, take the RCU lock, and
+depending on variant, may also look up or acquire the PTE lock.
+See the comment on :c:func:`!__pte_offset_map_lock`.
 
 Atomicity
 ^^^^^^^^^
_

Patches currently in -mm which might be from jannh@google.com are

docs-mm-add-vma-locks-documentation-v3.patch

