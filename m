Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D60136A;
	Thu, 23 May 2024 00:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716424555; cv=none; b=b30xm9Pw3JFlr2dvDDc7aUKc8NeTWGJy7Dod1iO800W2c1coWTy2FqB6pSGIHhMWJ/OlGv1HWPF4qdaNB7Ws84pTxkS77E8FlhE0oL2opDvCpsmtguCQKAHEQaOlwacnh7dskQ+Jf7qKRvRjc31vvT/DLELJ6D7AQdMOgAK95SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716424555; c=relaxed/simple;
	bh=ih8b/3CZbqHdZl1ThjvjQRZ7k9GtmJhAAEw7BB3WLwU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=czRg0oYx/8HU/ZOSZlFLPC3iZoBCTsdMXljAg2eyv3CubID8AsK6qhoPB9XoAeapZqiEsIrlpDghbu2H6kF5ElvTX7Vcc+U1nnWcbUuoAWI0eWNhIKrOnqp71mglTa0KESXKGSridj0nj8enCQ+RHsYp1KO8UBCtf7eLBu8uNr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hmpxBOTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hmpxBOTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39002C2BBFC;
	Thu, 23 May 2024 00:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716424554;
	bh=ih8b/3CZbqHdZl1ThjvjQRZ7k9GtmJhAAEw7BB3WLwU=;
	h=Date:From:To:Cc:Subject:From;
	b=hmpxBOTZSHiv4C92i/Uiz7mKoF+uVwhGePMPjg6NPi62AG2VQXLwnFQRr+dGiETsQ
	 oGu/cvzqhwiprdygmn8YH8vJO2YWVc8QeAGrcHR0cn4ibYUZbGIG0oEKnuI1zaYC4c
	 O6jdOe0CCzWMDKUufJhwZ94Y11jxHsRmgmnYPxLs=
Date: Wed, 22 May 2024 17:35:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional non-MM updates for 6.10-rc1
Message-Id: <20240522173553.4653fabdd1f4d9825f38e0ae@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of updates for other-than-MM subsystems.

These things missed the first round of updates as I was awaiting
clarification of readiness and of the consequences of the additional
warnings Arnd is enabling.

Thanks.


The following changes since commit eb6a9339efeb6f3d2b5c86fdf2382cdc293eca2c:

  Merge tag 'mm-nonmm-stable-2024-05-19-11-56' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2024-05-19 14:02:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-05-22-17-30

for you to fetch changes up to db3e24a02e29b507c24c0adb4d22914c65dab763:

  nilfs2: make block erasure safe in nilfs_finish_roll_forward() (2024-05-19 14:36:21 -0700)

----------------------------------------------------------------
- A series ("kbuild: enable more warnings by default") from Arnd
  Bergmann which enables a number of additional build-time warnings.  We
  fixed all the fallout which we could find, there may still be a few
  stragglers.

- Samuel Holland has developed the series "Unified cross-architecture
  kernel-mode FPU API".  This does a lot of consolidation of
  per-architecture kernel-mode FPU usage and enables the use of newer AMD
  GPUs on RISC-V.

- Tao Su has fixed some selftests build warnings in the series
  "Selftests: Fix compilation warnings due to missing _GNU_SOURCE
  definition".

- This pull also includes a nilfs2 fixup from Ryusuke Konishi.

----------------------------------------------------------------
Arnd Bergmann (5):
      kbuild: turn on -Wextra by default
      kbuild: remove redundant extra warning flags
      kbuild: turn on -Wrestrict by default
      kbuild: enable -Wformat-truncation on clang
      kbuild: enable -Wcast-function-type-strict unconditionally

Michael Ellerman (1):
      drm/amd/display: only use hard-float, not altivec on powerpc

Ryusuke Konishi (1):
      nilfs2: make block erasure safe in nilfs_finish_roll_forward()

