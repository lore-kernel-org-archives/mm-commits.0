Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793050505;
	b=5pbxGRq3JL2sahyqHkV2+bOMwb2UQILuSBVX4rtw2HJzeuYkSDLkNNybnVWfREJ1YLML
	 MKWRz2RooYBlaNMTHtzBb0iN9DCPBH1UiV8rbDfUUwiurfch4aTR2xfzGzk78ZYj/nE90
	 LrZZO4WpoosEbhPZeEvBskPGCWH9sfQaPtkZSbo+FQuuaP4Jrxx9Wd39pRIbTVoCqprgK
	 eBt4NxMWU3uVAzuXpyKmkZk5fpwUheu9NP23Bb4xRFv/milZaKjhdZLVTb4jHD/jzCqpV
	 RswyXbPDhET5umFhiytjWk57Yl40gqI+5bJr643LcNUCenNJu8vDxYfEnBSOCkD/tgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793050505;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4iMANfw/5u304rrv/1udOYkSKJejLDSvu5rBcME4v3g=;
	b=4h9dc9REcRrc4u0+5wq49UBcHSYQgmpf9QAQeuAghTGd8ZQyrpGJzfn3ftXJEooRkgya
	 sbAZ64LwMBr25V1jh2J1YjZM/FLSwXjCCs0gA6terpKtsKROjYWN2YdhPlQv0XA6F/NkN
	 HeK/uodtS5Fe6W+rJweUZsgDYPuUEDE2QI2Nl+LnTi3+oUZZniEnVX9HMJjBWGZTkl18n
	 IbmWnKidrxYxYKe7a3F82Lr+fIZR9JuY5G3sLC1qIb7FulN0MekLAa7oZrF+ZPLalNgHE
	 opHqbtgYhxBqnh8lSwaFwOACYO0aobwG1VPDZhXVqdgw/y5aBTY9osFb+wczhS+OxnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TU5mZcjk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3750606A31A
	for <mm-commits@vger.kernel.org>; Mon, 26 Oct 2026 21:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TU5mZcjk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE481F01825;
	Mon, 26 Oct 2026 21:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793050504;
	bh=4iMANfw/5u304rrv/1udOYkSKJejLDSvu5rBcME4v3g=;
	h=Date:To:From:Subject;
	b=TU5mZcjk4J0rxLKSISb2QAb3AQST3pEVMkwlN9z4nicABVq7UptTpVmezUAqzywI0
	 l4EUUscJZ455MIee1sjQf9rzGcNPRj4iRY9f05ijpohJthYLU+z1IoNNhLW1oVrTXG
	 Q6fbwbi7bD09BCqxKe4F8CPxwasGlk/vVRYrB95Y=
Date: Mon, 26 Oct 2026 14:35:03 -0700
To: mm-commits@vger.kernel.org,rioo.tsukatsukii@gmail.com,pmladek@suse.com,
	brads@mainlining.org,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-zero-the-dynamically-allocated-taint-buffer.patch added to mm-nonmm-unstable branch
Message-Id: <20261026213504.6CE481F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: panic: zero the dynamically allocated taint buffer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-zero-the-dynamically-allocated-taint-buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-zero-the-dynamically-allocated-taint-buffer.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: panic: zero the dynamically allocated taint buffer
Date: Fri, 23 Oct 2026 22:01:52 -0400

A %s read of print_tainted()'s string can run past the end of the taint
buffer while another CPU rebuilds a longer string in it, reading slab
memory out of bounds into the kernel log (a KASAN slab-out-of-bounds
report at taint_buf + size).  A warning or an unhandled-signal dump on
another CPU reaches print_tainted() through dump_stack_print_info().

alloc_taint_buf() sizes the buffer for the longest taint string and
allocates it with kmalloc(), so the bytes past that string are never
written and the object holds no permanent NUL terminator. 
_print_tainted() rebuilds the string in place without locking and writes
the terminator last, so a reader that overtakes a writer extending the
string past the previous high-water mark finds no terminator inside the
object and walks off its end.  print_tainted()'s kernel-doc promises the
string is "always NULL terminated", a guarantee the previous zero-filled
static buffer kept.

Allocate the buffer with kzalloc() so its trailing bytes stay NUL and
every reader stops inside the object.

Reproduced on QEMU riscv64 under KASAN by growing the taint set while
processes took unhandled-signal dumps on several CPUs: the unpatched
kernel reports a slab-out-of-bounds read at taint_buf + size, the patched
one is clean.

Link: https://lore.kernel.org/20261024020153.830459-1-nickolai@csail.mit.edu
Fixes: a9dff0d0d11c ("kernel/panic: allocate taint string buffer dynamically")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Rio <rioo.tsukatsukii@gmail.com>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/panic.c~panic-zero-the-dynamically-allocated-taint-buffer
+++ a/kernel/panic.c
@@ -884,7 +884,7 @@ static __init int alloc_taint_buf(void)
 
 	size += 1; /* For NULL terminator */
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = kzalloc(size, GFP_KERNEL);
 
 	if (!buf) {
 		panic("Failed to allocate taint string buffer");
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch
panic-zero-the-dynamically-allocated-taint-buffer.patch

