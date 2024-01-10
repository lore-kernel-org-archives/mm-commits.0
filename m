Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28973C2F
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dD/PGCG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2A3C433F1;
	Wed, 10 Jan 2024 05:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704865165;
	bh=DmFWOr4Y/X3NH4geJUvPv0wXqavJ1SHB8SQ6PDZGXvA=;
	h=Date:To:From:Subject:From;
	b=dD/PGCG7APVXpU54hIIgTA7UWtgdaxZA5RBu54KjDesOm9exNOSzhDrgd5LTXODKx
	 J+A9k/i12yJvI5/5KIDc+Nes31blqgynb4gZNx1iQQ45AjMu+VqQYqTB9NDFQOdyOs
	 Ut3WIyGD55m+6iMR/3VaJHRNIK6JpqtGT4lC9uTk=
Date: Tue, 09 Jan 2024 21:39:24 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-suppress-gnu_printf-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20240110053925.3C2A3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: suppress gnu_printf warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-suppress-gnu_printf-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-suppress-gnu_printf-warning.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: panic: suppress gnu_printf warning
Date: Sun, 7 Jan 2024 17:16:41 +0800

with GCC 13.2.1 and W=1, there's compiling warning like this:

kernel/panic.c: In function `__warn':
kernel/panic.c:676:17: warning: function `__warn' might be a candidate for `gnu_printf' format attribute [-Wsuggest-attribute=format]
  676 |                 vprintk(args->fmt, args->args);
      |                 ^~~~~~~

The normal __printf(x,y) adding can't fix it. So add workaround which
disables -Wsuggest-attribute=format to mute it.

Link: https://lkml.kernel.org/r/20240107091641.579849-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/panic.c~panic-suppress-gnu_printf-warning
+++ a/kernel/panic.c
@@ -666,8 +666,13 @@ void __warn(const char *file, int line,
 		pr_warn("WARNING: CPU: %d PID: %d at %pS\n",
 			raw_smp_processor_id(), current->pid, caller);
 
+#pragma GCC diagnostic push
+#ifndef __clang__
+#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
+#endif
 	if (args)
 		vprintk(args->fmt, args->args);
+#pragma GCC diagnostic pop
 
 	print_modules();
 
_

Patches currently in -mm which might be from bhe@redhat.com are

panic-suppress-gnu_printf-warning.patch

