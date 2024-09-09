Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178C4171066
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725911770; cv=none; b=ku/iQ5gSyeNlhwOtWu5lp3TaJZzpRzAGBNLpasPCK+EEJbAtszNe5D9m7sOmYpRr1yaxGDf5/w9n4ofUxbwZGZ01jPdaCdUOl84cgaOexRY6lP1b11c3KT+cprUlpyLu9WKWYoF+ZNTIQ2CRdmNbXxAKS2lzPzgBcFnKPvKuPj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725911770; c=relaxed/simple;
	bh=NZDyZ88349IND1dN/DrTS/mZdU8ue9Omn5FoCZqVTTc=;
	h=Date:To:From:Subject:Message-Id; b=D2IXdQxdiAXmyjefVqrVJf0ORU7hX7wsTxJCRA1UYLanPQiqqqlY1UWUuPJLgzwljNDJTxEYchTWFgGMXVly+2ATAm76M/FubcRA3pn1nI3N9N0FPIa9yJ43rJa0EUcVbjWgrQxYGJQlJFSaPPPynz7dMKM+YZU2YGq+ObDslpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yb0QqrFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yb0QqrFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C1EC4CEC5;
	Mon,  9 Sep 2024 19:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725911769;
	bh=NZDyZ88349IND1dN/DrTS/mZdU8ue9Omn5FoCZqVTTc=;
	h=Date:To:From:Subject:From;
	b=Yb0QqrFwQWTxdILGGpUS1TnfM6auZjEb5WrxrYEboIFdKe5HCm7tJivTb3nLqvrh3
	 J9ooiDqrA6roxY01tuki1Wf3bUG3QsXfNS9lOZ/ibjg3fULx78Se1zdgoLdp+ndNKC
	 l/0P4v6dqrUFp0J4VbMRZ/3bGa+VW93Lew3Dl31k=
Date: Mon, 09 Sep 2024 12:56:09 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,arnd@arndb.de,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + set_memory-add-__must_check-to-generic-stubs.patch added to mm-unstable branch
Message-Id: <20240909195609.B9C1EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: set_memory: add __must_check to generic stubs
has been added to the -mm mm-unstable branch.  Its filename is
     set_memory-add-__must_check-to-generic-stubs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/set_memory-add-__must_check-to-generic-stubs.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: set_memory: add __must_check to generic stubs
Date: Sat, 7 Sep 2024 17:40:42 +0200

Following query shows that architectures that don't provide
asm/set_memory.h don't use set_memory_...() functions.

  $ git grep set_memory_ alpha arc csky hexagon loongarch m68k microblaze mips nios2 openrisc parisc sh sparc um xtensa

Following query shows that all core users of set_memory_...()
functions always take returned value into account:

  $ git grep -w -e set_memory_ro -e set_memory_rw -e set_memory_x -e set_memory_nx -e set_memory_rox `find . -maxdepth 1 -type d | grep -v arch | grep /`

set_memory_...() functions can fail, leaving the memory attributes
unchanged. Make sure all callers check the returned code.

Link: https://github.com/KSPP/linux/issues/7
Link: https://lkml.kernel.org/r/6a89ffc69666de84721216947c6b6c7dcca39d7d.1725723347.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/set_memory.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/set_memory.h~set_memory-add-__must_check-to-generic-stubs
+++ a/include/linux/set_memory.h
@@ -8,10 +8,10 @@
 #ifdef CONFIG_ARCH_HAS_SET_MEMORY
 #include <asm/set_memory.h>
 #else
-static inline int set_memory_ro(unsigned long addr, int numpages) { return 0; }
-static inline int set_memory_rw(unsigned long addr, int numpages) { return 0; }
-static inline int set_memory_x(unsigned long addr,  int numpages) { return 0; }
-static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
+static inline int __must_check set_memory_ro(unsigned long addr, int numpages) { return 0; }
+static inline int __must_check set_memory_rw(unsigned long addr, int numpages) { return 0; }
+static inline int __must_check set_memory_x(unsigned long addr,  int numpages) { return 0; }
+static inline int __must_check set_memory_nx(unsigned long addr, int numpages) { return 0; }
 #endif
 
 #ifndef set_memory_rox
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

set_memory-add-__must_check-to-generic-stubs.patch

