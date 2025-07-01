Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AFD27FB34;
	Tue,  1 Jul 2025 19:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751396983; cv=none; b=irM4ppabJ0DTRcw41zQfUctLbY3v3OGkVMg/rr5RD1NFBA5J2E36LIstOl07msOpykBLj7GfbUbogXQm5wmdptOI2Yq7LtQClCDZOEDH4UfW18MrzmhQaad5o3YWqABTxA/j0C9igdw2Dgbbk3kbLHukuE2XhoAHQSHhTP7U8ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751396983; c=relaxed/simple;
	bh=+aq+ORyCy6Lpz9SFUKrcE4bWltJnfJWhZuLKvrvBDpQ=;
	h=Date:To:From:Subject:Message-Id; b=KCMwEO4ZCuSCumgShno1CByZUHVBgE4vGn7swiniBPpG/jSgasHNt6fh14/J2nCrs5CcBmA78SPAhtyuxHTxlo6ps7A+ve0VOFQVJJmU3JXGqQIipMz/1UuIIAqcKNLyJwTLRN13k67WQVm+CXdlZERWjRMoHBBaVDfDGTYUV7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NAJkSLnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NAJkSLnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F122C4CEEB;
	Tue,  1 Jul 2025 19:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751396983;
	bh=+aq+ORyCy6Lpz9SFUKrcE4bWltJnfJWhZuLKvrvBDpQ=;
	h=Date:To:From:Subject:From;
	b=NAJkSLnSeQ7vFh8xP4Vqrut7oceEPRJ1AQ+AuAjhniKrMECFJi+fRzxgsJHzGv4Jy
	 RgL5P0sCFj4y+aofKeBU49/qpD7UhuCkVrZnuE0eqVUE4J670Hok1nEesgTeZ9GIfC
	 4M3tP/1nspHbGd7rKfsWk0npOg19dzhV0vnVyOAs=
Date: Tue, 01 Jul 2025 12:09:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,luis@igalia.com,gregkh@linuxfoundation.org,fossdd@pwned.life,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-fix-build-without-execinfo.patch added to mm-hotfixes-unstable branch
Message-Id: <20250701190943.0F122C4CEEB@smtp.kernel.org>
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
Cc: Luis Henriques <luis@igalia.com>
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

