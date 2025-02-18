Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF67286297
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739919555; cv=none; b=b+pklvm4HT4MrCzsoqJDEYKpNTWk2JSRvIfqEfYzBF4JOHrF+MQ6wjFZmRlx6/jL1gsPYg2kJLxKm2fCzoxbvnJVSqRNh8Bao1+XGjOBg/HwPox/w4euNMPOgRa7BmiQfaHreQsU4rQpFMbNeoHgJ8ity9lIYkl8Qj6I3YATavo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739919555; c=relaxed/simple;
	bh=T3aba31vVR/I0tBmJLa2z6ZtQLoH8dvq+tdTD2YFke0=;
	h=Date:To:From:Subject:Message-Id; b=Oc8Ew2NTGRfCfa2EN9btEdhyrXsSAa0gUEZdm1l9SToxkk/hwRh+XCGN7x8HSc2fqVLJhu31Oqov+I0HV539mW3k0gEcBRDFYJF92y7PfrdQQU1oyJeIUYxKwZhjsuLsg1GtsfzBsJjjicS2v7DTabEkKQ2fmWLq2L80hHyT9HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gir786G+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gir786G+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5836BC4CEE2;
	Tue, 18 Feb 2025 22:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739919555;
	bh=T3aba31vVR/I0tBmJLa2z6ZtQLoH8dvq+tdTD2YFke0=;
	h=Date:To:From:Subject:From;
	b=gir786G+I2Uvpmy0mpHG5IxLMn+wAz044lHT3+GVTejQi4UY02Ruzgo0oMPlNdd9Z
	 yOpzJnID0yNHjZMRN4jH5Yyc8KvAISpXCM3aXoXgRppHzhIvGrd6AVsWUUq8S0MZFK
	 MVCd98QZHJ9485kEJdwkEdJg0WT7mFnMaskdgAB0=
Date: Tue, 18 Feb 2025 14:59:14 -0800
To: mm-commits@vger.kernel.org,sw@simonwunderlich.de,qmo@kernel.org,othacehe@gnu.org,neeraj.upadhyay@kernel.org,kees@kernel.org,gregkh@linuxfoundation.org,eugen.hristev@linaro.org,elder@kernel.org,antonio@mandelbit.com,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-never-used-parityio-email.patch added to mm-nonmm-unstable branch
Message-Id: <20250218225915.5836BC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove never used @parity.io email
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-remove-never-used-parityio-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-never-used-parityio-email.patch

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
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: MAINTAINERS: remove never used @parity.io email
Date: Tue, 18 Feb 2025 18:06:05 +0200

As this employment lasted only four months and was never used over here,
let's just rip it off for good.

Link: https://lkml.kernel.org/r/20250218160607.48829-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Eugen Hristev <eugen.hristev@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mathieu Othacehe <othacehe@gnu.org>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 -
 1 file changed, 1 deletion(-)

--- a/.mailmap~maintainers-remove-never-used-parityio-email
+++ a/.mailmap
@@ -303,7 +303,6 @@ Jan Glauber <jan.glauber@gmail.com> <jgl
 Jan Kuliga <jtkuliga.kdev@gmail.com> <jankul@alatek.krakow.pl>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
-Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@parity.io>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are

maintainers-remove-never-used-parityio-email.patch

