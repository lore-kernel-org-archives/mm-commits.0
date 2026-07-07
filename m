Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6236213FEE
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 20:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783456586; cv=none; b=EudJw9ebF4yAStLHuF/ZidYjufpwNuh7Qm+Y8ZZ6lF+SuRNbXc9H2mZpJcKSdjb8dVSsx7pu1r2isquaSujb6JWDNAFd/bJ/MgNOu/SPwk/eyK2P3tyZCAkeFXdmYEyNgHEwT5Ifyq89m1ReY2UI6YaXixb6tlWvVFaTI743DqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783456586; c=relaxed/simple;
	bh=4ZMAjorA4cqoKUOgmYVr/tia/s0RXop0w90O61i+t50=;
	h=Date:To:From:Subject:Message-Id; b=qvrWMYusKi5AjgRKMK9CvMOOSPUuKt0THu329koJu70B9T0cvnleQeyGHMmyAf2O8Nv8+wRD+mf6zE2b3IBrVpSqpjbC3X446UTCEtqfc+/UHYVzWVhmHaIuusF3v9Jrzg69kIKOFsbBJJ8uOGe6+iPA0E30bdDB7qKKr2BlzHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J7KOiJcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J7KOiJcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBE31F000E9;
	Tue,  7 Jul 2026 20:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783456585;
	bh=Km3vUVqYYhwHn++eaqbHic/w2mojLk1MQ588LsQCpDU=;
	h=Date:To:From:Subject;
	b=J7KOiJcfywxfbHoc276cIBOjLdxcnStu4wJvY7LIzd27KijZowGfnopmRPzOxHaPu
	 pabykFLbMnX8avJtSC4YrHSHbu3MJq3HF92Zwf1eTIC2pNgodY8lz+qjrewjx9tp7m
	 6H0e/96EjuRTael7BQGlWKcB8YagUb06v+QT5RJg=
Date: Tue, 07 Jul 2026 13:36:24 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainerignore-add-nathan-chancellor.patch added to mm-nonmm-unstable branch
Message-Id: <20260707203625.1CBE31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .get_maintainer.ignore: add Nathan Chancellor
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_maintainerignore-add-nathan-chancellor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainerignore-add-nathan-chancellor.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: .get_maintainer.ignore: add Nathan Chancellor
Date: Tue, 07 Jul 2026 12:52:25 -0700

I do work all over the tree as part of ClangBuiltLinux and Kbuild, which
ultimately results in a lot of irrelevant CCs when submitters run
get_maintainer.pl with the default git fallback enabled.  Add myself to
.get_maintainer.ignore so I only get CC'd through explicitly maintained
files/patterns or a submitter intentionally adding me to the list.

Link: https://lore.kernel.org/20260707-add-nathan-to-get_maintainers-ignore-v1-1-810926e8eea3@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .get_maintainer.ignore |    1 +
 1 file changed, 1 insertion(+)

--- a/.get_maintainer.ignore~get_maintainerignore-add-nathan-chancellor
+++ a/.get_maintainer.ignore
@@ -5,4 +5,5 @@ Askar Safin <safinaskar@gmail.com>
 Christoph Hellwig <hch@lst.de>
 Jeff Kirsher <jeffrey.t.kirsher@intel.com>
 Marc Gonzalez <marc.w.gonzalez@free.fr>
+Nathan Chancellor <nathan@kernel.org>
 Ralf Baechle <ralf@linux-mips.org>
_

Patches currently in -mm which might be from nathan@kernel.org are

get_maintainerignore-add-nathan-chancellor.patch

