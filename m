Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E550678C89
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423580; cv=none; b=REs5rALe3/6L215+4PIMmSxfDG/z9gnd52mZ4YD2CaT7Ii71eIsVb+bm04rmhkmKPpaLy0gL20fB+vBidoV42/1nd0K54UUrohblQPdnXNC55myO+WHw0tq2pfvgSNQ3nadmtzlcJC6upwtNMnSRbO5PomGB79qZ+vaAk7BrZCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423580; c=relaxed/simple;
	bh=PzHRbKzcGZHJV8KoayEKjRPyR3jrIR846syvfm1VOII=;
	h=Date:To:From:Subject:Message-Id; b=RelJoOLHFsBcDcAJEe2445n9QGVKfvvHFgcGb3KSsSWyk349ChE7tpl7BkYXhEo9QvB/c3PCRDqtOXekv3gOkFD82ReV2hrVd5f9Z23FHhice2AB41E5kdirSUv6STPBOnpcxCyoOCtoIk4fHzkCUKDbJd9y7yi5FYvXx4jczdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s3IFl3VF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s3IFl3VF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC293C4CEC2;
	Wed,  4 Sep 2024 04:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423579;
	bh=PzHRbKzcGZHJV8KoayEKjRPyR3jrIR846syvfm1VOII=;
	h=Date:To:From:Subject:From;
	b=s3IFl3VF5f8f16MCehqrsLl6dpXLD8eKPMARir8TWSF6rWg5k1mF1b9hVk0ah81uG
	 4XlUF/7GVpxzPDnCqNs3Z0i1cb98mzVharGh30Arq42QeV4ul5S/9AwEErwc2x8wtf
	 fT7zmH2PXd38zzpAfzc7HtitlHhVCOlrn9Dkqguo=
Date: Tue, 03 Sep 2024 21:19:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-improve-vma-test-makefile.patch removed from -mm tree
Message-Id: <20240904041939.BC293C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: improve vma test Makefile
has been removed from the -mm tree.  Its filename was
     tools-improve-vma-test-makefile.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


