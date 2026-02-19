Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3783B7A8;
	Thu, 19 Feb 2026 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473630; cv=none; b=fUBoC0Wcr52D9gp1z0/32usl+Wq89lmACU4lN8szcTtbHsq3iO8V61ey9DU22GaIiVug5IK+NVJIxbjtnFis2mtZLVSaQ6UEMvDgmk9mPqMtt87WXHZVCWx2BbnXRowWPN47BVw+gCVGFX9fgfRIWbBVb/0MlYQIVW9ENoUrfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473630; c=relaxed/simple;
	bh=NVmzFnWHsP7QdLgTyaoYyFR24TYNfXKtePeyAnEAO88=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=E03dZfv7DpmBNkN98LM7KyAS8Zs3z4Fss8JFSVfghANiQ6/WOi8uEyxlG0U+WgS7GkDwsqzCkP8UqMac4ibMgFWiX+AIWKWNDuuxZ8HQIN+VKrRXN+xqtUVJa7uNWeYomVApI5X3h2QYx6VTvHasSsGQszPesI+hGQJekn7Y7Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o0BLpi+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o0BLpi+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2058C116D0;
	Thu, 19 Feb 2026 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771473629;
	bh=NVmzFnWHsP7QdLgTyaoYyFR24TYNfXKtePeyAnEAO88=;
	h=Date:From:To:Cc:Subject:From;
	b=o0BLpi+Q3qTZWfh9/tg1dLo1MuIcjF+j/+1TPRxle/EMGZuMHxawU8x3GrnhZnSaL
	 35cn2SNDvXj+FMjKXzYoTIy58tWBcnalyouHqI6P2pLLwak8lD4Bsw7UZrGe/6h1sT
	 0ANSDpQEcpVH382TNPFzEOjhSVsYLaUcNgpvqpt8=
Date: Wed, 18 Feb 2026 20:00:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional non-MM updates for 7.0-rc1
Message-Id: <20260218200029.835bc4072e58269d27599e62@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this second and final batch of non-MM updates for
the 7.0-rcX cycle, thanks.



The following changes since commit 0dddf20b4fd4afd59767acc144ad4da60259f21f:

  watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency (2026-02-08 00:13:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-18-19-56

for you to fetch changes up to 90627a1e08e602b8b7bea970d7d5007626be7527:

  lib/group_cpus: handle const qualifier from clusters allocation type (2026-02-12 15:45:58 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-stable

Total patches:       7
Reviews/patch:       0.57
Reviewed rate:       42%

- The 2 patch series "two fixes in kho_populate()" from Ran Xiaokai
  fixes a couple of not-major issues in the kexec handover code.

----------------------------------------------------------------
Aristeu Rozanski (1):
      selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

Arnd Bergmann (1):
      delayacct: fix build regression on accounting tool

Kees Cook (1):
      lib/group_cpus: handle const qualifier from clusters allocation type

Ran Xiaokai (2):
      kho: fix missing early_memunmap() call in kho_populate()
      kho: remove unnecessary WARN_ON(err) in kho_populate()

Seongjun Hong (1):
      scripts/gdb: implement x86_page_ops in mm.py

zhouwenhao (1):
      objpool: fix the overestimation of object pooling metadata size

 kernel/liveupdate/kexec_handover.c         |  28 ++---
 lib/group_cpus.c                           |   2 +-
 lib/objpool.c                              |   2 +-
 scripts/gdb/linux/constants.py.in          |   2 +-
 scripts/gdb/linux/mm.py                    | 173 ++++++++++++++++++++++++++++-
 tools/accounting/getdelays.c               |  12 +-
 tools/testing/selftests/memfd/memfd_test.c | 113 +++++++++++++++++--
 7 files changed, 301 insertions(+), 31 deletions(-)

