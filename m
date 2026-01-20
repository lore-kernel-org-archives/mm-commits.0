Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4806340B6CE
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 17:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768930001; cv=none; b=O/KEPyOujXHLHHI7JmfDnohjgxZy2KH/vEqo969upHbu5ufiVBuwOEibzxV48B+hiL+258n48WfSWsUxnASqMsj53WpaXSoGVsXB0P4/Z/ExzDmAtEnc4TSwwjGYUPfChkHo2fJzXeG5N7ueBAcFQBQHxSazc4HNEu8NDbZRTGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768930001; c=relaxed/simple;
	bh=frMcuF9MNAOGJ0PthJT2UCMNQ55JLylUOKwA9FHnMkw=;
	h=Date:To:From:Subject:Message-Id; b=PPWF4b244AQtxKMNoGo5h8YcktDbqRK0mc+fO7gOEAEF0eWNF1poQd0W+ZU57bcMXqqsgvhFsnqry5g9zJDFahoAWtA5EYbD/FS3nMWHr4OC3noO6EiMry3agowZH6zuxf2+g4MKOuDrk0tpElYdxW62ASVbVGrb8eqhQVE0sEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z4wlYCbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z4wlYCbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09229C16AAE;
	Tue, 20 Jan 2026 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768930001;
	bh=frMcuF9MNAOGJ0PthJT2UCMNQ55JLylUOKwA9FHnMkw=;
	h=Date:To:From:Subject:From;
	b=Z4wlYCbf/3TvTHwbT9dWfcZlNRCxJJCpD+HNFIfqPpPEEvGw+3SiNBdyODLtsLR9q
	 9/O1lTP31s7fdnE2KDj4LwYS1jLDsq9p6YkBKwyVbI06ERgFZWCqh+qEy4w8NyL+An
	 JzFbpFqAjWKzauoun0FFWAygHLPIVjnmp7jnQV9A=
Date: Tue, 20 Jan 2026 09:26:40 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lkp@intel.com,bhe@redhat.com,pnina.feder@mobileye.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch removed from -mm tree
Message-Id: <20260120172641.09229C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: add panic_redirect_cpu declaration to header
has been removed from the -mm tree.  Its filename was
     panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch

This patch was dropped because it was folded into panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu.patch

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

