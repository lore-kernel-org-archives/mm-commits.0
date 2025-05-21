Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609522B9A9
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 22:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747866803; cv=none; b=ihDMGODZscSZyKzhcULv4F0fM5dNMNI2YO2s21RJu7dbKtvN1F3bX22MzvjWg3r+pFe17cBrrH80n2zzc+Kj77ENBv4xBGLtcbhpMhOikUDakB8qoiQRZU7FVTnh4FpvVOclQH/TCkVdY7IgM+QPTHLiyDJF9b8oeJdzyKmRYOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747866803; c=relaxed/simple;
	bh=tlF9NjF0IZALu1nZnzo4YHM9LnIo7tOgdoq6m4nhKFo=;
	h=Date:To:From:Subject:Message-Id; b=IYcNGYGYbdcSx/hVgOLDyzS6vhRZgSif+U8vYOU9OlPPTrXbCyRziCaer/F5QtMqVWc9kxpea/xXXo1gGWUIvM8mWx83+EisV1dR58uh5QcXywPLwmsoFoB2yaIjkY6uQfObX0XT9lcj3G0fcSSP30nH/mHGxrJB4rRt5baAGwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DE5QiNdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DE5QiNdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64F2C4CEE4;
	Wed, 21 May 2025 22:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747866802;
	bh=tlF9NjF0IZALu1nZnzo4YHM9LnIo7tOgdoq6m4nhKFo=;
	h=Date:To:From:Subject:From;
	b=DE5QiNdLzyvG4RMFoSUv+qrdsPslLlTNkZexWo4SdfmCFReX6yilVWkpenhrETh4y
	 nk2O8aN9ptwxWYIfSbvnGfVcj5m5GBTbQ1NrOMfjvBPzkFTVJRIAMOCSxVnqK47cJr
	 l75Ou0t0Inv+3wNaHQIDNHDAL9R6gcmCfZbgN6kw=
Date: Wed, 21 May 2025 15:33:22 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon.patch added to mm-unstable branch
Message-Id: <20250521223322.B64F2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/Kconfig: set DAMON_{VADDR,PADDR,SYSFS} default to DAMON
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon.patch

This patch will later appear in the mm-unstable branch at
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

mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon.patch
mm-damon-kconfig-enable-config_damon-by-default.patch

