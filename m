Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F21C25760
	for <mm-commits@vger.kernel.org>; Mon,  2 Jun 2025 22:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748905153; cv=none; b=KylqFnXwG/CWrsXc6MRBr82CYOyumaSNQ0JlzKUm6BZkc4CbHo9mcrvdctAZsAVoBiqLpYQT7nIJLPbGy5Yra//l+oxl7H7wUGHg7JHWMk92HRFyawm+/mylRy5OEMOTk+RhTMbrJwIVNKu148WwF4QiXZtHgvSWJxDy+bFYqz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748905153; c=relaxed/simple;
	bh=3nwNXH2v5vuKrNgC59TjBSW3i9jiiDxz5sHUOJTRCUs=;
	h=Date:To:From:Subject:Message-Id; b=WhRg44GCkZQCLJMyeCrgASKIQ0hSPc2nlyHblS6PKqJZS01Y6hbqKwyG82pNOZQPIyCT0NCAYcKseKSxFdnvSulY6lw/YdShhBZVqMnFu6JPI8yof5FBVDGGg17lzc1Cm/V+4w5TRsmT2XwEm7yJNvZugAavqRxq7K/l84LHRm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qkp9C4n+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qkp9C4n+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BE8C4CEEB;
	Mon,  2 Jun 2025 22:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748905152;
	bh=3nwNXH2v5vuKrNgC59TjBSW3i9jiiDxz5sHUOJTRCUs=;
	h=Date:To:From:Subject:From;
	b=Qkp9C4n+k0k9Sx4s5MDzkyTFQ/bWsK9qxiTikIAhVJDxxZ+CB4r0H3VQ4IOEQSybB
	 JPzjz9U5e3KpHwDizmUurAFPKJDEB+3f8hPZ8/+7cKn825ZjN+sfq5ZQ7+mljTRrk0
	 76qjcigJRNbiM2VLGwQdzdk9ylfSiaTtGFY35ZHU=
Date: Mon, 02 Jun 2025 15:59:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,hughd@google.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-compile-error-when-config_shmem-is-not-set.patch added to mm-hotfixes-unstable branch
Message-Id: <20250602225912.08BE8C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix compile error when CONFIG_SHMEM is not set
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-compile-error-when-config_shmem-is-not-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-compile-error-when-config_shmem-is-not-set.patch

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
From: Steven Rostedt <rostedt@goodmis.org>
Subject: mm: fix compile error when CONFIG_SHMEM is not set
Date: Mon, 2 Jun 2025 17:05:00 -0400

When CONFIG_SHMEM is not set, the following compiler error occurs:

ld: vmlinux.o: in function `ttm_backup_backup_page':
(.text+0x10363bc): undefined reference to `shmem_writeout'
make[3]: *** [/work/build/trace/nobackup/linux-test.git/scripts/Makefile.vmlinux:91: vmlinux.unstripped] Error 1
make[2]: *** [/work/build/trace/nobackup/linux-test.git/Makefile:1241: vmlinux] Error 2
make[1]: *** [/work/build/trace/nobackup/linux-test.git/Makefile:248: __sub-make] Error 2
make[1]: Leaving directory '/work/build/nobackup/tracetest'
make: *** [Makefile:248: __sub-make] Error 2

This is due to the replacement of writepage and calling swap_writepage()
and shmem_writepage() directly.  The issue is that when CONFIG_SHMEM is
not defined, shmem_writepage() is also not defined.  Add it as a stub, and
it should also never be called when CONFIG_SHMEM is undefined.

Link: https://lkml.kernel.org/r/20250602170500.48713a2b@gandalf.local.home
Fixes: 84798514db50 ("mm: Remove swap_writepage() and shmem_writepage()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/shmem.c~mm-fix-compile-error-when-config_shmem-is-not-set
+++ a/mm/shmem.c
@@ -5760,6 +5760,11 @@ void shmem_unlock_mapping(struct address
 {
 }
 
+int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
+{
+	return 0;
+}
+
 #ifdef CONFIG_MMU
 unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long addr, unsigned long len,
_

Patches currently in -mm which might be from rostedt@goodmis.org are

mm-fix-compile-error-when-config_shmem-is-not-set.patch

