Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65753431E79;
	Wed,  1 Jul 2026 23:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782947489; cv=none; b=g3Hq8K/BRzUD5VKPekR/jPd5O/RJE4EYhc3cItIMppcXQBKLVU/XSNJZrm1ZfugdkrJsCPv1/eQJwbKj/TLzCQgbs6ssMLrRUmqAN9kZWmsoIwYZ6XPSGR+4SeTNgHYadCGoM7G6h64jLbGj4su8TutRYOXWxKyUeAOubiDUX04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782947489; c=relaxed/simple;
	bh=h5LXKJOWtBREEwH9SKFU6B/NnbboPTLfI8vVxphLRto=;
	h=Date:To:From:Subject:Message-Id; b=OcRP7+u/GsrHWAYMvcdM/Bluh4jFQsLypkO+rjWXzHfua7k50NNluZKADIx8DRXQu12fMplqm4wBZZl8Tlge3jGX9YNv8ouOo/I3cpW3cwRSi0nUF4+jEnk7ApMbJ8ea8DrT2WrjomcScY//G3oqQVirNXQ0xK7zn1fBbX5IIa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2vOKAxmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2vOKAxmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232B71F000E9;
	Wed,  1 Jul 2026 23:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782947488;
	bh=VTNUYM9aZgrQdeoDLF1EaG062c4kTsgS3pScygAgo5I=;
	h=Date:To:From:Subject;
	b=2vOKAxmGcV9dxWxAtst3fUo75Wkc0kgJdi5J/HfqV8wGUbf4Roumx6KVSD5IWWThU
	 rb7mDTEstxgHJl4yFq9cY3kyCUWqwjTODA2/3/mckH1Hdr8+R9vyZ6PmY4Mc8LzpS1
	 4risVXdtbV8qkmJAWMAMJ0CrsVtD4erB8ONXqDVI=
Date: Wed, 01 Jul 2026 16:11:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,schwab@linux-m68k.org,geert@linux-m68k.org,david@kernel.org,ankur.a.arora@oracle.com,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-avoid-wunused-but-set-parameter-in-clear_user_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20260701231128.232B71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: m68k: avoid -Wunused-but-set-parameter in clear_user_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     m68k-avoid-wunused-but-set-parameter-in-clear_user_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-avoid-wunused-but-set-parameter-in-clear_user_page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: m68k: avoid -Wunused-but-set-parameter in clear_user_page()
Date: Mon, 25 May 2026 10:33:52 +0200

The loop in clear_user_pages() iterates over all pages and calls
clear_user_page() for each of them.  During the loop "vaddr" is modified. 
However on m68k clear_user() is a macro which does not use "vaddr".  The
compiler sees a variable which is modified but never used and emits a
warning for that:

include/linux/highmem.h: In function 'clear_user_pages':
include/linux/highmem.h:234:63: warning: parameter 'vaddr' set but not used [-Wunused-but-set-parameter=]
    static inline void clear_user_pages(void *addr, unsigned long vaddr,

Other architectures use an inline function for clear_user_page() which
avoids the warning.  This is not possible on m68k, as dlush_dcache_page()
is another macro which is not yet defined where clear_user_page() is
defined.  Including cacheflush_mm.h will trigger recursive and lots of
other issues.

So hide the warning with a cast to (void) instead.

While we are here, do the same for copy_user_page().

Link: https://lore.kernel.org/20260525-m68k-clear_user_page-v2-1-0c8981c6eca1@weissschuh.net
Fixes: 62a9f5a85b98 ("mm: introduce clear_pages() and clear_user_pages()")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/page_mm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/m68k/include/asm/page_mm.h~m68k-avoid-wunused-but-set-parameter-in-clear_user_page
+++ a/arch/m68k/include/asm/page_mm.h
@@ -55,10 +55,12 @@ static inline void clear_page(void *page
 #define clear_user_page(addr, vaddr, page)	\
 	do {	clear_page(addr);		\
 		flush_dcache_page(page);	\
+		(void)(vaddr);			\
 	} while (0)
 #define copy_user_page(to, from, vaddr, page)	\
 	do {	copy_page(to, from);		\
 		flush_dcache_page(page);	\
+		(void)(vaddr);			\
 	} while (0)
 
 extern unsigned long m68k_memoffset;
_

Patches currently in -mm which might be from linux@weissschuh.net are

m68k-avoid-wunused-but-set-parameter-in-clear_user_page.patch

