Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C16432B9B7
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 19:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761248267; cv=none; b=fHyZgEKF74wSxpivd0FD+R1lg7+bdyG/nS7Yc4DbxuiDcwzV8aB4d9Dg7T546hdRsQZrBkf3UWHb57NSs5KsC0gf6p/NGlOsPxAB0nXhldaQzEMgQ3izKszYMbWUCPE/xMlJlsfbGlEqKVT/db+22Og1fjP+vxb8+xUf5jG7DW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761248267; c=relaxed/simple;
	bh=+IAcabHBkaU5A0NSb34mj1x1SQzZ8+C+A1pklPSxrnM=;
	h=Date:To:From:Subject:Message-Id; b=UFJ+MK/wh1mSUX15afLcMjQiDlt4ErWOeNTPJBLSSaWyGk8NJ/zq6UzCFDWXDV5RMtu5XZY5AbtxOG+S/qlerRTFEsBwlw5mc1mjHbW6hVIrWMSrB+b33bN1KLeXLt96cdzYfsi/3CCIqZl+2gJCmfuIzV0NnZyMM74HH9rZNc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1x2fMVHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1x2fMVHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4A8C4CEE7;
	Thu, 23 Oct 2025 19:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761248267;
	bh=+IAcabHBkaU5A0NSb34mj1x1SQzZ8+C+A1pklPSxrnM=;
	h=Date:To:From:Subject:From;
	b=1x2fMVHZ8k3BHISjgL/GqIOe/nL97VGyZ8WRykLKZRr3OSIPldV5MfiKgXnSiS3fW
	 UalizsKiQ6r99gU+lqw4tWTwpE7Io9JYvRlvRLGaKgf+wJ19SJmxDosWWe+GmuppBG
	 w6IGuAvkGtn6HlT3Bxsli6aT7pveh4vQ7x5eo3/Y=
Date: Thu, 23 Oct 2025 12:37:46 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,shakeel.butt@linux.dev,rppt@kernel.org,rdunlap@infradead.org,peterz@infradead.org,paulmck@kernel.org,ojeda@kernel.org,nathan@kernel.org,mkoutny@suse.com,mingo@kernel.org,masahiroy@kernel.org,kernel@jfarr.cc,kees@kernel.org,jeffxu@chromium.org,hca@linux.ibm.com,guoweikang.kernel@gmail.com,geert@linux-m68k.org,francesco@valla.it,dianders@chromium.org,chenhuacai@kernel.org,brgerst@gmail.com,brauner@kernel.org,alexander.shishkin@linux.intel.com,achant@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251023193746.EA4A8C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix
Date: Thu Oct 23 12:32:59 PM PDT 2025

make print_kernel_cmdline __init

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrew Chant <achant@google.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
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
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix
+++ a/init/main.c
@@ -944,7 +944,7 @@ static void __init early_numa_node_init(
  *   Kernel command line: jumps over the \
  *   Kernel command line: lazy dog."
  */
-static void print_kernel_cmdline(const char *cmdline)
+static void __init print_kernel_cmdline(const char *cmdline)
 {
 	size_t len;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch

