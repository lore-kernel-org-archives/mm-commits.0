Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A6B2FE071
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 20:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768769701; cv=none; b=YShA5vkTcEC0niP6jHSHhhtSfJYVpF8y+OPhqFexm7eyCVWuNvVbCvHd+LQ4vp9rL7v4pAeAoy2kkjE7Q/SMzpS+ZrKis3gSo8+egj25tqMyiJUPXVeoPpF8sQF4/4DSXTyo038b8Caqb28Lfnj4skwnP4A43TcPN3zkaSRgr6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768769701; c=relaxed/simple;
	bh=DK89VWBY3+Qe7rsy4noP2dXXi8dMDVbbjIVAM2bsKig=;
	h=Date:To:From:Subject:Message-Id; b=RqL0t34YFDN8+HYNMUT/TiBCtiW0Aen3K2ztSitXkD4/52PSlxufWf/WwVyoWRdqx3IijqrPo5z8x7WJCp9B5lrWJEVTzS6GVmjMJzispkQGnd7NbF8ANsLuXSPDvvcnwTSaZXdlZd/TpOd3gtD5QDbae36M2Fvm6aCEfUK37vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IlGggb57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IlGggb57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3D8C116D0;
	Sun, 18 Jan 2026 20:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768769701;
	bh=DK89VWBY3+Qe7rsy4noP2dXXi8dMDVbbjIVAM2bsKig=;
	h=Date:To:From:Subject:From;
	b=IlGggb57TiP9KaSXFl66WG/qpwAqWzEM71tVtpXTeWk8HS1yvGTLxR+onI+mxDdDn
	 gg6adHMePm33S5MG3W/+8888sdjnfiC6e8NPR3PlPCjM5lq+IaNmYyZAAzITeeaQ8v
	 9IHOXAZKjD0tjPBQRjPuFUHNKPgQYNM0ybNa4ZLQ=
Date: Sun, 18 Jan 2026 12:55:00 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lkp@intel.com,bhe@redhat.com,pnina.feder@mobileye.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260118205501.1A3D8C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: add panic_redirect_cpu declaration to header
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
Subject: panic: add panic_redirect_cpu declaration to header
Date: Sun, 18 Jan 2026 14:01:49 +0200

Add the extern declaration for panic_redirect_cpu to linux/panic.h to fix
the sparse warning:

  kernel/panic.c:305:10: sparse: sparse: symbol 'panic_redirect_cpu'
  was not declared. Should it be static?

The variable needs to be declared in the header alongside panic_cpu since
it is used for synchronization when redirecting panic to a specific CPU
via the panic_force_cpu= boot parameter.

Link: https://lkml.kernel.org/r/20260118120149.986849-1-pnina.feder@mobileye.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601161825.pUmb6FsK-lkp@intel.com/
Signed-off-by: Pnina Feder <pnina.feder@mobileye.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/panic.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/panic.h~panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix
+++ a/include/linux/panic.h
@@ -41,6 +41,14 @@ void abort(void);
  * PANIC_CPU_INVALID means no CPU has entered panic() or crash_kexec().
  */
 extern atomic_t panic_cpu;
+
+/*
+ * panic_redirect_cpu is used when panic is redirected to a specific CPU via
+ * the panic_force_cpu= boot parameter. It holds the CPU number that originally
+ * triggered the panic before redirection. A value of PANIC_CPU_INVALID means
+ * no redirection has occurred.
+ */
+extern atomic_t panic_redirect_cpu;
 #define PANIC_CPU_INVALID	-1
 
 bool panic_try_start(void);
_

Patches currently in -mm which might be from pnina.feder@mobileye.com are

kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes.patch
kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch

