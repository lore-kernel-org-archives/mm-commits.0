Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712B71DCB09
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160843; cv=none; b=OwSedE/vTcuYrm3XQKipZz8hJaxmRbXl4JtV4uPJOH8pRIiZbe8w+p0AlYbdJoVLWhzGclW5tznHYwxWXXYHKwZXcjw9PYaVu9+IiGuDk6kj+EaRBoMEyfFeIjWgz90G7xiGD9X1fgn1m7zPlHw91C+C6xurjsMVucjkUFwSj48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160843; c=relaxed/simple;
	bh=WmkRzMAQERnVuHeRP1IJIgrQSH31ZR9HeehB6SDpdic=;
	h=Date:To:From:Subject:Message-Id; b=BArPRz6LzS2Kj1VkXigoFTZKGcdd3JQnq+h6swfm7ogVKFI9y8XlmqFmaAzUqcwOXetY8rPcP+MP1IQYFKSIsnbiI0BjhaAQot16EoDA2N6RRJR6pBk6GxZgF6iIjSYWvMJF+Nexaj0bbeDTZLgNNRQyfempeKlPs6qg5TsEa94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ID85hGO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ID85hGO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2732C4CEEF;
	Sat,  2 Aug 2025 18:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160842;
	bh=WmkRzMAQERnVuHeRP1IJIgrQSH31ZR9HeehB6SDpdic=;
	h=Date:To:From:Subject:From;
	b=ID85hGO3LIcHWLr67GmxcUyccMCBZZQoxjtyP+3rRorHQw3FxD3s/PqvaoSXr/iLG
	 4JtkAVVRIj9agu9BtnAULVv/uHyfjUNmSeOsa0r0uKxti7HeI8gn+6GraH5QcRymiO
	 8wgHWQdEcnbB83hf0ty7Ds0Pr6WAGMav75L09AWU=
Date: Sat, 02 Aug 2025 11:54:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-always-define-vm_sealed.patch removed from -mm tree
Message-Id: <20250802185402.D2732C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: always define VM_SEALED
has been removed from the -mm tree.  Its filename was
     mm-mseal-always-define-vm_sealed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mseal: always define VM_SEALED
Date: Fri, 25 Jul 2025 09:29:41 +0100

Patch series "mseal cleanups", v4.

Perform a number of cleanups to the mseal logic.  Firstly, VM_SEALED is
treated differently from every other VMA flag, it really doesn't make
sense to do this, so we start by making this consistent with everything
else.

Next we place the madvise logic where it belongs - in mm/madvise.c.  It
really makes no sense to abstract this elsewhere.  In doing so, we go to
great lengths to explain very clearly the previously very confusing logic
as to what sealed mappings are impacted here.

In doing so, we retain existing logic regarding treatment of madvise()
discard operations for a sealed, read-only MAP_PRIVATE file-backed
mapping.  This is something we likely need to revisit.

We then abstract out and explain the 'are there are any gaps in this range
in the mm?' check being performed as a prerequisite to mseal being
performed.

Finally, we simplify the actual mseal logic which is really quite
straightforward.

No functional change is intended.


This patch (of 4):

There is no reason to treat VM_SEALED in a special way, in each other case
in which a VMA flag is unavailable due to configuration, we simply assign
that flag to VM_NONE, so make VM_SEALED consistent with all other VMA
flags in this respect.

Additionally, use the next available bit for VM_SEALED, 42, rather than
arbitrarily putting it at 63 and update the declaration to match all other
VMA flags.

No functional change intended.

Link: https://lkml.kernel.org/r/cover.1753431105.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/aeb398a77029b6e7377cd944328bc9bbc3c90537.1753431105.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    6 ++++--
 tools/testing/vma/vma_internal.h |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-mseal-always-define-vm_sealed
+++ a/include/linux/mm.h
@@ -414,8 +414,10 @@ extern unsigned int kobjsize(const void
 #endif
 
 #ifdef CONFIG_64BIT
-/* VM is sealed, in vm_flags */
-#define VM_SEALED	_BITUL(63)
+#define VM_SEALED_BIT	42
+#define VM_SEALED	BIT(VM_SEALED_BIT)
+#else
+#define VM_SEALED	VM_NONE
 #endif
 
 /* Bits set in the VMA until the stack is in its final location */
--- a/tools/testing/vma/vma_internal.h~mm-mseal-always-define-vm_sealed
+++ a/tools/testing/vma/vma_internal.h
@@ -108,8 +108,10 @@ extern unsigned long dac_mmap_min_addr;
 #define CAP_IPC_LOCK         14
 
 #ifdef CONFIG_64BIT
-/* VM is sealed, in vm_flags */
-#define VM_SEALED	_BITUL(63)
+#define VM_SEALED_BIT	42
+#define VM_SEALED	BIT(VM_SEALED_BIT)
+#else
+#define VM_SEALED	VM_NONE
 #endif
 
 #define FIRST_USER_ADDRESS	0UL
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


