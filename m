Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461B54A11
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 21:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699683; cv=none; b=fc0jn6INz2s4Y/9tl5VusOqPrJYfB6coohp1gyupyCg1U84cwupRavfjxDWLeCAc7G4B8Nzc1VEh2xegxfUz9w3DAWL49TdudRaGvSDeYDMz7QWuoDvL7vzlz4+NoMTmDskxtDBXtPBhnVjoVQzIOgzl71tnBtVufqvKI9OBT0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699683; c=relaxed/simple;
	bh=aClz7pQD1i8VGdbiHkS/jQ7PREoa+7nt6nA/3MBiaGY=;
	h=Date:To:From:Subject:Message-Id; b=aWRNnMSnLN8wrIPPTCCHjvSYkWCSfHaA3tgGqAFSHge3KQYh7WSRx+G5ZVDOwxPgNdqaBRajQcPTgAzEu0wguAfG02ffE5964JB8odFq7jRq0zYWj+HASF5BplKx6BsD1o+tpnOeaMbQEqGlnGhRj4hAYuwTURUe0ijhBs0X+3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LFUfZ5cV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LFUfZ5cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3950C4CEE7;
	Wed, 16 Jul 2025 21:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752699680;
	bh=aClz7pQD1i8VGdbiHkS/jQ7PREoa+7nt6nA/3MBiaGY=;
	h=Date:To:From:Subject:From;
	b=LFUfZ5cVQo6SPXxOPleRa0Tdzcvmpkt3JiQw0vbQBfPjcSxus5uYP6MSQs/ak5sUg
	 4LSTJwsKqrvYMsyuU5KICZzimZbeQrKzwUhmGyP7HmkCC7w83bTAEcT8J0Td92s19j
	 L/rla4BKFqX9c57hgRMQb86SqSDQHxw9PYWojDSY=
Date: Wed, 16 Jul 2025 14:01:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-always-define-vm_sealed.patch added to mm-new branch
Message-Id: <20250716210120.B3950C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: always define VM_SEALED
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-always-define-vm_sealed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-always-define-vm_sealed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/mseal: always define VM_SEALED
Date: Wed, 16 Jul 2025 18:38:02 +0100

Patch series "mseal cleanups, fixup MAP_PRIVATE file-backed case", v3.

Perform a number of cleanups to the mseal logic.  Firstly, VM_SEALED is
treated differently from every other VMA flag, it really doesn't make
sense to do this, so we start by making this consistent with everything
else.

Next we place the madvise logic where it belongs - in mm/madvise.c.  It
really makes no sense to abstract this elsewhere.  In doing so, we go to
great lengths to explain very clearly the previously very confusing logic
as to what sealed mappings are impacted here.

In doing so, we fix an existing logical oversight - previously we
permitted an madvise() discard operation for a sealed, read-only
MAP_PRIVATE file-backed mapping.

However this is incorrect. To see why consider:

1. A MAP_PRIVATE R/W file-backed mapping is established.
2. The mapping is written to, which backs it with anonymous memory.
3. The mapping is mprotect()'d read-only.
4. The mapping is mseal()'d.

At this point you have data that, once sealed, a user cannot alter, but a
discard operation can unrecoverably remove.  This contradicts the
semantics of mseal(), so should not be permitted.

We then abstract out and explain the 'are there are any gaps in this range
in the mm?' check being performed as a prerequisite to mseal being
performed.

Finally, we simplify the actual mseal logic which is really quite
straightforward.


This patch (of 5):

There is no reason to treat VM_SEALED in a special way, in each other case
in which a VMA flag is unavailable due to configuration, we simply assign
that flag to VM_NONE, so make VM_SEALED consistent with all other VMA
flags in this respect.

Additionally, use the next available bit for VM_SEALED, 42, rather than
arbitrarily putting it at 63 and update the declaration to match all other
VMA flags.

No functional change intended.

Link: https://lkml.kernel.org/r/cover.1752687069.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/d0e9b39c9d1abceb0ffac341c6fae96186c5d843.1752687069.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
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

mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix-2.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

