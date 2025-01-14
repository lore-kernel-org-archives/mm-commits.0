Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAFF23ED63
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837073; cv=none; b=ZDklEfbQF4aUFt34rzxJ4VW9J5wbOtFqWyUglEjdSbCgnvo8jSG4RaJlujrQig14k3bJER5ZAq9PIJwjJX4+taWNYQ5QympshlGIFkuF9NO4CkC0QkYXkkIC0pWSP8LsoxbPZ7nFJAbzqJkSUHgaidxIGiwDeL4muovlxklCSdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837073; c=relaxed/simple;
	bh=H0Yi23RNbzE/ADZQTpiz5ARBnAvZMn6QZWtyX8yRItE=;
	h=Date:To:From:Subject:Message-Id; b=Rrv9sFi4ouuBq7B4OzdvGVfQ24PxPxB9kaD39K2/onqX8bOFDok/PrFXqOG+MsBgMb5kKh6k3rwKlUUmmo1KOpkwHXfcYMI3jamxknTbDqhnkrbUlHYa0h8UaMn5d3X+ir+RdMnETHy1X1cIHiZB5cq77/jGABGEiJXazElfWlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eh69D6ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eh69D6ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D7DC4CEDD;
	Tue, 14 Jan 2025 06:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837073;
	bh=H0Yi23RNbzE/ADZQTpiz5ARBnAvZMn6QZWtyX8yRItE=;
	h=Date:To:From:Subject:From;
	b=Eh69D6kul05qq+qMwPlFva1BYaNDTo3bH+v9dch0V4FHPAEbEOvW03L8EmZ4kAoAd
	 /uU5K3Nloq8Oh84Ls9DVzA847wEczmNRn45cHKi0SeyOJZD1Bsnpn0oj2KmRiGylYs
	 e3jrRiFb/P4i7dyRvdNR+en1TECHhpEi5nVSv/o0=
Date: Mon, 13 Jan 2025 22:44:32 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-kgdb-use-is_err_pcpu-macro.patch removed from -mm tree
Message-Id: <20250114064433.53D7DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kgdb: use IS_ERR_PCPU() macro
has been removed from the -mm tree.  Its filename was
     x86-kgdb-use-is_err_pcpu-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: x86/kgdb: use IS_ERR_PCPU() macro
Date: Sun, 8 Dec 2024 21:45:16 +0100

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

Link: https://lkml.kernel.org/r/20241208204708.3742696-1-ubizjak@gmail.com
Link: https://lkml.kernel.org/r/20241208204708.3742696-2-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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


