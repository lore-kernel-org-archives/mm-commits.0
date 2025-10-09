Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E62CA52
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 02:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759976116; cv=none; b=AoNSB35dJeQo9eQzB3a05n7S++LilRR5wWGvu5c6KH6yu6IPtL9cFL9eg2t3qaNaWzwSKB99QlQZH3ARj5O0ccjCLTw+u4m1KuuTAm8W8ueMs2uWzeLdqV4rJvQ9NtmYegX7wBqbTZBARN9Owvq650ftGWSMdqP9l8O6/zrQ8Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759976116; c=relaxed/simple;
	bh=boeauPwra41LqTNtRvUsHGbngqUiVXnUEEC1i0GEIGk=;
	h=Date:To:From:Subject:Message-Id; b=PY7wEWTUaAMMQ72bAIsaxSHxXKlOcTDJaGxdiNbAwyONpKw6bdC1kPjU6fnfNbPyi91hi7HxInRJBkAbwSKd2DyMpwy3GQcepVN4HGvgpPyePnSw1Si+q0E9rdYHL9amVnsjK5QY+TCEvutYY3voDryUXKpBnMEyKelp6QhI26I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jkLMLDkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jkLMLDkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36F1C4CEF8;
	Thu,  9 Oct 2025 02:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759976116;
	bh=boeauPwra41LqTNtRvUsHGbngqUiVXnUEEC1i0GEIGk=;
	h=Date:To:From:Subject:From;
	b=jkLMLDkzeZXq0377GflB6PLDeiC/5qHedhXUqn6oxL8UzaBi9bKTbmqbP+rkSuTu+
	 DgpeH/Hd9lLJ8dRkyqV4dNl0cOi8dv8NEC7XAv1DKBL3chG0J9X//XF8qAAU8Q3Q8I
	 bRy+IEtkRjmiQYWGvezKY0whS+wzHpBMlm1US1ms=
Date: Wed, 08 Oct 2025 19:15:15 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,graf@amazon.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-dont-unpreserve-memory-during-abort.patch added to mm-nonmm-unstable branch
Message-Id: <20251009021515.E36F1C4CEF8@smtp.kernel.org>
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
Date: Tue, 7 Oct 2025 03:30:58 +0000

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

Link: https://lkml.kernel.org/r/20251007033100.836886-6-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/kernel/kexec_handover.c~kho-dont-unpreserve-memory-during-abort
+++ a/kernel/kexec_handover.c
@@ -1083,31 +1083,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
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

kho-allow-to-drive-kho-from-within-kernel.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-and-page-ranes.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
kho-move-kho-debugfs-directory-to-liveupdate.patch

