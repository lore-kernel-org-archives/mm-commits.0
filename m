Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2522528FD
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 19:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769454992; cv=none; b=jErITgnRszU1UmLtNFi2tK0vRTZmQR3zH3X3Ee9JznN2o7/e+pPgtxgE1NBmrZ1PW+QK/wySooV8Mja+2DthZrlXCjqm2NhaCgxTtss7x164HVhPVmd/sbHBAbDt3Ejec4aAwYB1/p17FRGl6ix9yqWqlzEKSs1chrM627i6X8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769454992; c=relaxed/simple;
	bh=LyED3ZG17Os2T+Rakzy8I49qnCZElEmlZC17QKDJ2+Q=;
	h=Date:To:From:Subject:Message-Id; b=dxW+TneuiBI/YQ3u1J42Fr4/wchivTqRl8Re7oZnoEb5yM70gPF9vnudzlX4GrdL4E3Rt8sxL+nuprAqHflIdSg/dt0M8ELR/w7OG8DHo8r5AVcTn1kHd+FmmAfSI1ipxyzD2uzPjZ8zApBx3ijY+6eUfqd/eNoLmm0YlewJ9fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hsRW8Q2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hsRW8Q2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661E5C116C6;
	Mon, 26 Jan 2026 19:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769454992;
	bh=LyED3ZG17Os2T+Rakzy8I49qnCZElEmlZC17QKDJ2+Q=;
	h=Date:To:From:Subject:From;
	b=hsRW8Q2CQ+gVADgkn6GsJtoebVJzxAEk75p2352eK0wK2mXf9QPQ9Z8eo63ltV/Gx
	 MtXNbPysHEQN3kkBDyf0kgnFQsvv2Cjc/wWvuk2dD2DnKlC1aeWFWNM+IsRydy/MPD
	 UELqgTprhiRuMehjwCNJxmhOupS031/UlMQAmoic=
Date: Mon, 26 Jan 2026 11:16:31 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,pnina.feder@mobileye.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260126191632.661E5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: fix unused variable warning when SMP or CRASH_DUMP disabled
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch

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
From: Pnina Feder <pnina.feder@mobileye.com>
Subject: panic: fix unused variable warning when SMP or CRASH_DUMP disabled
Date: Mon, 26 Jan 2026 14:26:18 +0200

Move panic_force_buf inside the #ifdef block to fix unused variable
warning when CONFIG_SMP or CONFIG_CRASH_DUMP is not enabled.

Link: https://lkml.kernel.org/r/20260126122618.2967950-1-pnina.feder@mobileye.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601222042.OSZryOnl-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202601230908.0vB3SoHM-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202601231058.Q6hDGfoT-lkp@intel.com/
Signed-off-by: Pnina Feder <pnina.feder@mobileye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix
+++ a/kernel/panic.c
@@ -76,7 +76,6 @@ EXPORT_SYMBOL_GPL(panic_timeout);
 unsigned long panic_print;
 
 static int panic_force_cpu = -1;
-static char *panic_force_buf;
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
@@ -307,6 +306,8 @@ atomic_t panic_cpu = ATOMIC_INIT(PANIC_C
 atomic_t panic_redirect_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_CRASH_DUMP)
+static char *panic_force_buf;
+
 static int __init panic_force_cpu_setup(char *str)
 {
 	int cpu;
_

Patches currently in -mm which might be from pnina.feder@mobileye.com are

panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch

