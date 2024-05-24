Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6E73EA64;
	Fri, 24 May 2024 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576696; cv=none; b=caSejmjxA3xz5Cc601vTEBndPEGnKYuBnmWQSM0CBjjpYIuFHf4CR9f2A9Ix1+H9gqASeEKKXFVD8vJ/sHod8bQgyEzKNPBI0m6S9wraXXOTxAbV+Z1/Fasr9/8XwlB9BWWqgo5wfpdS/DfQ7GJ0dz0t6KixL2eKjs5IyWQ5yQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576696; c=relaxed/simple;
	bh=LMF9gkUgHj1akckbBYnGykASAD6kVjbsT7sG7bX3nE4=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=NEmO1H0e02fgPOFkKNh6EKmyRcSYhPAHdUf0eOft22BDgBfFltXKZ6XffdaKp9V2oNjBrABmwG3B8IJ/U68J26BndPXxh1nIQn8BwJtu4DT9AGRNgQHuGMFtMI7Fcj8IfmHfpEcmZDwTHdWXdTLI38+H3KKF9oLkLv7uS27+E00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v0ZDJDFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v0ZDJDFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3290DC2BBFC;
	Fri, 24 May 2024 18:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576696;
	bh=LMF9gkUgHj1akckbBYnGykASAD6kVjbsT7sG7bX3nE4=;
	h=Date:From:To:Cc:Subject:From;
	b=v0ZDJDFokhg5Y1Da+53pmWUPHBl53thb8uo3wp/9W0jDlrEVTjKZXPE7rd09wJtDX
	 gfL6iuCIZfbefowsxPyeH7MUZgah0zVaOauf9dCnx17BWKrhw8Is5cZeBTMluz3Ttz
	 x9NL+f5tIhQUIs5Esa1VdtWmms4iIuoerSE+9gL8=
Date: Fri, 24 May 2024 11:51:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] final MM update for 6.10-rc1
Message-Id: <20240524115135.3b6fd971bdb3e538e1873632@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge Jeff's mseal() syscall patchset, thanks.


The following changes since commit c760b3725e52403dc1b28644fb09c47a83cacea6:

  Merge tag 'mm-nonmm-stable-2024-05-22-17-30' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2024-05-22 18:59:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-05-24-11-49

for you to fetch changes up to a52b4f11a2e17109c4b9f7df4ff19215b1752efc:

  selftest mm/mseal read-only elf memory segment (2024-05-23 19:40:27 -0700)

----------------------------------------------------------------
Jeff Xu's implementation of the mseal() syscall.

----------------------------------------------------------------
Jeff Xu (5):
      mseal: wire up mseal syscall
      mseal: add mseal syscall
      selftest mm/mseal memory sealing
      mseal: add documentation
      selftest mm/mseal read-only elf memory segment

 Documentation/userspace-api/index.rst       |    1 +
 Documentation/userspace-api/mseal.rst       |  199 +++
 arch/alpha/kernel/syscalls/syscall.tbl      |    1 +
 arch/arm/tools/syscall.tbl                  |    1 +
 arch/arm64/include/asm/unistd.h             |    2 +-
 arch/arm64/include/asm/unistd32.h           |    2 +
 arch/m68k/kernel/syscalls/syscall.tbl       |    1 +
 arch/microblaze/kernel/syscalls/syscall.tbl |    1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    1 +
 arch/parisc/kernel/syscalls/syscall.tbl     |    1 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |    1 +
 arch/s390/kernel/syscalls/syscall.tbl       |    1 +
 arch/sh/kernel/syscalls/syscall.tbl         |    1 +
 arch/sparc/kernel/syscalls/syscall.tbl      |    1 +
 arch/x86/entry/syscalls/syscall_32.tbl      |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl      |    1 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |    1 +
 include/linux/syscalls.h                    |    1 +
 include/uapi/asm-generic/unistd.h           |    5 +-
 kernel/sys_ni.c                             |    1 +
 mm/Makefile                                 |    4 +
 mm/internal.h                               |   37 +
 mm/madvise.c                                |   12 +
 mm/mmap.c                                   |   31 +-
 mm/mprotect.c                               |   10 +
 mm/mremap.c                                 |   31 +
 mm/mseal.c                                  |  307 +++++
 tools/testing/selftests/mm/.gitignore       |    2 +
 tools/testing/selftests/mm/Makefile         |    2 +
 tools/testing/selftests/mm/mseal_test.c     | 1894 +++++++++++++++++++++++++++
 tools/testing/selftests/mm/seal_elf.c       |  179 +++
 33 files changed, 2732 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/userspace-api/mseal.rst
 create mode 100644 mm/mseal.c
 create mode 100644 tools/testing/selftests/mm/mseal_test.c
 create mode 100644 tools/testing/selftests/mm/seal_elf.c

