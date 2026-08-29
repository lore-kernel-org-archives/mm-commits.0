Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6093F1055
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788046601; cv=none; b=jTfR6M8Z8RKwn7GoH/QvLyoOFaGg/XV9gnqIJGoQu3KBCzNbNzdKiv/HJ/wO8LwTzmQxe7PsY1Ol5gV1QV7ibWdP4V2G+PfY44A4VbdNRVx8aCDhFEqSsUw4Eg/W+26duzyWKi6u+Ea7UikMxtdg2cuN30ktUbiuinIcuJpAYMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788046601; c=relaxed/simple;
	bh=ZNDv200IvAb8BxAMX9nMS+0X45r1Fm3bD39Q1bDx+SU=;
	h=Date:To:From:Subject:Message-Id; b=ldX7LcT10pgIDM9/2hu7XGULyhpZrb/Er2FMurNdQom9UwIhlsObbX+jbQiMxt8q0VTyADlvSlSxYjJJFi60vob+AOtnyrlDVU97cZHTwU77mY3qqo8kgu1l4YlcjLgfXohmdI/sTApodsn+oeu9yQ1Su7prOuiAUKtcy7ae+ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zpmSRWvM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zpmSRWvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6801F000E9;
	Sat, 29 Aug 2026 23:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788046599;
	bh=Rg0aDLqYkx9J1v/fo18JxuJ4O86guscICrtGguYipbw=;
	h=Date:To:From:Subject;
	b=zpmSRWvMokKnjK4eAsqTUdr2J+6RbhzS3JOm08jBL3qn9yJkjaDcK+oIJUZYSjgEp
	 LD4qWZnfm7UtXj+Zm06YasIcEIF9mpkIx5n6zFsLnFC5OVGgko8KtVYdgAJ4JCPen8
	 9EqMh9YMmGV8YtKUCsgrNqzwWP6kdcZ12U1TEOWs=
Date: Sat, 29 Aug 2026 16:36:38 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,palmer@dabbelt.com,maze@google.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-kconfig-make-config-init_env_arg_limit-user-configurable.patch added to mm-nonmm-unstable branch
Message-Id: <20260829233639.5E6801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/Kconfig: make config INIT_ENV_ARG_LIMIT user-configurable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-kconfig-make-config-init_env_arg_limit-user-configurable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-kconfig-make-config-init_env_arg_limit-user-configurable.patch

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
Subject: init/Kconfig: make config INIT_ENV_ARG_LIMIT user-configurable
Date: Tue, 18 Aug 2026 23:16:33 +0000

Patch series "init, arch: make command line size and init arg limit
configurable", v2.

This patch series promotes COMMAND_LINE_SIZE from arch/s390/Kconfig to
init/Kconfig to be generally available to other architectures.

In some use cases, such as netboot kernels, rootfs configurations, larger
initramfs setups, require larger sizes.  While for embedded workloads, it
can be reduced to save memory.

Since COMMAND_LINE_SIZE can be larger, it also makes sense to allow
INIT_ENV_ARG_LIMIT to be configured.


This patch (of 2):

INIT_ENV_ARG_LIMIT is defined without a prompt string (`int`), making it a
hidden Kconfig symbol that defaults to 32 (or 128 for UML) and cannot be
configured in `make menuconfig`.

Now that CONFIG_COMMAND_LINE_SIZE is configurable across all
architectures, users who select larger kernel command lines (e.g., 4096
bytes) may pass more than 32 command-line arguments or environment
variables (`foo=bar`) to `/sbin/init`.  If INIT_ENV_ARG_LIMIT remains
hardcoded at 32, any argument after the 32nd sets the panic_later flag and
causes a hard kernel panic on boot.

Add a prompt string ("Maximum number of kernel command line arguments")
and a `range 32 4096` to `config INIT_ENV_ARG_LIMIT` so that users can
configure their init argument and environment variable limit when needed,
while preserving the existing default of 32 for standard builds.

Link: https://lore.kernel.org/20260818231646.804507-1-wfelipe@google.com
Link: https://lore.kernel.org/20260818231646.804507-3-wfelipe@google.com
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/init/Kconfig~init-kconfig-make-config-init_env_arg_limit-user-configurable
+++ a/init/Kconfig
@@ -231,9 +231,10 @@ config BROKEN_ON_SMP
 	default y
 
 config INIT_ENV_ARG_LIMIT
-	int
+	int "Maximum number of kernel command line arguments"
 	default 32 if !UML
 	default 128 if UML
+	range 32 4096
 	help
 	  Maximum of each of the number of arguments and environment
 	  variables passed to init from the kernel command line.
_

Patches currently in -mm which might be from wfelipe@google.com are

selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch
selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch
init-arch-make-config_command_line_size-globally-configurable.patch
init-kconfig-make-config-init_env_arg_limit-user-configurable.patch

