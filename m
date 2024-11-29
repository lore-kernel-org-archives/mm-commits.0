Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA2E1586C8
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 11:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732878973; cv=none; b=lN9xhA/C6+YLU51TIMzUXaP33otOOhYUa25hPhb3KO7ByQtQhLvjMypUcrx7Z6WtyyDNUmOy0ENx1oUUuhbyzkwrZi24LmzFD9W3KoDsgWeS8NDDa45GQktaJSSei8qIN3MeV/g3JBc9x3vWWamPS2a5vBTyleKaH5kM8I8K/u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732878973; c=relaxed/simple;
	bh=3PJ33Cb4QJIWOXQAJMuBuqOk1CX4man2LAv7Jkj2ULM=;
	h=Date:To:From:Subject:Message-Id; b=XE25vybxk9/2aS13WtLF4ZKV+mGBVWAQkGqmlwaL9qpg7R+Ul3cse+6lU4PSx2ut5SSOafnetaturWa5c38/b+nAgUNxDhx1vduiH+vVqb/w2S1YcYaNWog5fmVVHlLVHtFT/OlJkCovNrE8rmPf910Htrpjw/aQ/EyhgdJHzhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h/D/5LHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h/D/5LHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64628C4CECF;
	Fri, 29 Nov 2024 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732878972;
	bh=3PJ33Cb4QJIWOXQAJMuBuqOk1CX4man2LAv7Jkj2ULM=;
	h=Date:To:From:Subject:From;
	b=h/D/5LHgl48aDM0N/Ftc7ZuAm71FZ2WV7oDs4teCv9leO8qA97kNxLg8201Myc8OY
	 jQbMzHom2tOjcBfhOkdw5RkmiAjfeb7LlS9Vavc8H5I/lrCrOQvhuOitpxpF5/j2Bg
	 0+KnRvNrYi6x2KearjmhXbPuNLntm6YOINXPfUik=
Date: Fri, 29 Nov 2024 03:16:11 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,matteorizzo@google.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,hdanton@sina.com,corbet@lwn.net,boqun.feng@gmail.com,bagasdotme@gmail.com,aliceryhl@google.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-more-warnings-around-page-table-access.patch added to mm-unstable branch
Message-Id: <20241129111612.64628C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: add more warnings around page table access
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-add-more-warnings-around-page-table-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-more-warnings-around-page-table-access.patch

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

docs-mm-add-more-warnings-around-page-table-access.patch

