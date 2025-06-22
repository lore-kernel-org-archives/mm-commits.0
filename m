Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7712260C;
	Sun, 22 Jun 2025 18:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750617356; cv=none; b=PnTmdTii9F6SEXdUT0UYD7YcgBsJk0SvY+BpekhBnv3oxniHHwaVqH8I+MPu9mOEnZp2dJ357GtByjFKz8089ooxF74MMUgvji0s7FwJoXhfS02opHZL0pnIwqehUYiVUip8ZsOQ6OCLEKNQTKdxXPMMzM2qILRofxr9gWoa0xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750617356; c=relaxed/simple;
	bh=cB+p3vGwT20dtxKtynR6gKLX2QPVZul3EER/Uazvc8c=;
	h=Date:To:From:Subject:Message-Id; b=si9YTKUptJVKlFJHFzVy/oYX3fiIl9P4prZIOHjWs46UfxfQJy4ZhMCFXiLP2gPsyfmT0v22ym2Gg2RttYTrqGWX108wgbVcEZ+xuLYRmlAFYazjIEbOuPY9TEI7wq6nf7r5kypK41kJiLwwxRV8G3dFBILpswq/Gs1r7EhOsis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q9Mc/B+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q9Mc/B+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D2BC4CEE3;
	Sun, 22 Jun 2025 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750617355;
	bh=cB+p3vGwT20dtxKtynR6gKLX2QPVZul3EER/Uazvc8c=;
	h=Date:To:From:Subject:From;
	b=Q9Mc/B+U0lJE+jOQ3BOdS0y0vdVJWX+Zbz0ksjrj/GWVfiG1qSig1kamNg8RtV8x8
	 yEy1Ihs3kZfJw8dOnczdQx16DmJ+/fur0nKxBsxmdOWHY18rgq7TaMh2TjYVTdAPos
	 HvSKO5/ETcdcMlPy1e/uLcvp/7kVWyDgz7jyFWh8=
Date: Sun, 22 Jun 2025 11:35:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,gregkh@linuxfoundation.org,fossdd@pwned.life,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-fix-build-without-execinfo.patch added to mm-hotfixes-unstable branch
Message-Id: <20250622183555.43D2BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: fix build without execinfo
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kallsyms-fix-build-without-execinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-fix-build-without-execinfo.patch

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
From: Achill Gilgenast <fossdd@pwned.life>
Subject: kallsyms: fix build without execinfo
Date: Sun, 22 Jun 2025 03:45:49 +0200

Some libc's like musl libc don't provide execinfo.h since it's not part of
POSIX.  In order to fix compilation on musl, only include execinfo.h if
available (HAVE_BACKTRACE_SUPPORT)

This was discovered with c104c16073b7 ("Kunit to check the longest symbol
length") which starts to include linux/kallsyms.h with Alpine Linux'
configs.

Link: https://lkml.kernel.org/r/20250622014608.448718-1-fossdd@pwned.life
Fixes: c104c16073b7 ("Kunit to check the longest symbol length")
Signed-off-by: Achill Gilgenast <fossdd@pwned.life>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/kallsyms.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/include/linux/kallsyms.h~kallsyms-fix-build-without-execinfo
+++ a/tools/include/linux/kallsyms.h
@@ -18,6 +18,7 @@ static inline const char *kallsyms_looku
 	return NULL;
 }
 
+#ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
 #include <stdlib.h>
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
@@ -30,5 +31,8 @@ static inline void print_ip_sym(const ch
 
 	free(name);
 }
+#else
+static inline void print_ip_sym(const char *loglvl, unsigned long ip) {}
+#endif
 
 #endif
_

Patches currently in -mm which might be from fossdd@pwned.life are

kallsyms-fix-build-without-execinfo.patch

