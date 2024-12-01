Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAFE14A84
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 07:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733036511; cv=none; b=JLw+Z4fse2/seoe0iqFjiqfmzPGpN6CQ9V+pZlXQZ6pal1T6KCwyxB1lHaBTi4cWdmZXbNu933+lF8GkcBVleWGnJnMKcoRDLT7yHqGqCMAMXi5SM58QVh15D7c+i42ejYCA0kDcQwNMfX86P35btHcWsgTLcuRpQpcdbUklAzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733036511; c=relaxed/simple;
	bh=u5z2hE0glLvJycWCuEM+Z+1pUzqKoL6Gx6WdZ7lJPV8=;
	h=Date:To:From:Subject:Message-Id; b=OhOyQrjv63GvCEairLvy5QMvkB+29V7V152pirU9NKmortUiV7UCCJ83htVtlX6CuyRceJfG1Vkj6Q+/HYVBptUUSLtlcD34At/Ca+LFYz5VJze11m7xjO2ChJFUWUjT/DLwHzuD/3vgvgW0nUtK02OveZ9Vx00xDnbOH1MrbPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mkQhN6sY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mkQhN6sY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3E3C4CED2;
	Sun,  1 Dec 2024 07:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733036511;
	bh=u5z2hE0glLvJycWCuEM+Z+1pUzqKoL6Gx6WdZ7lJPV8=;
	h=Date:To:From:Subject:From;
	b=mkQhN6sY5Bic2yfH5VkgAq1n0WGU6C04IQjOOt0rMplVwJQnyDT3pbkKlDv/ytN1t
	 +upTdM3JMkhr2mS4cEo+GGqPvaxmmw0zKzwjZ3r4kcjTUESjK0nh+6R/xywqIrhhcw
	 nd0O46Bh7ReMKuJGeIsC6RsvBqTAcwcLBFut03gs=
Date: Sat, 30 Nov 2024 23:01:50 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,Liam.Howlett@Oracle.com,jannh@google.com,hdanton@sina.com,corbet@lwn.net,boqun.feng@gmail.com,bagasdotme@gmail.com,aliceryhl@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-add-vma-locks-documentation-fix.patch removed from -mm tree
Message-Id: <20241201070151.1D3E3C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: minor corrections
has been removed from the -mm tree.  Its filename was
     docs-mm-add-vma-locks-documentation-fix.patch

This patch was dropped because it was folded into docs-mm-add-vma-locks-documentation-v3.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: docs/mm: minor corrections
Date: Sat, 9 Nov 2024 15:52:55 +0000

Rename a section to avoid confusion with the address_space type, fix a typo, and
reword a mangled sentence.

Link: https://lkml.kernel.org/r/d3de735a-25ae-4eb2-866c-a9624fe6f795@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-add-vma-locks-documentation-fix
+++ a/Documentation/mm/process_addrs.rst
@@ -68,8 +68,8 @@ described below).
 
 Stabilising a VMA also keeps the address space described by it around.
 
-Using address space locks
--------------------------
+Lock usage
+----------
 
 If you want to **read** VMA metadata fields or just keep the VMA stable, you
 must do one of the following:
@@ -298,7 +298,7 @@ typically refer to the leaf level as the
 	  compiler might, in practice, eliminate any code relating to missing
 	  ones.
 
-There are free key operations typically performed on page tables:
+There are four key operations typically performed on page tables:
 
 1. **Traversing** page tables - Simply reading page tables in order to traverse
    them. This only requires that the VMA is kept stable, so a lock which
@@ -525,11 +525,11 @@ When performing a page table traversal a
 read must be performed once and only once or not depends on the architecture
 (for instance x86-64 does not require any special precautions).
 
-It is on the write side, or if a read informs whether a write takes place (on an
-installation of a page table entry say, for instance in
-:c:func:`!__pud_install`), where special care must always be taken. In these
-cases we can never assume that page table locks give us entirely exclusive
-access, and must retrieve page table entries once and only once.
+If a write is being performed, or if a read informs whether a write takes place
+(on an installation of a page table entry say, for instance in
+:c:func:`!__pud_install`), special care must always be taken. In these cases we
+can never assume that page table locks give us entirely exclusive access, and
+must retrieve page table entries once and only once.
 
 If we are reading page table entries, then we need only ensure that the compiler
 does not rearrange our loads. This is achieved via :c:func:`!pXXp_get`
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correct-typo-in-mmap_state-macro.patch
docs-mm-add-vma-locks-documentation.patch
docs-mm-add-vma-locks-documentation-v3.patch

