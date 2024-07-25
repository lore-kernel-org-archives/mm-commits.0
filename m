Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1673101F2;
	Thu, 25 Jul 2024 21:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721943093; cv=none; b=a+1caLz5lhQic4w5nOZftOqCejE1FWNN+BLrFpoxUQAOfxXheEfzA+o13dojbrjwvMsB9Vp0ChQUhpzQDXwLdaoNVJfSypGwb6iXyHqkcLvO77AeYddDJqfBS5K40yWDUqzxGHn4wtHYca+Xi7NgSzVobsWFaQcaI2IGSbt5NS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721943093; c=relaxed/simple;
	bh=sXqORwKGPxn7Y8JGN1F1pGA5scS4nu5sRXzIhuIuWyo=;
	h=Date:To:From:Subject:Message-Id; b=sTvhk53WKeKDzcDsaVe0Qtk3vr9SQrzc6bZJBlzGqhui+PKlNlLB1PLs7xlWiK8iTa5j4z5AMEVN5w4gU8usZFmH8tvHuePsLEBoeHVF0G3nmiyw2BG/R03EB7N5Wgh4tGcsafFRNOOybS9vufgTkv8ts1d5/i2/zsLPIGw1tw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SbgUNn4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SbgUNn4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8351AC116B1;
	Thu, 25 Jul 2024 21:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721943091;
	bh=sXqORwKGPxn7Y8JGN1F1pGA5scS4nu5sRXzIhuIuWyo=;
	h=Date:To:From:Subject:From;
	b=SbgUNn4zb56v5a5gNh4tK8y74X6aQ2L2YdHePQosybEVE3OIYEt+ihvDdGyg4sdY+
	 Dizflrj6FGpErl1Ty5c760vkR5IB0YLbDe8RuBG7KTQlnPuuILdHYadvHVYbCiHtX5
	 FKvR7kgxUFh7uEZaMXaawrbT9FtW9tppMZzTW/E0=
Date: Thu, 25 Jul 2024 14:31:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,broonie@kernel.org,aou@eecs.berkeley.edu,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-s390-to-arch-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20240725213131.8351AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: add s390 to ARCH check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-add-s390-to-arch-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-s390-to-arch-check.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

selftests-mm-add-s390-to-arch-check.patch

