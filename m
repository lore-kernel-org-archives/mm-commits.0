Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF00979D0
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605440; cv=none; b=esKy1MIpbJaNlKLIEqp+6lYHqpK9njDm8sBz/iRGJBPFOfTQmE4F2V3ywlT/PxOgZslLMp7RwTY/vkZOAcflajW9bpxIE0hLgsg5iWlO4s33TV/VE+uN2FJSSHD6OJGVB5LuN1lHknoEMaihV8qPgkpAaZCuyAdyNG67rIzYgP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605440; c=relaxed/simple;
	bh=PnpoXbf6tlnVimwUzFinPElbuF9bqhtZ2AExi8Yeg2o=;
	h=Date:To:From:Subject:Message-Id; b=FnP+RtQ9snJoMhSJL+5Iydo+0f1WkKGG39dacKIHK83VRhUHKKCfz1XAFpsjP9qRR9z9j2bp19bJZCb1jbyiHdSi2B8rPiTLUewO3Pm9jvKRVr/aR1flM+IWkLraTH03AP1XOGy8WBnbWFFrn8VAzTBZKYXC2O5e2mD150zkXhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U0rx1G8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U0rx1G8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB0CC4CED0;
	Tue, 31 Dec 2024 00:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605440;
	bh=PnpoXbf6tlnVimwUzFinPElbuF9bqhtZ2AExi8Yeg2o=;
	h=Date:To:From:Subject:From;
	b=U0rx1G8noBNGprwesPw830hRllUxIDiNqggET14D6Fui39Aj4Yn73odvcVG61eCqd
	 8s0fKD6jibNDnnrzDZHPLGQFuS4AHNKSNbiqtcMML+q3qBkZ+zdgDc0v3XKHNLftB8
	 iPTruDSCjZ+xPMuAMJeHQ04LEzoo3l6RQyxTuMIA=
Date: Mon, 30 Dec 2024 16:37:20 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-fix-atomic_set-definition-to-set-the-value-correctly.patch added to mm-hotfixes-unstable branch
Message-Id: <20241231003720.7EB0CC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: fix atomic_set() definition to set the value correctly
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-fix-atomic_set-definition-to-set-the-value-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-fix-atomic_set-definition-to-set-the-value-correctly.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: tools: fix atomic_set() definition to set the value correctly
Date: Fri, 27 Dec 2024 14:22:20 -0800

Currently vma test is failing because of the new vma_assert_attached()
assertion.  The check is failing because previous refcount_set() inside
vma_mark_attached() is a NoOp.  Fix the definition of atomic_set() to
correctly set the value of the atomic.

Link: https://lkml.kernel.org/r/20241227222220.1726384-1-surenb@google.com
Fixes: 9325b8b5a1cb ("tools: add skeleton code for userland testing of VMA logic")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/linux/maple_tree.h |    2 +-
 tools/testing/vma/linux/atomic.h        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/shared/linux/maple_tree.h~tools-fix-atomic_set-definition-to-set-the-value-correctly
+++ a/tools/testing/shared/linux/maple_tree.h
@@ -2,6 +2,6 @@
 #define atomic_t int32_t
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) do {} while (0)
+#define atomic_set(x, y) uatomic_set(x, y)
 #define U8_MAX UCHAR_MAX
 #include "../../../../include/linux/maple_tree.h"
--- a/tools/testing/vma/linux/atomic.h~tools-fix-atomic_set-definition-to-set-the-value-correctly
+++ a/tools/testing/vma/linux/atomic.h
@@ -6,7 +6,7 @@
 #define atomic_t int32_t
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) do {} while (0)
+#define atomic_set(x, y) uatomic_set(x, y)
 #define U8_MAX UCHAR_MAX
 
 #endif	/* _LINUX_ATOMIC_H */
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
tools-fix-atomic_set-definition-to-set-the-value-correctly.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch
mm-mark-vmas-detached-upon-exit.patch
mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

