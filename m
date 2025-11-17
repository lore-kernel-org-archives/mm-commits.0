Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CBF30C60A
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 22:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419425; cv=none; b=fp7skE4v9d8bSfidAsXY4CyyqEn10d4Ma7k2Pe28OAuOprGLDgI4xEfBOFdqk/pM5BwcJVzIg1U0M84WXcc34A3tLSu+OjyPf3OCqnZ1Vh4cOdLx5ui6kxbxjGCiYzJgynrNPil78KHDVFO1Wr1yc+P8w1Hk4BXVdpCB2vHSDSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419425; c=relaxed/simple;
	bh=DwlYzpNOh/BqI1ZIXX/F5DWcR8DiMBuw/8vblSsaKmQ=;
	h=Date:To:From:Subject:Message-Id; b=AjRxrxfhITm7YHe3QnVeVtG4r3xd74qvi8SlgxrCgemG2hI6kW7p6rHWVH8649bqTYE4uQmi6onVHVa4E5Bdde3x8RlFWf7fNroCWS6OwoVKt1WzzUVSCkvXuR/uAQGvdVEsF+ynR2wv2x896RMGcErKktufEL69KlK41rI8Ak8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tid9bo12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tid9bo12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E95C2BC86;
	Mon, 17 Nov 2025 22:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763419424;
	bh=DwlYzpNOh/BqI1ZIXX/F5DWcR8DiMBuw/8vblSsaKmQ=;
	h=Date:To:From:Subject:From;
	b=Tid9bo127W5ROw+Ekx3Wj7gU95rC974GKFJUKZPXGYxq9aWWx6Pxi8vFPS52adwav
	 F851LW5qHn/aUvAtyOmXC00sNXqp0ykgcZNZPHpBejcbgpLO6kWEXMZ4+5YmegCt1E
	 TChlovrPKOr3v6szHr3ZLMZGkhmFUJ5mtlQVIRwA=
Date: Mon, 17 Nov 2025 14:43:42 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,pfalcato@suse.de,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,avagin@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-implement-sticky-vma-flags-fix-2.patch added to mm-unstable branch
Message-Id: <20251117224344.91E95C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-implement-sticky-vma-flags-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-implement-sticky-vma-flags-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-implement-sticky-vma-flags-fix-2.patch

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
Subject: mm-implement-sticky-vma-flags-fix-2
Date: Mon Nov 17 02:39:35 PM PST 2025

fix comments, per Lorenzo

Link: https://lkml.kernel.org/r/cf58c518-05d0-494f-8fe4-571879834031@lucifer.local
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    7 +++----
 tools/testing/vma/vma_internal.h |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-implement-sticky-vma-flags-fix-2
+++ a/include/linux/mm.h
@@ -549,10 +549,9 @@ extern unsigned int kobjsize(const void
  *                pressure on the memory system forcing the kernel to generate
  *                new VMAs when old one could be extended instead.
  *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
--- a/tools/testing/vma/vma_internal.h~mm-implement-sticky-vma-flags-fix-2
+++ a/tools/testing/vma/vma_internal.h
@@ -139,10 +139,9 @@ extern unsigned long dac_mmap_min_addr;
  *                pressure on the memory system forcing the kernel to generate
  *                new VMAs when old one could be extended instead.
  *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-implement-sticky-vma-flags-fix-2.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch

