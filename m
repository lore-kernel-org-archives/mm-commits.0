Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD87F1607B4
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756842; cv=none; b=bywQiV4PQrpnECMd+2xbf1JbrT3axZCMQ46qg6fio5RevhNKx7eO+1u7I8ZieIMe5OOXMkvTnKRhplcLX+qjukXmO4OUdJ2RN5A0L9FrbiKQ1ER6EesCKjmTGhiDI5hqvdVSXp5dBmUruq7t83z2zzjEdVrTjQ3SwDNqibM3kr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756842; c=relaxed/simple;
	bh=lkLqAJBRW/ZFipZv57hMhS2mZBFiI5VJF3DmZDYMSwI=;
	h=Date:To:From:Subject:Message-Id; b=mJhbUpBDkwsxdnUHDFSwB0oWN7+9C4K9AeBovQQEGjl40KbXoU590HQIbvVgzKBcPYmnjb9GFtnsY7Humq5Iu28lOBiRQtw1f3fVQWkqvZt8lXBpZMEcNAUM97Y7gjZupdQk7AGITaz130q6QbTvwZbU0bF8u5rzekzm/WJG80Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Go67/SX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Go67/SX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928F5C4CEED;
	Sun,  1 Jun 2025 05:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756842;
	bh=lkLqAJBRW/ZFipZv57hMhS2mZBFiI5VJF3DmZDYMSwI=;
	h=Date:To:From:Subject:From;
	b=0Go67/SXtBsRW6PMI67gFSf6U/8KzgIq7xNO4WGmeUSef6+EuBzeRfBFN1L8AiTLq
	 HKJmg17es+dmx8ZyqJSUZzEq7xCt9NnJAgL3PxDelT1/RHuXmJrtlXiQWPdeNdUY5w
	 snN3ZcmPNOaeiHFmDnEGdADHGhhIDVBZkLQfMC3s=
Date: Sat, 31 May 2025 22:47:22 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon.patch removed from -mm tree
Message-Id: <20250601054722.928F5C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/Kconfig: set DAMON_{VADDR,PADDR,SYSFS} default to DAMON
has been removed from the -mm tree.  Its filename was
     mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/Kconfig: set DAMON_{VADDR,PADDR,SYSFS} default to DAMON
Date: Tue, 20 May 2025 21:27:54 -0700

Patch series "mm/damon: build-enable essential DAMON components by
default".

As of this writing, multiple major distros including Alma, Amazon,
Android, CentOS, Debian, Fedora, and Oracle are build-enabling DAMON (set
CONFIG_DAMON[1]).  Configuring DAMON is not very easy, since it is
disabled by default, and there are multiple essential options that need to
be manually turned on, one by one.  Make it easier, by grouping essential
configurations to be enabled with one selection, and enabling build of the
essential parts of DAMON by default.

Note that build-enabling DAMON does not introduce any real risk, since it
makes no behavioral change by default.  It requires explicit user requests
to do anything.  Only one potential risk is making the size of the kernel
a little bit larger.  On a production-purpose configuration, it increases
the resulting kernel package binary size by about 0.1 % of the final
package file.  I believe that's too small to be a real problem in common
setups.

DAMON_{VADDR,PADDR,SYSFS} are de-facto essential parts of DAMON for normal
usages.  Because those need to be enabled one by one, however, and there
are other test-purpose or non-essential configurations, it is easy to be
confused and make mistakes at setup.  Make the essential configurations
default to CONFIG_DAMON, so that those can be enabled by default with a
single change.

Link: https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=DAMON [1]
Link: https://lkml.kernel.org/r/20250521042755.39653-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250521042755.39653-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon
+++ a/mm/damon/Kconfig
@@ -28,6 +28,7 @@ config DAMON_VADDR
 	bool "Data access monitoring operations for virtual address spaces"
 	depends on DAMON && MMU
 	select PAGE_IDLE_FLAG
+	default DAMON
 	help
 	  This builds the default data access monitoring operations for DAMON
 	  that work for virtual address spaces.
@@ -36,6 +37,7 @@ config DAMON_PADDR
 	bool "Data access monitoring operations for the physical address space"
 	depends on DAMON && MMU
 	select PAGE_IDLE_FLAG
+	default DAMON
 	help
 	  This builds the default data access monitoring operations for DAMON
 	  that works for the physical address space.
@@ -55,6 +57,7 @@ config DAMON_VADDR_KUNIT_TEST
 config DAMON_SYSFS
 	bool "DAMON sysfs interface"
 	depends on DAMON && SYSFS
+	default DAMON
 	help
 	  This builds the sysfs interface for DAMON.  The user space can use
 	  the interface for arbitrary data access monitoring.
_

Patches currently in -mm which might be from sj@kernel.org are


