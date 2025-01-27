Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5D25776
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738010748; cv=none; b=n+oLC99ZXhAmSSYJA4nU4RvUrNBq8ihi4KU/j4x+8G1vU+ZrSakM+l8yJeYV1Snw8I2jHpG8LSI+H94FON69pqwtUOHr0JchNspsbNQidx+QN+OJjki9pWjtpeeHBkutnFJHiDIg/O3f/PoTJyhmuGNn2VEpYZnEbOCHWKJgiNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738010748; c=relaxed/simple;
	bh=2fmXZw33Z5NfI13Ma1UQKr2SU3xRbF4rRgSMFiOJTUk=;
	h=Date:To:From:Subject:Message-Id; b=SOcUVZV9ft2yjlvJHlQE9A1jDBOpKo2g+SWYryiLebt0LKkc3GalIzBwS1ShsHBltWZyVZX63P9ogIpgguHDXdv5ooBp2TR9v7mLbTLtRUr3IdH/l7AedqO+vyXjKwBdlyJwi0/xDbuZOozeP05SQhrzSfwDkGckKo1xyO1OiwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oeun5XLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oeun5XLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5355C4CEE0;
	Mon, 27 Jan 2025 20:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738010747;
	bh=2fmXZw33Z5NfI13Ma1UQKr2SU3xRbF4rRgSMFiOJTUk=;
	h=Date:To:From:Subject:From;
	b=Oeun5XLtYDSK/21788YTT8HT1YkzHyfo8DY+81/O5kVxWY2BY8Ib5VjtFzvzfV/QY
	 lejD5KBAQs/eVBavYwHPHjZ/a5JYK6BnK7J3xvns3pHpvDVE9yuxtCcmOzjBFzm4wP
	 QePXWxzDj0UNHKSnkXlSnGHjV5NUmO7A/7EUkac4=
Date: Mon, 27 Jan 2025 12:45:47 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kgdb-use-is_err_pcpu-macro.patch added to mm-unstable branch
Message-Id: <20250127204547.C5355C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kgdb: use IS_ERR_PCPU() macro
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kgdb-use-is_err_pcpu-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kgdb-use-is_err_pcpu-macro.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: x86/kgdb: use IS_ERR_PCPU() macro
Date: Mon, 27 Jan 2025 17:05:05 +0100

Patch series "Enable strict percpu address space checks", v4.

Enable strict percpu address space checks via x86 named address space
qualifiers.  Percpu variables are declared in __seg_gs/__seg_fs named AS
and kept named AS qualified until they are dereferenced via percpu
accessor.  This approach enables various compiler checks for
cross-namespace variable assignments.

Please note that current version of sparse doesn't know anything about
__typeof_unqual__() operator.  Avoid the usage of __typeof_unqual__() when
sparse checking is active to prevent sparse errors with unknowing keyword.
The proposed patch by Dan Carpenter to implement __typeof_unqual__()
handling in sparse is located at:

https://lore.kernel.org/lkml/5b8d0dee-8fb6-45af-ba6c-7f74aff9a4b8@stanley.mountain/


This patch (of 6):

Use IS_ERR_PCPU() when checking the error pointer in the percpu address
space.  This macro adds intermediate cast to unsigned long when switching
named address spaces.

The patch will avoid future build errors due to pointer address space
mismatch with enabled strict percpu address space checks.

Link: https://lkml.kernel.org/r/20250127160709.80604-1-ubizjak@gmail.com
Link: https://lkml.kernel.org/r/20250127160709.80604-2-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kgdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kgdb.c~x86-kgdb-use-is_err_pcpu-macro
+++ a/arch/x86/kernel/kgdb.c
@@ -655,7 +655,7 @@ void kgdb_arch_late(void)
 		if (breakinfo[i].pev)
 			continue;
 		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL, NULL);
-		if (IS_ERR((void * __force)breakinfo[i].pev)) {
+		if (IS_ERR_PCPU(breakinfo[i].pev)) {
 			printk(KERN_ERR "kgdb: Could not allocate hw"
 			       "breakpoints\nDisabling the kernel debugger\n");
 			breakinfo[i].pev = NULL;
_

Patches currently in -mm which might be from ubizjak@gmail.com are

x86-kgdb-use-is_err_pcpu-macro.patch
compilerh-introduce-typeof_unqual-macro.patch
percpu-use-typeof_unqual-in-variable-declarations.patch
percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch
percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch
percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch

