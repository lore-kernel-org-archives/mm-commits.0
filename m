Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A433C14
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 01:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730250413; cv=none; b=j5eMnIr4iMoglJinQteBOEn9Tr7N5++DdFHvOCYljqU/pyxjOTnfBv+lG3Fl5WugdIezN2j/bBumSFwNH/q9jk+tVZPnBRgb5AaK9J+Ug+4+8sudHval+3kFpTXL/O4Jg3KLT6u7v8kxWMyotz5UhMEXlrZq2ugogB1OQqD80qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730250413; c=relaxed/simple;
	bh=0zAvprir4CPuDt2YmM9fJv05kp5OoSEHLqxEpNg/GRc=;
	h=Date:To:From:Subject:Message-Id; b=Tn2yeIpfcC8xTG92A4D2opdThoCi3zTouXWhdWdV4Y+9ZE4NTGmhilJ/19ZTPD+mBLCNpbp4p0hDwaHW/VCCDx72Yr8DE+sU2xir0Z6Tg4mfK2H988uXibd7TBgRQGaF6D3UPfXFXrzuGowwvFoguke0eZ7fpDFCpzktxfVeL3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g/VV9EOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g/VV9EOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BF7C4CECD;
	Wed, 30 Oct 2024 01:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730250413;
	bh=0zAvprir4CPuDt2YmM9fJv05kp5OoSEHLqxEpNg/GRc=;
	h=Date:To:From:Subject:From;
	b=g/VV9EOnNSaRKRgqkNN4EzUw4wf/wur4RBysuCfgfZ51kX1U/xcrgROpX+nQGAxY8
	 pb3kVqElZby+dAg302+6Y9amdeTyCTCjAqg8YoEs/u66E/tf4/VZ5DvvJQcumy678y
	 BUfsa03tEmARFIDoim7d6pBtcwbtgjWobCP8XFeg=
Date: Tue, 29 Oct 2024 18:06:52 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,paul.walmsley@sifive.com,palmer@rivosinc.com,charlie@rivosinc.com,alex@ghiti.fr,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-virtual_address_range-tests-on-riscv.patch added to mm-unstable branch
Message-Id: <20241030010653.02BF7C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip virtual_address_range tests on riscv
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-virtual_address_range-tests-on-riscv.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-virtual_address_range-tests-on-riscv.patch

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
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: selftests/mm: skip virtual_address_range tests on riscv
Date: Tue, 8 Oct 2024 17:41:41 +0800

RISC-V doesn't currently have the behavior of restricting the virtual
address space which virtual_address_range tests check, this will
cause the tests fail. So lets disable the whole test suite for riscv64
for now, not build it and run_vmtests.sh will skip it if it is not present.

Link: https://lkml.kernel.org/r/20241008094141.549248-5-zhangchunyan@iscas.ac.cn
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile       |    2 ++
 tools/testing/selftests/mm/run_vmtests.sh |   10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-skip-virtual_address_range-tests-on-riscv
+++ a/tools/testing/selftests/mm/Makefile
@@ -116,7 +116,9 @@ endif
 
 ifneq (,$(filter $(ARCH),arm64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64 s390))
 TEST_GEN_FILES += va_high_addr_switch
+ifneq ($(ARCH),riscv64)
 TEST_GEN_FILES += virtual_address_range
+endif
 TEST_GEN_FILES += write_to_hugetlbfs
 endif
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-skip-virtual_address_range-tests-on-riscv
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -347,10 +347,12 @@ if [ $VADDR64 -ne 0 ]; then
 	# allows high virtual address allocation requests independent
 	# of platform's physical memory.
 
-	prev_policy=$(cat /proc/sys/vm/overcommit_memory)
-	echo 1 > /proc/sys/vm/overcommit_memory
-	CATEGORY="hugevm" run_test ./virtual_address_range
-	echo $prev_policy > /proc/sys/vm/overcommit_memory
+	if [ -x ./virtual_address_range ]; then
+		prev_policy=$(cat /proc/sys/vm/overcommit_memory)
+		echo 1 > /proc/sys/vm/overcommit_memory
+		CATEGORY="hugevm" run_test ./virtual_address_range
+		echo $prev_policy > /proc/sys/vm/overcommit_memory
+	fi
 
 	# va high address boundary switch test
 	ARCH_ARM64="arm64"
_

Patches currently in -mm which might be from zhangchunyan@iscas.ac.cn are

selftest-mm-fix-typo-in-virtual_address_range.patch
selftests-mm-skip-virtual_address_range-tests-on-riscv.patch

