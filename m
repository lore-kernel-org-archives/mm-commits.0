Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3712A1EB3D;
	Sat, 15 Jun 2024 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473438; cv=none; b=QJaWY7ZMdTmn3YgZch6bxtKd4BLsfxkNZwfGX22dehydGDyvDk73kJocaxsU6LGeAI6V7Pqb9A8iVU6SQFkbrbqtZayirw6nr1O3wsDgtIx2pyGO2/WpIrK8jNi3iya21muQchxejrobN3R9hVTEGeKI318+ZBe0CTVVF7hfgCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473438; c=relaxed/simple;
	bh=h3x5q/IhgOqB4QEFworV6zpzSawmpqBbpHTTAjMsiTk=;
	h=Date:To:From:Subject:Message-Id; b=LB08CcTs4xMlMCpxN/pRG0Cxsd/y6tTrpiOsoTsoufzueqBgbtiR6A5NzNhvYp4mtrE6ToOb/n/MjHkTth1ejcrD0/U/UUa0/THG8cUcC8kACFfMQWad03dH/g0c1+lckrmoEQpiyY08dMgjqVG4uxrpjxShuzO6Us2rueWn4Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qFBRwOdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qFBRwOdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B457DC3277B;
	Sat, 15 Jun 2024 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473437;
	bh=h3x5q/IhgOqB4QEFworV6zpzSawmpqBbpHTTAjMsiTk=;
	h=Date:To:From:Subject:From;
	b=qFBRwOdnpUH855ZMAeggJdYoUQLq127RdIv6ZziNpmhOutOHRhM/tSC9Bhr2K7444
	 YOUN1Zc/42pITuGIx8IFgQK2BUbY+9nBY94nHseMOxjkng3nhwFYCs4RMgytSCyw+x
	 V09niou+jVgsbiLKM+qmp5o59jVtOgd+Y2xHdhXY=
Date: Sat, 15 Jun 2024 10:43:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,samuel.holland@sifive.com,rppt@kernel.org,pmladek@suse.com,paulmck@kernel.org,hca@linux.ibm.com,arnd@arndb.de,aquini@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default.patch removed from -mm tree
Message-Id: <20240615174357.B457DC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default
has been removed from the -mm tree.  Its filename was
     mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: default to `y' if 32-bit, per Rafael]
Link: https://lkml.kernel.org/r/20240606180622.102099-1-aquini@redhat.com
Fixes: 1854bc6e2420 ("mm/readahead: Align file mappings for non-DAX")
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: <stable@vger.kernel.org>
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
+	default y if !64BIT
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


