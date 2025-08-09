Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0A021E0B7;
	Sat,  9 Aug 2025 00:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754700095; cv=none; b=pOPtIu63p1oHqNnfDNk3l3Ha2+tqfGt17RdB7p84uCctKpMyI0fb8oFnZja9hEfGBeq9F2pvyEmQdoFHhWPBh8BWc+SeOFOuMLN8NfallTQjbP/JJSKno/SRR4cTAqiHH6bSGTNC6mlkAMMS0wd5WZC8AhbS7jPBk+PVJZx0wN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754700095; c=relaxed/simple;
	bh=D2mrmZYFCfTCJwZa+i/WvGvjHJYu8Xt+4BQXFXI8zsI=;
	h=Date:To:From:Subject:Message-Id; b=M8FuknDzn7hO26bTpVvbVqfowyMh8ZRteu8/TtHpjr6xz1FR7eRsuHUX76PS/RUXir32s7HFydQUkdxZshXszQqSwSJy5u/sk1OROdeJlPRDaO5GCu3AjLvZ4B92ydt2ZR0+5tg1AXT9a3mES4q15RceYIlJb+76zZ1wo5uZtc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZTjH0wqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZTjH0wqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36B8C4CEED;
	Sat,  9 Aug 2025 00:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754700094;
	bh=D2mrmZYFCfTCJwZa+i/WvGvjHJYu8Xt+4BQXFXI8zsI=;
	h=Date:To:From:Subject:From;
	b=ZTjH0wqBZ7DADUgxPjFxoT5Go3aA/bmqmGHCvZjuBzUV/qXpIbXy55EAQfaX02mBg
	 MyjxEm2+g3uew5gHS4ZiJJO7Fmz8XjvY6jLEklYdjlUMj+0tFFlw+49lhox+PXuFEt
	 9bluQvcbauaWUR4r3BQxoAWGFBedhclcQqJ7Ie3M=
Date: Fri, 08 Aug 2025 17:41:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,changyuanl@google.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-init-new_physxa-phys_bits-to-fix-lockdep.patch added to mm-hotfixes-unstable branch
Message-Id: <20250809004134.A36B8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: init new_physxa->phys_bits to fix lockdep
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-init-new_physxa-phys_bits-to-fix-lockdep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-init-new_physxa-phys_bits-to-fix-lockdep.patch

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

kho-init-new_physxa-phys_bits-to-fix-lockdep.patch
kho-mm-dont-allow-deferred-struct-page-with-kho.patch
kho-warn-if-kho-is-disabled-due-to-an-error.patch

