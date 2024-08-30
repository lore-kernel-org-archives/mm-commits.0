Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14B61BE84B
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055904; cv=none; b=fvhkFU0hojgbR7kGtVrxM/JtCxrJ5BZMuw/soi+dR1Ni7YUQ6MQoGnbiMYYnz9Ay0Jk05B57X6jyZYUDe2pjSOe/MUOT/hU5phRHX3LtU1w/ip3xopXmWS+B2iyhrjHHjMehc9rpAccOKKKYJ4LyNLjsH6LRGhbKds/nnS2exVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055904; c=relaxed/simple;
	bh=Xe3BWNy6kpna0l7XER743pSgqxrOFIjZK/V73STsvCU=;
	h=Date:To:From:Subject:Message-Id; b=l1HLYqo7cdWFPGX96YNw2f1FrPzQ4NY3YzmkoygoNdMbghcKJATtxZtsqlcvQkYnPS2x/1Ugmc9RyvE1T/yplTVWffIB65QZa1FTi1L26fcN9WX7rui4J0reBcIblc9lzIA075FL5EON/TrOx4mLXgfQ14k2eCnRHiJ1RVc2yx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HCJ5B+MZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HCJ5B+MZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8814CC4CEC2;
	Fri, 30 Aug 2024 22:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055904;
	bh=Xe3BWNy6kpna0l7XER743pSgqxrOFIjZK/V73STsvCU=;
	h=Date:To:From:Subject:From;
	b=HCJ5B+MZscs4ViQraRdyiKgnfx+DCV0D2xhmFdXA4Tg9X9e6Y382Erg1LA6PpnryU
	 iWeJaUWVaW5VJzGLRi7gTeM4t0TeNWv4vfbLXF1Kfi6JqoDgdYY8Mwev1U2RUev6ov
	 2DTrKv61lGFSlbZXTGC7bD0O8jOtkMxXVFhT/YH4=
Date: Fri, 30 Aug 2024 15:11:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-improve-vma-test-makefile.patch added to mm-unstable branch
Message-Id: <20240830221144.8814CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: improve vma test Makefile
has been added to the -mm mm-unstable branch.  Its filename is
     tools-improve-vma-test-makefile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-improve-vma-test-makefile.patch

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
Subject: tools: improve vma test Makefile
Date: Fri, 30 Aug 2024 19:10:13 +0100

Patch series "mm: remove vma_merge()", v3.

The infamous vma_merge() function has been the cause of a great deal of
pain, bugs and confusion for a very long time.

It is subtle, contains many corner cases, tries to do far too much and is
as a result very fragile.

The fact that the function requires there to be a numbering system to
cover each possible eventuality with references to each in the many
branches of its implementation as to which case you are looking at speaks
to all this.

Some of this complexity is inherent - unfortunately there is no getting
away from the need to figure out precisely how to execute the merge,
whether we need to remove VMAs, whether it is safe to do so, what
constitutes a mergeable VMA and so on.

However, a lot of the complexity is not inherent but instead a product of
the function's 'organic' development.

Liam has gone to great lengths to improve the situation as a part of his
maple tree implementation, greatly improving the readability of the code,
and Vlastimil and myself have additionally gone to lengths to try to
improve things further.

However, with the availability of userland VMA testing, it now becomes
possible to perform a rather more significant refactoring while
maintaining confidence in its correct operation.

An attempt was previously made by Vlastimil [0] to eliminate vma_merge(),
however it was rather - brutal - and an astute reader might refer to the
date of that patch for insight as to its intent.

This series instead divides merge operations into two natural kinds -
merges which occur when a NEW vma is being added to the address space, and
merges which occur when a vma is being MODIFIED.

Happily, the vma_expand() function introduced by Liam, which has the
capacity for also deleting a subsequent VMA, covers each of the NEW vma
cases.

By abstracting the actual final commit of changes to a VMA to its own
function, commit_merge() and writing a wrapper around vma_expand() for new
VMA cases vma_merge_new_range(), we can avoid having to use vma_merge()
for these instances altogether.

By doing so we are also able to then de-duplicate all existing merge logic
in mmap_region() and do_brk_flags() and have everything invoke this new
function, so we universally take the same approach to merging new VMAs.

Having done so, we can then completely rework vma_merge() into
vma_merge_existing_range() and use this for the instances where a merge is
proposed for a region of an existing VMA.

This eliminates vma_merge() and its numbered cases and instead divides
things into logical cases - merge both, merge left, merge right (the
latter 2 being either partial or full merges).

The code is heavily annotated with ASCII diagrams and greatly simplified
in comparison to the existing vma_merge() function.

Having made this change, we take the opportunity to address an issue with
merging VMAs possessing a vm_ops->close() hook - commit 714965ca8252
("mm/mmap: start distinguishing if vma can be removed in mergeability
test") and commit fc0c8f9089c2 ("mm, mmap: fix vma_merge() case 7 with
vma_ops->close") make efforts to relax how we handle these, making
assumptions about which VMAs might end up deleted (and thus, if possessing
a vm_ops->close() hook, cannot be).

This refactor means we do not need to guess, so instead explicitly only
disallow merge in instances where a VMA with a vm_ops->close() hook would
be deleted (and try a smaller merge in cases where this is possible).

In addition to these changes, we introduce a new vma_merge_struct
abstraction to allow VMA merge state to be threaded through the operation
neatly.

There is heavy unit testing provided for all merge functionality, added
prior to the refactoring, allowing for before/after testing.

The vm_ops->close() change also introduces exhaustive testing to
demonstrate that this functions as expected, and in addition to this the
reproduction code from commit fc0c8f9089c2 ("mm, mmap: fix vma_merge()
case 7 with vma_ops->close") was tested and confirmed passing.

[0]:https://lore.kernel.org/linux-mm/20240401192623.18575-2-vbabka@suse.cz/


This patch (of 10):

Have vma.o depend on its source dependencies explicitly, as previously
these were simply being ignored as existing object files were up to date.

This now correctly re-triggers the build if mm/ source is changed as well
as local source code.

Also set clean as a phony rule.

Link: https://lkml.kernel.org/r/cover.1725040657.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/e3ea58f08364ae5432c9a074de0195a7c7e0b04a.1725040657.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/vma/Makefile~tools-improve-vma-test-makefile
+++ a/tools/testing/vma/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-.PHONY: default
+.PHONY: default clean
 
 default: vma
 
@@ -9,7 +9,9 @@ include ../shared/shared.mk
 OFILES = $(SHARED_OFILES) vma.o maple-shim.o
 TARGETS = vma
 
-vma:	$(OFILES) vma_internal.h ../../../mm/vma.c ../../../mm/vma.h
+vma.o: vma.c vma_internal.h ../../../mm/vma.c ../../../mm/vma.h
+
+vma:	$(OFILES)
 	$(CC) $(CFLAGS) -o $@ $(OFILES) $(LDLIBS)
 
 clean:
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

