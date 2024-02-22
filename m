Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E016FFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645175; cv=none; b=Kk7SJcZs/ZPG9qyErAyjnrrOmOVTowESWIM2+VVrvGESQlxgh8fNPZBuIaUUZvATvzosb9zCQcRQ8LFDelDCw6SwC4PyxH1vmQwjUO/m5/HjYrxcHtTonyXaH4UoQFA0SpU9VQ9dFCu+oFxpRaiRinOQKvhI/CeUQYodOxHu2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645175; c=relaxed/simple;
	bh=m9v/2TctAWR4hbX0XLXJkddgZ7KB1c40TsJUKIPWHO4=;
	h=Date:To:From:Subject:Message-Id; b=LT0fNG7bpBIgkde2CDmb2brRYQnv7eA7048J91auppudeMSvJiVhPG4fZzlulH2f/FsJNboYSfnsrNk1wGpdVCnJQLSih4aHazx7PYZnEq4oacELQHMph3Z2AdjSNvR8AxA0nIcU2cJYTrAV9Sx/BQ66XkXegkFEwVxY51l02R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YDK5ptqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YDK5ptqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56406C433C7;
	Thu, 22 Feb 2024 23:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645174;
	bh=m9v/2TctAWR4hbX0XLXJkddgZ7KB1c40TsJUKIPWHO4=;
	h=Date:To:From:Subject:From;
	b=YDK5ptqbYtaVzCoSiMsuKdDBzWaZ9IWGwzRCq5U9ha/9p1m0Ik8SwfigUNbbA0VSp
	 4EvL34AxFZG+OnY2EYlMW3p5TWlSR4EL67mrehMG1WXbAgf2qJPFSs5HC8gjMS3HJ+
	 P/3uerhMMPWruXYthoZFZCB5kR2szlBmwcKsKMXs=
Date: Thu, 22 Feb 2024 15:39:33 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] panic-suppress-gnu_printf-warning.patch removed from -mm tree
Message-Id: <20240222233934.56406C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: suppress gnu_printf warning
has been removed from the -mm tree.  Its filename was
     panic-suppress-gnu_printf-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-remove-dependency-of-fa_dump-on-crash_dump-fix.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch

