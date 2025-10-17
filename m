Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F452D46C0
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760737416; cv=none; b=izaoHajOcMOijCpmrOgqNoQUPMH5v8OAG0/gJIg8hNAIePg0ieZbCAIJ8axJqL4SemipDimRqupYcE9xBOjHbhpMjLVaC+Pq437dWouowbANTaGCpNzFDSJMVFTSvCAI0eEr9gPGuzfDaNETpiUbo1Tpu4Z2yPn1V3VStpYF81Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760737416; c=relaxed/simple;
	bh=ELjHRRf7KxW78ZKs49Uh4ZZEJF8e6N+R1VwLTOjENXA=;
	h=Date:To:From:Subject:Message-Id; b=Jwx5eOnZktFw5q4MLDS5vmfbHbc94VFIemg4msxOTcMmvjRDbCe6wQV70LgN0VmTJmup8aHm1BeWXWy2VnGhznXoepxxq5X/b+HJ6TW5GwbSvIEmIRx68WqtaTYH+l08SsOP/mhWcaigWxzjffYTLTvOy9FHalNMjPUY25hyvmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1dXSuZcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1dXSuZcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA19C4CEE7;
	Fri, 17 Oct 2025 21:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760737415;
	bh=ELjHRRf7KxW78ZKs49Uh4ZZEJF8e6N+R1VwLTOjENXA=;
	h=Date:To:From:Subject:From;
	b=1dXSuZcJJxUkbj8gevWMdMjywB3QmqaDcOMGVWipI9FyWbvWhQuTCFMhjQbU/6P3T
	 l9kAkWVLsS7C2XdCpfo5dJn8GCAJJcst8k87LkkmeD+sirlTakHwkMxQBIpiPWAs+W
	 ly8VZHC75u9iN0c4GoYU8xWvE3VJKMVvwxJbvhl0=
Date: Fri, 17 Oct 2025 14:43:34 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,broonie@kernel.org,reddybalavignesh9979@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-complete-kselftest-include-centralization-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251017214335.AAA19C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/vfs: add selftests include path for kselftest.h
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
selftests-complete-kselftest-include-centralization-fix.patch

