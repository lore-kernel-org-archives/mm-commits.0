Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A05D288D0
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744739; cv=none; b=sIugBvuM4hlICpS4ZOEt8eT9QudCbdabd5WpU9nXLNnWFVMLH46BUzROtXKSQsudBGaRz0zBNsJ33lTGqPiMbZkWFVSfUVsJSq/C5sB2Z5nzgkyhlE1PjmWa9uISBSq0rArQspuGcqt0PviKICIkfTkmlDuBiUzak/rjF9Kbum8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744739; c=relaxed/simple;
	bh=enco5A0JugoUTGC1mvZNsKLJ7+RYUlxlEOYZj8xXqNI=;
	h=Date:To:From:Subject:Message-Id; b=dAOBDaCQZMnx+LkQOAx/uTckDXbqkzaC9vXzlfVEJqeZ86nIZus9Acl7Jedq4NpoODgHrr+O6r6QW5UxldrtErxuaO5ka0PBjB+KhsOkIGSTtUqK0eTF6D9zKc0a0nRxasLH7SxyDm9B9+T5REOY0o5opmyFwoRdx7nGmMmuyo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OxujAk+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OxujAk+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA9AC4CEF7;
	Sun, 29 Mar 2026 00:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744739;
	bh=enco5A0JugoUTGC1mvZNsKLJ7+RYUlxlEOYZj8xXqNI=;
	h=Date:To:From:Subject:From;
	b=OxujAk+E/z8TPrkhIVu70cnmwPMlB4AmRhnmzr3vMqEO30awEdrd9/SESnQlhJZ18
	 n6FRuzp2niGGU+ynJWTOYcxSPPwAcCOIq26qMHEH3sdW5GP/bZFb4yLmtc8vEo9XGp
	 Ep1EcPt6nOoxmr8FnopruL6bULLKmd+e6bSkmeGc=
Date: Sat, 28 Mar 2026 17:38:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch removed from -mm tree
Message-Id: <20260329003858.DEA9AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: drop range checks in madvise_free_single_vma()
has been removed from the -mm tree.  Its filename was
     mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/madvise: drop range checks in madvise_free_single_vma()
Date: Fri, 27 Feb 2026 21:08:32 +0100

Patch series "mm: cleanups around unmapping / zapping".

A bunch of cleanups around unmapping and zapping.  Mostly simplifications,
code movements, documentation and renaming of zapping functions.

With this series, we'll have the following high-level zap/unmap functions
(excluding high-level folio zapping):
* unmap_vmas() for actual unmapping (vmas will go away)
* zap_vma(): zap all page table entries in a vma
* zap_vma_for_reaping(): zap_vma() that must not block
* zap_vma_range(): zap a range of page table entries
* zap_vma_range_batched(): zap_vma_range() with more options and batching
* zap_special_vma_range(): limited zap_vma_range() for modules
* __zap_vma_range(): internal helper

Patch #1 is not about unmapping/zapping, but I stumbled over it while
verifying MADV_DONTNEED range handling.

Patch #16 is related to [1], but makes sense even independent of that.


This patch (of 16):

madvise_vma_behavior()->
madvise_dontneed_free()->madvise_free_single_vma() is only called from
madvise_walk_vmas()

(a) After try_vma_read_lock() confirmed that the whole range falls into
    a single VMA (see is_vma_lock_sufficient()).

(b) After adjusting the range to the VMA in the loop afterwards.

madvise_dontneed_free() might drop the MM lock when handling userfaultfd,
but it properly looks up the VMA again to adjust the range.

So in madvise_free_single_vma(), the given range should always fall into a
single VMA and should also span at least one page.

Let's drop the error checks.

The code now matches what we do in madvise_dontneed_single_vma(), where we
call zap_vma_range_batched() that documents: "The range must fit into one
VMA.".  Although that function still adjusts that range, we'll change that
soon.

Link: https://lkml.kernel.org/r/20260227200848.114019-1-david@kernel.org
Link: https://lkml.kernel.org/r/20260227200848.114019-2-david@kernel.org
Link: https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com [1]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arve <arve@android.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/mm/madvise.c~mm-madvise-drop-range-checks-in-madvise_free_single_vma
+++ a/mm/madvise.c
@@ -799,9 +799,10 @@ static int madvise_free_single_vma(struc
 {
 	struct mm_struct *mm = madv_behavior->mm;
 	struct vm_area_struct *vma = madv_behavior->vma;
-	unsigned long start_addr = madv_behavior->range.start;
-	unsigned long end_addr = madv_behavior->range.end;
-	struct mmu_notifier_range range;
+	struct mmu_notifier_range range = {
+		.start = madv_behavior->range.start,
+		.end = madv_behavior->range.end,
+	};
 	struct mmu_gather *tlb = madv_behavior->tlb;
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry		= madvise_free_pte_range,
@@ -811,12 +812,6 @@ static int madvise_free_single_vma(struc
 	if (!vma_is_anonymous(vma))
 		return -EINVAL;
 
-	range.start = max(vma->vm_start, start_addr);
-	if (range.start >= vma->vm_end)
-		return -EINVAL;
-	range.end = min(vma->vm_end, end_addr);
-	if (range.end <= vma->vm_start)
-		return -EINVAL;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				range.start, range.end);
 
_

Patches currently in -mm which might be from david@kernel.org are


