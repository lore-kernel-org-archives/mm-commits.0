Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4DF25F984
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 21:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760736956; cv=none; b=rp2DWL2yKqJ5Mimaw+x54lPmNA/ElGW1h76ue3GxZHrzJyqageMkUmYMOZnMvZ+GDaMZfHMpqx6DKeAgcBE+e3PKpZKkKVpop5CHUrLZGv26kJ5Bc7XwDUlSJ+5SCDgAL05p5Foo+2tY29VB8WQPGNcctqGXNr1txOxvbNWWIgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760736956; c=relaxed/simple;
	bh=Vber18BiUu3kpGqKG4hRvio6nXhzg/PeePQZ17hcf5o=;
	h=Date:To:From:Subject:Message-Id; b=htPlUEnOWmUvZED418YfHYWuEsm0E9+w2pJLzhv4YSHKzQXq7ef6xDo5OW7eby1gBazs2fc2xXTxLX3RT7ZEs/zrUX7jDyFx731RXdfLNJO1XM0koYJRiuTsQKpaa7++3B6n6BQumX4TquKLBnehlV4yojJti6kN+HiDEK12h38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dvQZxHQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dvQZxHQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741DDC4CEE7;
	Fri, 17 Oct 2025 21:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760736956;
	bh=Vber18BiUu3kpGqKG4hRvio6nXhzg/PeePQZ17hcf5o=;
	h=Date:To:From:Subject:From;
	b=dvQZxHQb7siG5aKfrFzO2JuBsGcBOf/LO4AXXHVHy2Nx0iipg2rF3aIkhoaoCTZex
	 IIFtNXZt2jqanLDlAY/cXf6iB/y+HlMi4ydu/fMgxoXg1SFU/UpIzfvFd2da9hYOgh
	 vyQbsFIJPLgVZE6vaY8DpyR2GGIdtAH2o/Z4TTbY=
Date: Fri, 17 Oct 2025 14:35:55 -0700
To: mm-commits@vger.kernel.org,reddybalavignesh9979@gmail.com,broonie@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-complete-kselftest-include-centralization-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251017213556.741DDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-complete-kselftest-include-centralization-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-complete-kselftest-include-centralization-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-complete-kselftest-include-centralization-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-complete-kselftest-include-centralization-fix
Date: Fri Oct 17 02:27:53 PM PDT 2025

fix samples/vfs/test-list-all-mounts.c build

In file included from /tmp/next/build/samples/vfs/test-list-all-mounts.c:11:
/tmp/next/build/samples/vfs/../../tools/testing/selftests/pidfd/pidfd.h:28:10: fatal error: kselftest.h: No such file or directory
   28 | #include "kselftest.h"
      |          ^~~~~~~~~~~~~


Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lkml.kernel.org/r/aPJD4ANRWUDVDqKc@sirena.org.uk
Cc: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/vfs/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/samples/vfs/Makefile~selftests-complete-kselftest-include-centralization-fix
+++ a/samples/vfs/Makefile
@@ -1,4 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 userprogs-always-y += test-fsmount test-statx mountinfo test-list-all-mounts
 
+CFLAGS += -I../../tools/testing/selftests
+
 userccflags += -I usr/include
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
selftests-complete-kselftest-include-centralization-fix.patch

