Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6798B33E1;
	Thu,  8 Aug 2024 01:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081324; cv=none; b=VYT0C6FIglKhJt6Y0zFKe36sVljHcpPCSTUYtceTG2w4CqJzKU13i94gcfUjVjHi2fpAiKLuqLszSOydvLvtvGZ5B2fY1hQJ+bjfVSMysZC0FCiPBFtbUO9e3QZDmyzQXzdHEqT3s6QTRimSXk7udkwegT0a5q7/QVvrv3yfU6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081324; c=relaxed/simple;
	bh=AlzzMu/R+8v9a5/h8+kCQiSDvZz8wmWIdddxp0jZLM0=;
	h=Date:To:From:Subject:Message-Id; b=eW9coB4OyxdeKuvlSJQprFMJC6ePiC3fet2BZ19F13UPi1z2ZAMdtyZ2TWBfpSC+dau4yYAlgtxRSlCbjplv+KD0jcgW1QfLTO7BhmRTmKJZptBFDtvAgHQSNcWN0GtijZkMUKJl4RsYYa2e2rlloiUPlz57pMCi0FuC0INHvVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQ9OYsQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQ9OYsQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C7AC32781;
	Thu,  8 Aug 2024 01:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723081323;
	bh=AlzzMu/R+8v9a5/h8+kCQiSDvZz8wmWIdddxp0jZLM0=;
	h=Date:To:From:Subject:From;
	b=WQ9OYsQQy02YzVi0l2QE5BJUPYGNWv2ExAmc9rE1FQbsJT2zGgjsEb9I49k5/eWcE
	 sKwdkz6Doe/HYkAfWhOTtuPgliNEwofdumSOy6xgnIIaM4ViaJ4E5vaU7JNcLmtDG+
	 Che2ZglLHWcl711Un/H5h7tYFT+kgVHYXItWr+sA=
Date: Wed, 07 Aug 2024 18:42:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,broonie@kernel.org,aou@eecs.berkeley.edu,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-add-s390-to-arch-check.patch removed from -mm tree
Message-Id: <20240808014203.C9C7AC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: add s390 to ARCH check
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-s390-to-arch-check.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: selftests: mm: add s390 to ARCH check
Date: Wed, 24 Jul 2024 15:35:17 -0600

commit 0518dbe97fe6 ("selftests/mm: fix cross compilation with LLVM")
changed the env variable for the architecture from MACHINE to ARCH.

This is preventing 3 required TEST_GEN_FILES from being included when
cross compiling s390x and errors when trying to run the test suite.  This
is due to the ARCH variable already being set and the arch folder name
being s390.

Add "s390" to the filtered list to cover this case and have the 3 files
included in the build.

Link: https://lkml.kernel.org/r/20240724213517.23918-1-npache@redhat.com
Fixes: 0518dbe97fe6 ("selftests/mm: fix cross compilation with LLVM")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-s390-to-arch-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -110,7 +110,7 @@ endif
 
 endif
 
-ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64))
+ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64 s390))
 TEST_GEN_FILES += va_high_addr_switch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs
_

Patches currently in -mm which might be from npache@redhat.com are


