Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832544;
	b=1Y6sOthOpaaHTJRGum252nlwJGeFEz+cD01NlIwryBPgkT7Sz9TPdS500zSpdfHyUA2q
	 AUjdfW7fW8X0hGvlrUPX86YRN99RYaKi5SKM16DCJMaqkGWGRiX+eE5uNhWX2ESNRDrP+
	 LQud9ByqBTN21eQvOzmXn7I9rzcfx7hhEp41iQIEHZOHGFMBBO6u5edHP0l2PnyRD1iQ+
	 U7prDtMAToHeI2b+BcZAsx6IEhCcPjxEOa5RioBkrIPKxfPmzJe8wWFEMewx56H0KYesG
	 dXKRCvM2Hwcuo/qoyNxrJLROFnK6AhKrK//C9dAR4BYVkwNun4aiENtI/JgYeq9uwZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832544;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tUbg7rPno+XQEM3V3xKUPqT+HmamzB82mvf0uLnEtGs=;
	b=m+7/OHl/X7Y1Xds1VEAIOn0pcgRYIOaNUZT1Xz38AOhKSJh4ZyN5O0djocQCNMhiH7Lk
	 T9T5kGpkxT0hTh45CMIXTBVmypjm42wM6+h7PDQDf7y9lOt0WMU9WaTAEWyJgQ8jfhIdQ
	 MSojedB4vUUGrX2yyqIgRVXhMrIXOEPPdZ4x0N3S3TTYjN4KsbH6ah9Mk5qXNIXxF3F7o
	 /f1enZfCud62dqx/3k/UKZfbGf4ugcmeYNrq/PcGMOX4cEhNSr/SZTokBED7iQBwnDz3c
	 JqSdJrsL38UMD8jAxVuDPEM2Sr7o5Rqrq78A70iGwH8sJz7MZlY48KjnKAvr+mZxDeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="u7AV/3eK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50200606A320;
	Sat, 24 Oct 2026 09:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u7AV/3eK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7441F01828;
	Sat, 24 Oct 2026 09:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832544;
	bh=tUbg7rPno+XQEM3V3xKUPqT+HmamzB82mvf0uLnEtGs=;
	h=Date:To:From:Subject;
	b=u7AV/3eK9WVBNg0/axKJhsSiFhuNb32ZfeR/KY+1dbZlEcen3n7GNI5xDx7s6CoJh
	 Oac9vZwCQ4C6iO5X8sDlLa/e55PzVO5AgOkSpdjsD+HFj6omY6/e5SK4c+EQDrTVBQ
	 HQBVLgj7jauz9O7ctnkKb9NPn1vUi9kFY41GpQjo=
Date: Sat, 24 Oct 2026 02:02:23 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,vbabka@kernel.org,stable@vger.kernel.org,shawnq1@163.com,rppt@linux.vnet.ibm.com,pfalcato@suse.de,peterx@redhat.com,liam@infradead.org,kas@kernel.org,jannh@google.com,gourry@gourry.net,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-avoid-broken-uffd-merge-on-mremap.patch removed from -mm tree
Message-Id: <20261024090224.1C7441F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: avoid broken uffd merge on mremap
has been removed from the -mm tree.  Its filename was
     mm-vma-avoid-broken-uffd-merge-on-mremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: avoid broken uffd merge on mremap
Date: Tue, 20 Oct 2026 15:55:30 +0100

Userfaultfd often causes unexpected interactions within mm, and does so at
the intersection of uffd, mremap() and VMA merging.

When an mremap of a VMA occurs, copy_vma_and_data() calls
mremap_userfaultfd_prep() to notify uffd of this.

However, mremap_userfaultfd_prep() simply drops the UFFD context for the
VMA if the user did not register it for remap, i.e. didn't specify the
UFFD_FEATURE_EVENT_REMAP flag.

This is OK for the VMA itself, as upon page table move, move_ptes() clears
UFFD page table flags, using vma_has_uffd_without_event_remap() to
determine whether to do so.

However, this doesn't account for merging with adjacent VMAs, whose page
tables won't have received this treatment, and thus latent UFFD markers
will be left around.

Worse, it'll break UFFD for any VMAs it is merged with. This is very
surprising behaviour for a user, who will then simply not receive UFFD
events for VMAs they ought to.

Resolve the issue by explicitly checking for this case via
vma_has_uffd_without_event_remap() in vma_merge_copied_range(), the merge
function explicitly designated for mremap() operations.

Also update the userland VMA tests accordingly.

Link: https://lore.kernel.org/20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org
Fixes: 3cfd22be0ad6 ("userfaultfd: clear flag if remap event not enabled")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: shaos <shawnq1@163.com>
Closes: https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/vma.c                          |    5 +++++
 tools/testing/vma/include/stubs.h |    5 +++++
 2 files changed, 10 insertions(+)

--- a/mm/vma.c~mm-vma-avoid-broken-uffd-merge-on-mremap
+++ a/mm/vma.c
@@ -1211,6 +1211,11 @@ static struct vm_area_struct *vma_merge_
 
 	vmg->copied_from = vmg->middle;
 	vmg->middle = NULL;
+
+	/* If not registered for remap, uffd context will be cleared. */
+	if (vma_has_uffd_without_event_remap(vmg->copied_from))
+		return NULL;
+
 	return vma_merge_new_range(vmg);
 }
 
--- a/tools/testing/vma/include/stubs.h~mm-vma-avoid-broken-uffd-merge-on-mremap
+++ a/tools/testing/vma/include/stubs.h
@@ -386,6 +386,11 @@ static inline bool is_mergeable_vm_userf
 	return true;
 }
 
+static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
 				    struct anon_vma_name *anon_name2)
 {
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

