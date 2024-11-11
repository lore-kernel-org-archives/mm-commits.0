Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CA113E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313716; cv=none; b=jlAcPKW4wJqdLs4h86SLzJAo10fq4QPluzPWOXJR87AoVpXhmStqBHTcOYbP4e2TJZjZFIls2IfO4PkXgcthlNXB53SjZfM8fHgrfnBS4npMtsbSMkuxNxlt/7XKAXgRiJoHQdUpdQlvfNlFdmTCN8Eo9LVh45O+KeEoO8F9AlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313716; c=relaxed/simple;
	bh=jd6vljtORP2SbroJTxVrNMikb1/rple02NTTa19K9gQ=;
	h=Date:To:From:Subject:Message-Id; b=Nss58vnD2jn240eyX1qZxYjXWMmtC0iHVYAmM7hoz52nat8MgMtL9+NPAoL+/TAWzYa9uGbwBQHJ5wxEZBMnGpqBPsuLa9VVuhhn/EqyYiOmfVwAFblTIJHeZIVmp5a9um1LH8IQSJCare3CmpvB4Oq0vG3+eSBEcv4XKjh89Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TQtUlYxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TQtUlYxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E164C4CED0;
	Mon, 11 Nov 2024 08:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313716;
	bh=jd6vljtORP2SbroJTxVrNMikb1/rple02NTTa19K9gQ=;
	h=Date:To:From:Subject:From;
	b=TQtUlYxMiYEXP8vp2tx/Ddda8alrkA8fqVGLPhzoR1PtKhsVfWDLs9Tly44nndkGr
	 taWeYHc3t+4iMYlQ7JwIcP6yW6kZ8NaRfQx8Jzsu9AjZX3mBlUYck2+dnkZl7l9lKY
	 1pILAFunjJF7FThQpnchBbTX4F9hS1r+yHuLp7uo=
Date: Mon, 11 Nov 2024 00:28:35 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,paul.walmsley@sifive.com,palmer@rivosinc.com,charlie@rivosinc.com,alex@ghiti.fr,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-virtual_address_range-tests-on-riscv.patch removed from -mm tree
Message-Id: <20241111082836.7E164C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip virtual_address_range tests on riscv
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-virtual_address_range-tests-on-riscv.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