Samuel Holland (14):
      x86/fpu: fix asm/fpu/types.h include guard
      arch: add ARCH_HAS_KERNEL_FPU_SUPPORT
      ARM: implement ARCH_HAS_KERNEL_FPU_SUPPORT
      ARM: crypto: use CC_FLAGS_FPU for NEON CFLAGS
      arm64: implement ARCH_HAS_KERNEL_FPU_SUPPORT
      arm64: crypto: use CC_FLAGS_FPU for NEON CFLAGS
      lib/raid6: use CC_FLAGS_FPU for NEON CFLAGS
      LoongArch: implement ARCH_HAS_KERNEL_FPU_SUPPORT
      powerpc: implement ARCH_HAS_KERNEL_FPU_SUPPORT
      x86: implement ARCH_HAS_KERNEL_FPU_SUPPORT
      riscv: add support for kernel-mode FPU
      drm/amd/display: use ARCH_HAS_KERNEL_FPU_SUPPORT
      selftests/fpu: move FP code to a separate translation unit
      selftests/fpu: allow building on other architectures

Tao Su (2):
      Revert "selftests/harness: remove use of LINE_MAX"
      selftests/harness: use 1024 in place of LINE_MAX

 Documentation/core-api/floating-point.rst      | 78 ++++++++++++++++++++++++++
 Documentation/core-api/index.rst               |  1 +
 Makefile                                       |  5 ++
 arch/Kconfig                                   |  6 ++
 arch/arm/Makefile                              |  7 +++
 arch/arm/include/asm/fpu.h                     | 15 +++++
 arch/arm/lib/Makefile                          |  3 +-
 arch/arm64/Kconfig                             |  1 +
 arch/arm64/Makefile                            |  9 ++-
 arch/arm64/include/asm/fpu.h                   | 15 +++++
 arch/arm64/lib/Makefile                        |  6 +-
 arch/loongarch/Kconfig                         |  1 +
 arch/loongarch/Makefile                        |  5 +-
 arch/loongarch/include/asm/fpu.h               |  1 +
 arch/powerpc/Kconfig                           |  1 +
 arch/powerpc/Makefile                          |  5 +-
 arch/powerpc/include/asm/fpu.h                 | 28 +++++++++
 arch/riscv/Kconfig                             |  1 +
 arch/riscv/Makefile                            |  3 +
 arch/riscv/include/asm/fpu.h                   | 16 ++++++
 arch/riscv/kernel/Makefile                     |  1 +
 arch/riscv/kernel/kernel_mode_fpu.c            | 28 +++++++++
 arch/x86/Kconfig                               |  1 +
 arch/x86/Makefile                              | 20 +++++++
 arch/x86/include/asm/fpu.h                     | 13 +++++
 arch/x86/include/asm/fpu/types.h               |  6 +-
 drivers/gpu/drm/amd/display/Kconfig            |  2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c | 35 +-----------
 drivers/gpu/drm/amd/display/dc/dml/Makefile    | 36 +-----------
 drivers/gpu/drm/amd/display/dc/dml2/Makefile   | 36 +-----------
 fs/nilfs2/recovery.c                           |  4 ++
 include/linux/fpu.h                            | 12 ++++
 lib/Kconfig.debug                              |  2 +-
 lib/Makefile                                   | 26 +--------
 lib/raid6/Makefile                             | 33 ++++-------
 lib/test_fpu.h                                 |  8 +++
 lib/{test_fpu.c => test_fpu_glue.c}            | 37 ++----------
 lib/test_fpu_impl.c                            | 37 ++++++++++++
 scripts/Makefile.extrawarn                     | 29 ++++------
 tools/testing/selftests/kselftest_harness.h    | 11 +---
 tools/testing/selftests/mm/mdwe_test.c         |  1 -
 41 files changed, 365 insertions(+), 220 deletions(-)
 create mode 100644 Documentation/core-api/floating-point.rst
 create mode 100644 arch/arm/include/asm/fpu.h
 create mode 100644 arch/arm64/include/asm/fpu.h
 create mode 100644 arch/powerpc/include/asm/fpu.h
 create mode 100644 arch/riscv/include/asm/fpu.h
 create mode 100644 arch/riscv/kernel/kernel_mode_fpu.c
 create mode 100644 arch/x86/include/asm/fpu.h
 create mode 100644 include/linux/fpu.h
 create mode 100644 lib/test_fpu.h
 rename lib/{test_fpu.c => test_fpu_glue.c} (71%)
 create mode 100644 lib/test_fpu_impl.c

