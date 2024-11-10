Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD513B58F
	for <mm-commits@vger.kernel.org>; Sun, 10 Nov 2024 06:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731219279; cv=none; b=Z9YfH3IoMtafteKHgFOMaquDjWmXzVx4gim+KNra1t9N0DW5jih+EJQn7I14TFXfhucgRTWDw5BPK991tWVu+ezvcHSfdBB2pm9PVUOyprih7Geci3wKG8PkT5YrpWV2sXQ+mP3Pe+QHVCi+/KcgwQwy9MtHthMJLuMpZtLkjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731219279; c=relaxed/simple;
	bh=K3FbkFD8ATwL1H2JA4xX3lWaFTH2/DhpFptSYgFExgQ=;
	h=Date:To:From:Subject:Message-Id; b=OLuJiuCt7xCX3Xs0+6l8U7v4sRVgDeW5ODeXZE+pgqUcwdt4UfphUvKQ9vEZaPm1ANFIfG/zdKASaTBWu8tppiaCMbZRuUwmY/jpjXkOrnvXFuVH5bNJ1qmq9cOfUj+MQjt3QMDEZvpW/D1Mr691GHP4CsoynMSzXn1ElzbnBGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ttMKuIZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ttMKuIZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60984C4CECD;
	Sun, 10 Nov 2024 06:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731219279;
	bh=K3FbkFD8ATwL1H2JA4xX3lWaFTH2/DhpFptSYgFExgQ=;
	h=Date:To:From:Subject:From;
	b=ttMKuIZEr8hXuMxPWEXpkOU3qMsG6I2FjhqExKbG+ZYImnSiCzSQ8n5LvVc1zLjqv
	 U0ZSMFzOECbN3KL8V9qBxM6aLyUUC2YuoAUKPHlr61nLXqvRFvRgJCjRvqg4hl8kPZ
	 oJCll/21TAT/i4465KMqHCtpwF/L/hPk5AchxFmM=
Date: Sat, 09 Nov 2024 22:14:38 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,Liam.Howlett@Oracle.com,jannh@google.com,hdanton@sina.com,corbet@lwn.net,boqun.feng@gmail.com,bagasdotme@gmail.com,aliceryhl@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-vma-locks-documentation-fix.patch added to mm-unstable branch
Message-Id: <20241110061439.60984C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: minor corrections
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-add-vma-locks-documentation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-vma-locks-documentation-fix.patch

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
@@ -291,7 +291,7 @@ typically refer to the leaf level as the
 	  compiler might, in practice, eliminate any code relating to missing
 	  ones.
 
-There are free key operations typically performed on page tables:
+There are four key operations typically performed on page tables:
 
 1. **Traversing** page tables - Simply reading page tables in order to traverse
    them. This only requires that the VMA is kept stable, so a lock which
@@ -513,11 +513,11 @@ When performing a page table traversal a
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

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch
docs-mm-add-vma-locks-documentation.patch
docs-mm-add-vma-locks-documentation-fix.patch

