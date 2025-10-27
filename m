Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0B92D94A3
	for <mm-commits@vger.kernel.org>; Mon, 27 Oct 2025 22:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603116; cv=none; b=r5BYb6a1/NDqsoSBv3CK+EN/zqAJhMvQ8OQBwlb9UgbdHxm8Msiaq+EgGa6WXG25SoINt5O221r2KK7gpLCtBpA8tmVU2e9omeq4o9zp0TbIAqR1IFJNm33V25J4SAiO7n4EewnMAZAEFaUzwD50sDEVUU+uAkwVuJ+m2w9559I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603116; c=relaxed/simple;
	bh=mAgLIhr2MRGyMdKMdN6qLDYpqd1uWCbcJaQR4K+EuG4=;
	h=Date:To:From:Subject:Message-Id; b=nKqpn0EzRToLWYbXUt9duA02cag5AxFSS+yA37w/87gr9b4EScJtUGs9vmG4CQuXZF1ihbZ0C7IcoItt+ekDqUAnSyCs8ezRo5km9TrsEMhGh5Ts76lL4J5IXF/tkh5uhp+yGiqW5BM9GQwOmR9aQf0tbY7Gc7hOYqkHAR4xwVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qr/ND/eX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qr/ND/eX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8B9C4CEF1;
	Mon, 27 Oct 2025 22:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761603116;
	bh=mAgLIhr2MRGyMdKMdN6qLDYpqd1uWCbcJaQR4K+EuG4=;
	h=Date:To:From:Subject:From;
	b=Qr/ND/eXUNY2btpfiWXxoa0RrFx8Go102vzkSBSEHnRQixj5gyV3+kYCglNvL6S3u
	 TFM+8zxczbVc/c8XfxK91H2NBi4rgMVNsmsFP/3abngbRgxDN/sxj3LP3Pj8G8Jdea
	 XZ8YCmrFo6NqtnIE2qMCOiczjeDmvmSf9Pxp62m4=
Date: Mon, 27 Oct 2025 15:11:55 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,shakeel.butt@linux.dev,rppt@kernel.org,rdunlap@infradead.org,peterz@infradead.org,paulmck@kernel.org,ojeda@kernel.org,nathan@kernel.org,mkoutny@suse.com,mingo@kernel.org,masahiroy@kernel.org,kernel@jfarr.cc,kees@kernel.org,jeffxu@chromium.org,hca@linux.ibm.com,guoweikang.kernel@gmail.com,geert@linux-m68k.org,francesco@valla.it,chenhuacai@kernel.org,brgerst@gmail.com,brauner@kernel.org,alexander.shishkin@linux.intel.com,achant@google.com,dianders@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4.patch added to mm-nonmm-unstable branch
Message-Id: <20251027221156.3C8B9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4.patch

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
From: Douglas Anderson <dianders@chromium.org>
Subject: init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4
Date: Mon, 27 Oct 2025 08:22:13 -0700

- Use 0 instead of -1 to disable wrapping.
- If COMMAND_LINE_SIZE makes wrapping impossible then help compiler optimize.

Link: https://lkml.kernel.org/r/20251027082204.v4.1.I095f1e2c6c27f9f4de0b4841f725f356c643a13f@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrew Chant <achant@google.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    4 ++--
 init/main.c  |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/init/Kconfig~init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4
+++ a/init/Kconfig
@@ -1515,7 +1515,7 @@ config BOOT_CONFIG_EMBED_FILE
 config CMDLINE_LOG_WRAP_IDEAL_LEN
 	int "Length to try to wrap the cmdline when logged at boot"
 	default 1021
-	range -1 1021
+	range 0 1021
 	help
 	  At boot time, the kernel command line is logged to the console.
 	  The log message will start with the prefix "Kernel command line: ".
@@ -1526,7 +1526,7 @@ config CMDLINE_LOG_WRAP_IDEAL_LEN
 	  ideal length if a place to wrap isn't found before the specified
 	  number of characters.
 
-	  A value of -1 disables wrapping, though be warned that the maximum
+	  A value of 0 disables wrapping, though be warned that the maximum
 	  length of a log message (1021 characters) may cause the cmdline to
 	  be truncated.
 
--- a/init/main.c~init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4
+++ a/init/main.c
@@ -948,8 +948,9 @@ static void __init print_kernel_cmdline(
 {
 	size_t len;
 
-	/* Config option of -1 disables wrapping */
-	if (CONFIG_CMDLINE_LOG_WRAP_IDEAL_LEN < 0) {
+	/* Config option of 0 or anything longer than the max disables wrapping */
+	if (CONFIG_CMDLINE_LOG_WRAP_IDEAL_LEN == 0 ||
+	    IDEAL_CMDLINE_LEN >= COMMAND_LINE_SIZE - 1) {
 		pr_notice("%s%s\n", KERNEL_CMDLINE_PREFIX, cmdline);
 		return;
 	}
_

Patches currently in -mm which might be from dianders@chromium.org are

init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4.patch

