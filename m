Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D236235045
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338662; cv=none; b=oNyEDshQxBI7f1SIk43vbVPSN5ok8qDBHBSx3atY7B9gjnCik5gdcRo5+xANOa7rRLeEjsSAvw/5nf1N+jitIcPfnwnk4m/LTjW0YEF66+FMokqvb7pjq3uRhD1pLgDHuG+JY6LMwKN3OGP+onGrwUUK9raUtmWeJ2iqvebNdYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338662; c=relaxed/simple;
	bh=eeQ0e9/QlsR+Fk729PwzKGiAIIm/0KRGtMMNT0/z+hA=;
	h=Date:To:From:Subject:Message-Id; b=leu6bGP7KdNtBD9yF1cryFiVWkwDmYuv2eAV5UN80mm1mycl6Nsls0Wgsde1p96GV393Bm4T421Trt5nz5HzDytWedQJ3sLL7fZa2mMSviYIuManyNta6EZmWIgKubL0KIRvfPqapuxYKrVPKsJJM6hvo8DIjCClT/I+31jDwNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZJTtQEh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZJTtQEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5579B1F0089B;
	Wed,  7 Oct 2026 02:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338661;
	bh=S4n73fLXB/jpVPCIiPH9gPNjPaUGVuEC6v/1IDDlWjE=;
	h=Date:To:From:Subject;
	b=cZJTtQEhPQCiAdnDW60TstEhQrDXq8ZBYxFlCDv+G3f1WFMjprljLnmTzJpiwjwSQ
	 5DzNGJAOIBOjJ8u5XjOqTjIVxhIHJLHDdf0tGMNtalObHB0Z+og/YenlfnJT3NHovE
	 qYOdlEBmfSZqZklZ0ABi70NXlkSoFhhfR3TPTRTA=
Date: Tue, 06 Oct 2026 19:04:20 -0700
To: mm-commits@vger.kernel.org,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch removed from -mm tree
Message-Id: <20261007020421.5579B1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/main: fix false-positive kernel panic on environment variable overwrite
has been removed from the -mm tree.  Its filename was
     init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -548,12 +548,12 @@ static int __init unknown_bootoption(cha
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

mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch

