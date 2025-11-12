Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27A81B142D
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908223; cv=none; b=mJGcGr8RYVR6J8yLvOjxfIOZ1hROB6LnSLpuH7I56bPF0OdJtg5fI2d2pDjY7jazBOVExmBsaZ6Tv+8B+PunhNN6WpW4TIfCSQy/u+r4gyzWxMHxhZenUZ1t4c7PWClwwQp97P1//7vRAdO/ft3X/yk+2gaapSotJBtCkjJrNww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908223; c=relaxed/simple;
	bh=zHkrQgchbDpbdhmc9wtzcqL/mOS8kLu6MePiWgFwaJ8=;
	h=Date:To:From:Subject:Message-Id; b=QTbaFmaW7tabUKyUOFQ1w0n9IsQBhrKwaHfnDGgtYaaH77lwzMOCW/gbmNg6ruSzYVUxQ7Ir07vS6E3e4w6RiQhk0fs3WJ0LyDn/K3ku1FBWQWOlAOdDZI4AS6XDrlEcEhc7YGJmeuBOS89wwoZvX7wchAAQu0v6LUyv02II8vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BD1sXpz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BD1sXpz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38F5C4CEF5;
	Wed, 12 Nov 2025 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908222;
	bh=zHkrQgchbDpbdhmc9wtzcqL/mOS8kLu6MePiWgFwaJ8=;
	h=Date:To:From:Subject:From;
	b=BD1sXpz2O1sif4ZlTaXDDryZvue7vL1lL3qkWN369DezIzT5iG7NM1FhEYGuqn9sd
	 TdNJ3dhQfljeCCZnROkIEgjolhz+jsKLvoQ0sw7KIE0+G/n75a+U6eUsEqPmFvLyJB
	 IFVE6ecSMB/PFQY74ofuYmA+gjWRasGBQk2oZ0bA=
Date: Tue, 11 Nov 2025 16:43:42 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,broonie@kernel.org,reddybalavignesh9979@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-complete-kselftest-include-centralization-fix.patch removed from -mm tree
Message-Id: <20251112004342.B38F5C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/vfs: add selftests include path for kselftest.h
has been removed from the -mm tree.  Its filename was
     selftests-complete-kselftest-include-centralization-fix.patch

This patch was dropped because it was folded into selftests-complete-kselftest-include-centralization.patch

------------------------------------------------------
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Subject: samples/vfs: add selftests include path for kselftest.h
Date: Fri, 17 Oct 2025 14:32:01 +0530

The test-list-all-mounts sample includes pidfd.h from selftests, which now
uses the centralized kselftest.h include after the previous change.  Add
the selftests directory to the include path so the build can find
kselftest.h

This fixes a build error reported by the kernel test robot.

Link: https://lkml.kernel.org/r/20251017090201.317521-1-reddybalavignesh9979@gmail.com
Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510171513.6IWk005g-lkp@intel.com/
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lkml.kernel.org/r/aPJD4ANRWUDVDqKc@sirena.org.uk
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/vfs/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/samples/vfs/Makefile~selftests-complete-kselftest-include-centralization-fix
+++ a/samples/vfs/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 userprogs-always-y += test-fsmount test-statx mountinfo test-list-all-mounts
 
+userccflags += -I $(srctree)/tools/testing/selftests/
 userccflags += -I usr/include
_

Patches currently in -mm which might be from reddybalavignesh9979@gmail.com are

selftests-complete-kselftest-include-centralization.patch

