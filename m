Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A522F39182E
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788047191; cv=none; b=F4JoPtRRCfS2cba+OOARgbhjC8ATVxWFhsOYFZ7l7f1Becdg3PTmPg9geoIVtuQQ1abNuHzu7VW1mIgKJytOqExYb5mdL22pQkkJsSLy6Q1ne0rlzcE8Ovt2zEjizOVD1yaUGUk/rHB4WPN769LrKSGXAFAQUjFMBtYzJH+LJE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788047191; c=relaxed/simple;
	bh=FOdCA9U1LoCaIW0JGAon1eihN5/j5ul3eRQ5FnZatu0=;
	h=Date:To:From:Subject:Message-Id; b=fMbq5ZT8lN1Driq06iNXXOBOdDY2klXl0Hjf50a0M7nqpz6S4KLvQSmOyqOf/u+EuyY6UFipTH2gwSubYyxqJetp03ogbOB+46hQ4BFEGvdQ9U67r70qsx6H/1nHK9fIxSwaP6AFgWA1gsB+5MdeqkQnazlOapRfLNyFZchmzl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T4mcplbC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T4mcplbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5A01F000E9;
	Sat, 29 Aug 2026 23:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788047190;
	bh=RgmLESAJG1i3JI/Jdd7kPamZAjPlSxxRr/Zknv+JjCc=;
	h=Date:To:From:Subject;
	b=T4mcplbCcv6uLXFXTm7M+UpqlFdTeyA3aNKgL4EyXJhC4dXkkpO7cyXdyAsR3ugTw
	 RNff9cthyenI92bhXctYFI6AsMt2g89OXq76LoFwUU+1R/Due07nc+fw3kMrCOe1VG
	 MQhwOkdhiTGQo9uwt0uf6hR8e22IW5VpmZpdGlYc=
Date: Sat, 29 Aug 2026 16:46:29 -0700
To: mm-commits@vger.kernel.org,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch added to mm-nonmm-unstable branch
Message-Id: <20260829234630.1A5A01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/main: fix false-positive kernel panic on environment variable overwrite
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch

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
From: Wilson Felipe Pereira <wfelipe@google.com>
Subject: init/main: fix false-positive kernel panic on environment variable overwrite
Date: Tue, 18 Aug 2026 04:53:47 +0000

In unknown_bootoption(), the limit checking for environment variables sets
panic_later *before* checking if the variable already exists in envp_init.

If a user passes exactly MAX_INIT_ENVS custom variables and then
overwrites the final variable by matching its key, it causes a
false-positive hard panic on boot despite not actually exceeding the array
bounds or increasing the total variable count.

Swapping the order of these checks allows the duplicate check to break out
of the loop before the panic flag is erroneously latched.

To verify, boot a VM with 31 custom variables (filling the array up to its
limit of 32) and then overwrite the very last variable:

  ENV_VARS=$(for i in {1..31}; do echo -n "var$i=$i "; done)
  qemu-system-x86_64 -kernel bzImage -append "$ENV_VARS var31=overwrite"

Without this patch, the kernel crashes instantly with:
  Kernel panic - not syncing: Too many boot env vars at 'var31=overwrite'

With this patch, the kernel safely overwrites the variable and boots.

Link: https://lore.kernel.org/20260818045357.4123784-3-wfelipe@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/main.c~init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite
+++ a/init/main.c
@@ -543,12 +543,12 @@ static int __init unknown_bootoption(cha
 		/* Environment option */
 		unsigned int i;
 		for (i = 0; envp_init[i]; i++) {
+			if (!strncmp(param, envp_init[i], len+1))
+				break;
 			if (i == MAX_INIT_ENVS) {
 				panic_later = "env";
 				panic_param = param;
 			}
-			if (!strncmp(param, envp_init[i], len+1))
-				break;
 		}
 		envp_init[i] = param;
 	} else {
_

Patches currently in -mm which might be from wfelipe@google.com are

selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch
selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch
init-arch-make-config_command_line_size-globally-configurable.patch
init-kconfig-make-config-init_env_arg_limit-user-configurable.patch
init-main-fix-off-by-one-in-argv_init-cleanup.patch
init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch

