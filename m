Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C2722D9E9;
	Tue, 19 Aug 2025 23:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646587; cv=none; b=O1dthO3TEhejGrD3rcon+rvyp4X3pdQZrhm5dm+DzBDqEI5mlk5PhmttGo/XRZYg2zoMkjQsk6simq7+wK+lfpjsskY9yD8TaltNqFUEljcc9UaeGCeJv8RPR8ulEjTn4/zwS90AoKlzWzz0ShsXcWoGNEtARUVjNzm2+q5CseU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646587; c=relaxed/simple;
	bh=Vv/eR9HNSQNNh2An6CImJ1mat5riB6d4hLY7EE70fnA=;
	h=Date:To:From:Subject:Message-Id; b=knAjMo/2PR1PRrM6F9KuzJ/MauTKCmazYuJ30wZMlxRZKkodcy1EBoCxLZbW+maaw8cxrjDRyRTXml1vRU2/7Tzizdkb4Mdj9jKPkh+4+qaGxa9MfusUdIMWSdcWxoPtKDeSUDcGLSa2Xj3mRi1UBNLk4JCLfAWxUQsFTrdFVyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P7hlzMbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P7hlzMbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469A2C4CEF1;
	Tue, 19 Aug 2025 23:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646586;
	bh=Vv/eR9HNSQNNh2An6CImJ1mat5riB6d4hLY7EE70fnA=;
	h=Date:To:From:Subject:From;
	b=P7hlzMbnc1l9fMQCbx/LHUrfywPdWuLldcOxb7fV9OezOhyFbS+neSaG/dJ3C2qc+
	 /S6qis6wD6MmS8LZ2MRcMMDShXBv3EI8iC+NjfNNnPT3mjivivLaMaPPDqFsft6D56
	 nta7byLbIvG759q2yV28XV+y2OwZyt0lKbVZdSQc=
Date: Tue, 19 Aug 2025 16:36:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,changyuanl@google.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-init-new_physxa-phys_bits-to-fix-lockdep.patch removed from -mm tree
Message-Id: <20250819233626.469A2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: init new_physxa->phys_bits to fix lockdep
has been removed from the -mm tree.  Its filename was
     kho-init-new_physxa-phys_bits-to-fix-lockdep.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: init new_physxa->phys_bits to fix lockdep
Date: Fri, 8 Aug 2025 20:18:02 +0000

Patch series "Several KHO Hotfixes".

Three unrelated fixes for Kexec Handover.


This patch (of 3):

Lockdep shows the following warning:

INFO: trying to register non-static key.  The code is fine but needs
lockdep annotation, or maybe you didn't initialize this object before use?
turning off the locking correctness validator.

[<ffffffff810133a6>] dump_stack_lvl+0x66/0xa0
[<ffffffff8136012c>] assign_lock_key+0x10c/0x120
[<ffffffff81358bb4>] register_lock_class+0xf4/0x2f0
[<ffffffff813597ff>] __lock_acquire+0x7f/0x2c40
[<ffffffff81360cb0>] ? __pfx_hlock_conflict+0x10/0x10
[<ffffffff811707be>] ? native_flush_tlb_global+0x8e/0xa0
[<ffffffff8117096e>] ? __flush_tlb_all+0x4e/0xa0
[<ffffffff81172fc2>] ? __kernel_map_pages+0x112/0x140
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff81359556>] lock_acquire+0xe6/0x280
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff8100b9e0>] _raw_spin_lock+0x30/0x40
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff813ec327>] xa_load_or_alloc+0x67/0xe0
[<ffffffff813eb4c0>] kho_preserve_folio+0x90/0x100
[<ffffffff813ebb7f>] __kho_finalize+0xcf/0x400
[<ffffffff813ebef4>] kho_finalize+0x34/0x70

This is becase xa has its own lock, that is not initialized in
xa_load_or_alloc.

Modifiy __kho_preserve_order(), to properly call
xa_init(&new_physxa->phys_bits);

Link: https://lkml.kernel.org/r/20250808201804.772010-2-pasha.tatashin@soleen.com
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/kernel/kexec_handover.c~kho-init-new_physxa-phys_bits-to-fix-lockdep
+++ a/kernel/kexec_handover.c
@@ -144,14 +144,34 @@ static int __kho_preserve_order(struct k
 				unsigned int order)
 {
 	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa;
+	struct kho_mem_phys *physxa, *new_physxa;
 	const unsigned long pfn_high = pfn >> order;
 
 	might_sleep();
 
-	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
-	if (IS_ERR(physxa))
-		return PTR_ERR(physxa);
+	physxa = xa_load(&track->orders, order);
+	if (!physxa) {
+		int err;
+
+		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
+		if (!new_physxa)
+			return -ENOMEM;
+
+		xa_init(&new_physxa->phys_bits);
+		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
+				    GFP_KERNEL);
+
+		err = xa_err(physxa);
+		if (err || physxa) {
+			xa_destroy(&new_physxa->phys_bits);
+			kfree(new_physxa);
+
+			if (err)
+				return err;
+		} else {
+			physxa = new_physxa;
+		}
+	}
 
 	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
 				sizeof(*bits));
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


