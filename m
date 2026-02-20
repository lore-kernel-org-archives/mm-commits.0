Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438562DD5E2
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 21:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771621626; cv=none; b=hepbG2RfKKgH0DpwahGUMAI4dmlUkX8WdArphRvn9j9s8Zin6GD3ykCRh79ZGHesNMfwtOp/beVC5JXkPhHSMVD+FXSzyW3jm+KQ923eFIzOSxx+euPbwQoDeROCo3Oij9q/9q5RUIrZtopIKjy3pfxgiq3XIzA3T/6p/Dmko4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771621626; c=relaxed/simple;
	bh=SoCXJ/0+6FApMDIgotjW4YRn4l3f3MFI+0EpORv0/Qs=;
	h=Date:To:From:Subject:Message-Id; b=ulTjtz7hmaqNpHTZUs+Fvy+cmv/3+Z2gExrzXWip2hNqmyfgMEtD1ENhSNLxcWhWR2dHGm+fJ6qUpoZjXCR0xIwuplCMyAocsNfOzv2z/2blr40bjtOm36I3uXzqj+xzXsneOgsYI+cwrFDdhkzwuST8jnEY4lScQYxoDdppNTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=am6LcLYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="am6LcLYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E0EC116C6;
	Fri, 20 Feb 2026 21:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771621625;
	bh=SoCXJ/0+6FApMDIgotjW4YRn4l3f3MFI+0EpORv0/Qs=;
	h=Date:To:From:Subject:From;
	b=am6LcLYBRmYF7L7acCFDqgGVXprBGF9Hi/PcmuTcFZMPxQDYKfT+pX3aEZnCV+JUV
	 koeUYMFwJIBV+xh4AgihcGucbY5NcgWsmMSozhRciFQfsnRJ0Tv8B8NEyvzmOyyi7m
	 Y2uVYyMwcp79+sQ/6HuPQMX6wCeiGxv+w+yLayXM=
Date: Fri, 20 Feb 2026 13:07:05 -0800
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,joel.granados@kernel.org,rioo.tsukatsukii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch added to mm-nonmm-unstable branch
Message-Id: <20260220210705.C7E0EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/panic: increase buffer size for verbose taint logging
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch

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
From: Rio <rioo.tsukatsukii@gmail.com>
Subject: kernel/panic: increase buffer size for verbose taint logging
Date: Fri, 20 Feb 2026 20:45:00 +0530

The verbose 'Tainted: ...' string in print_tainted_seq can total to 327
characters while the buffer defined in _print_tainted is 320 bytes. 
Increase its size to 350 characters to hold all flags, along with some
headroom.

Link: https://lkml.kernel.org/r/20260220151500.13585-1-rioo.tsukatsukii@gmail.com
Signed-off-by: Rio <rioo.tsukatsukii@gmail.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/panic.c~kernel-panic-increase-buffer-size-for-verbose-taint-logging
+++ a/kernel/panic.c
@@ -854,10 +854,12 @@ static void print_tainted_seq(struct seq
 	}
 }
 
+/* 350 can accomadate all taint flags in verbose mode, with some headroom */
+#define TAINT_BUF_MAX 350
+
 static const char *_print_tainted(bool verbose)
 {
-	/* FIXME: what should the size be? */
-	static char buf[sizeof(taint_flags)];
+	static char buf[TAINT_BUF_MAX];
 	struct seq_buf s;
 
 	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
_

Patches currently in -mm which might be from rioo.tsukatsukii@gmail.com are

kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch

