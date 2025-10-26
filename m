Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882C9245012
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761451595; cv=none; b=G+WbVuUWFeuuDWZnXNKrmuQeBCMvFQxwg6JtkhZjxkzmxoaAnX1hLOjfm2e0M+KJ9x/7jA5HwmDJ86JDxJ0rK31IFNO25EiliE0NgyubiHd0/rO49Wr+4Nn/NF42Z55D7IufVJa4mK7s7Cxtk1Dq39EUxWv916NJigQewTR1aXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761451595; c=relaxed/simple;
	bh=tjoZcpSeOTwiCn3WFdeIDJGvA8BOakJUAK9lZi/0LGc=;
	h=Date:To:From:Subject:Message-Id; b=r6J0ly45tAE5rVnWP6OooqAw6LXKQyf1Dz2fBLaVD037aE9gbaHlXpVFNjopQhnFRubCvKJEtZijtqXUnPSQruBF3TmD063cXUYb1bIpjhqIMuZe7l+tSEbcrDt+GOkz0gVfc2pw9EXThIMVX2nxkqUqlp0AxVyJsQfu1RQ7KTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PusbErCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PusbErCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0963FC4CEE7;
	Sun, 26 Oct 2025 04:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761451595;
	bh=tjoZcpSeOTwiCn3WFdeIDJGvA8BOakJUAK9lZi/0LGc=;
	h=Date:To:From:Subject:From;
	b=PusbErCDSbt2GAfxYA1dAv5PU6CK8Q7zq/+WW8sEmAa8VS4m5pTY2Ar91kLd8cp6m
	 zUYSdG2svqv7mMmpKoaL4pL558mYKhqjXNoUP4XkMmz/M9ECvvojfFOmFExXtJPVes
	 1jSapF4Y8SXUTHzVbIF/MZexf8uhUdRzyJp6O1l0=
Date: Sat, 25 Oct 2025 21:06:34 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,graf@amazon.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-dont-unpreserve-memory-during-abort.patch added to mm-nonmm-unstable branch
Message-Id: <20251026040635.0963FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: don't unpreserve memory during abort
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-dont-unpreserve-memory-during-abort.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-dont-unpreserve-memory-during-abort.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: don't unpreserve memory during abort
Date: Fri, 24 Oct 2025 12:09:59 -0400

KHO allows clients to preserve memory regions at any point before the KHO
state is finalized.  The finalization process itself involves KHO
performing its own actions, such as serializing the overall preserved
memory map.

If this finalization process is aborted, the current implementation
destroys KHO's internal memory tracking structures
(`kho_out.ser.track.orders`).  This behavior effectively unpreserves all
memory from KHO's perspective, regardless of whether those preservations
were made by clients before the finalization attempt or by KHO itself
during finalization.

This premature unpreservation is incorrect.  An abort of the finalization
process should only undo actions taken by KHO as part of that specific
finalization attempt.  Individual memory regions preserved by clients
prior to finalization should remain preserved, as their lifecycle is
managed by the clients themselves.  These clients might still need to call
kho_unpreserve_folio() or kho_unpreserve_phys() based on their own logic,
even after a KHO finalization attempt is aborted.

Link: https://lkml.kernel.org/r/20251024161002.747372-6-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/kernel/kexec_handover.c~kho-dont-unpreserve-memory-during-abort
+++ a/kernel/kexec_handover.c
@@ -1098,31 +1098,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
 static int __kho_abort(void)
 {
-	int err = 0;
-	unsigned long order;
-	struct kho_mem_phys *physxa;
-
-	xa_for_each(&kho_out.track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
-
-		xa_destroy(&physxa->phys_bits);
-		kfree(physxa);
-	}
-	xa_destroy(&kho_out.track.orders);
-
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
 
-	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
-
-	return err;
+	return 0;
 }
 
 int kho_abort(void)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
kho-allow-to-drive-kho-from-within-kernel.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-and-page-ranges.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-kho-debugfs-directory-to-liveupdate.patch
memblock-unpreserve-memory-in-case-of-error.patch

