Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BB414B978
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718043140; cv=none; b=UZX0q7QEAl5NV6u8V3dVTmgr+YmP+WQNgnH0MC8uOyA3k6TAMWPC6yjw6lCEHAQoBVIh5VRRkx/A0V2HdZstS5ROMSj8gCUbJS9g0eIcql+j1RyglcFZwWI0JQHhCX/Q4F+79p+ZGAUz1DMKuJmDNr7ah+k67/HkxFaS6dOl2xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718043140; c=relaxed/simple;
	bh=SIXYMhCJFaGDOfj8/yQGRsHR3Vl/tv70hIVxvNAk6Cg=;
	h=Date:To:From:Subject:Message-Id; b=eidobABqbXWLK8taHc240aqND1Sg3aoq0fNlYpBrW1oSOxz/BroPlXrGz6JeS/ATSN9mweFOKZ+H17/vbtBDYVDpbWTn35haQYzmNHSxZxJTUUe+qIK9BiLPjZVwKJKJUOjfuk902rlHn1szoWGu87m1Ea3iMRzxzfqqWxZfgJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c5In2kRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c5In2kRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03CFC2BBFC;
	Mon, 10 Jun 2024 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718043139;
	bh=SIXYMhCJFaGDOfj8/yQGRsHR3Vl/tv70hIVxvNAk6Cg=;
	h=Date:To:From:Subject:From;
	b=c5In2kRsF69y43Pf5gTgyjuaq+pe48xnwFBjuFKw0fxTlOOh93f4rkUDhhxDTn5sG
	 dRup3sV4XVE33vkb2IyTeTHZGV+CuDKZJNyOzjwxyyx4YydYqakEgCz56MixrWfT8L
	 gt00L9bZciDfVFps3I9mxcJmlnjqIFdGr1DmQ+SY=
Date: Mon, 10 Jun 2024 11:12:19 -0700
To: mm-commits@vger.kernel.org,samuel.holland@sifive.com,rppt@kernel.org,pmladek@suse.com,paulmck@kernel.org,hca@linux.ibm.com,arnd@arndb.de,aquini@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default.patch added to mm-hotfixes-unstable branch
Message-Id: <20240610181219.B03CFC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default
Date: Thu, 6 Jun 2024 14:06:22 -0400

An ASLR regression was noticed [1] and tracked down to file-mapped areas
being backed by THP in recent kernels.  The 21-bit alignment constraint
for such mappings reduces the entropy for randomizing the placement of
64-bit library mappings and breaks ASLR completely for 32-bit libraries.

The reported issue is easily addressed by increasing vm.mmap_rnd_bits and
vm.mmap_rnd_compat_bits.  This patch just provides a simple way to set
ARCH_MMAP_RND_BITS and ARCH_MMAP_RND_COMPAT_BITS to their maximum values
allowed by the architecture at build time.

[1] https://zolutal.github.io/aslrnt/

Link: https://lkml.kernel.org/r/20240606180622.102099-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/Kconfig~mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default
+++ a/arch/Kconfig
@@ -1046,10 +1046,21 @@ config ARCH_MMAP_RND_BITS_MAX
 config ARCH_MMAP_RND_BITS_DEFAULT
 	int
 
+config FORCE_MAX_MMAP_RND_BITS
+	bool "Force maximum number of bits to use for ASLR of mmap base address"
+	default n
+	help
+	  ARCH_MMAP_RND_BITS and ARCH_MMAP_RND_COMPAT_BITS represent the number
+	  of bits to use for ASLR and if no custom value is assigned (EXPERT)
+	  then the architecture's lower bound (minimum) value is assumed.
+	  This toggle changes that default assumption to assume the arch upper
+	  bound (maximum) value instead.
+
 config ARCH_MMAP_RND_BITS
 	int "Number of bits to use for ASLR of mmap base address" if EXPERT
 	range ARCH_MMAP_RND_BITS_MIN ARCH_MMAP_RND_BITS_MAX
 	default ARCH_MMAP_RND_BITS_DEFAULT if ARCH_MMAP_RND_BITS_DEFAULT
+	default ARCH_MMAP_RND_BITS_MAX if FORCE_MAX_MMAP_RND_BITS
 	default ARCH_MMAP_RND_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_BITS
 	help
@@ -1084,6 +1095,7 @@ config ARCH_MMAP_RND_COMPAT_BITS
 	int "Number of bits to use for ASLR of mmap base address for compatible applications" if EXPERT
 	range ARCH_MMAP_RND_COMPAT_BITS_MIN ARCH_MMAP_RND_COMPAT_BITS_MAX
 	default ARCH_MMAP_RND_COMPAT_BITS_DEFAULT if ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
+	default ARCH_MMAP_RND_COMPAT_BITS_MAX if FORCE_MAX_MMAP_RND_BITS
 	default ARCH_MMAP_RND_COMPAT_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	help
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default.patch

