Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F10BA38
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628520; cv=none; b=N0ql/UCx+/eoOsEPQfhRNw03dvFthkQVvXW6FJopCg3UchaTVE16bh9ySnIG7TMaxbeL6Fe3mMr4LlBnFieK9c8T17RJ2LyBEkSM07UmEDLo6Vm2PyZP/GhVWM8Lb49hEco0non6+RSkRq8BkjfYm56E95T4iXC7h3WolIsOAkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628520; c=relaxed/simple;
	bh=LHwW8HWemEILIo10BdD34jXLt0VEo9LA3+tjdLa5ByY=;
	h=Date:To:From:Subject:Message-Id; b=V3FMAZs2LgdTZ1kO0D2xeKDsuxFHVgQ2YSoQlISAskWwuChdaqXr5querDJTu24N3BtKJI4b80pntzLoFsL38urzOX/ZXW5IFl19i8A9AXCHn07uMxDqJRb0NWbdm98+nZNT0Df7wk9VK5+wa+rRzK2Rom39wKcvNEngMkA6jgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6Y3eXXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6Y3eXXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC7AC2BD11;
	Wed,  5 Jun 2024 23:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628520;
	bh=LHwW8HWemEILIo10BdD34jXLt0VEo9LA3+tjdLa5ByY=;
	h=Date:To:From:Subject:From;
	b=d6Y3eXXsY4A4xykZ6OwfVzG/f2gnrdWrYdF4AVPJqi/cqjB4OMxmJ0oUqkaL5WHOL
	 OXS+GD6+Cx4sJirOBp7oMbGKo0zsvJqRPB4rTgUQreFY21MRWojx4/aW8yIfoHgW5e
	 R2Nkv+pnLukSbJBOy7JE2jiiCoVJlKm15Haw8CR8=
Date: Wed, 05 Jun 2024 16:01:59 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-add-missing-module_description-macros-for-lib-_testko.patch added to mm-nonmm-unstable branch
Message-Id: <20240605230200.2DC7AC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KUnit: add missing MODULE_DESCRIPTION() macros for lib/*_test.ko
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-add-missing-module_description-macros-for-lib-_testko.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-add-missing-module_description-macros-for-lib-_testko.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: KUnit: add missing MODULE_DESCRIPTION() macros for lib/*_test.ko
Date: Sat, 1 Jun 2024 16:33:23 -0700

make allmodconfig && make W=1 C=1 reports for lib/*_test.ko:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/atomic64_test.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/hashtable_test.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-lib-test2-v1-1-be764b785f17@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/atomic64_test.c  |    1 +
 lib/hashtable_test.c |    1 +
 2 files changed, 2 insertions(+)

--- a/lib/atomic64_test.c~kunit-add-missing-module_description-macros-for-lib-_testko
+++ a/lib/atomic64_test.c
@@ -273,4 +273,5 @@ static __exit void test_atomics_exit(voi
 module_init(test_atomics_init);
 module_exit(test_atomics_exit);
 
+MODULE_DESCRIPTION("Testsuite for atomic64_t functions");
 MODULE_LICENSE("GPL");
--- a/lib/hashtable_test.c~kunit-add-missing-module_description-macros-for-lib-_testko
+++ a/lib/hashtable_test.c
@@ -314,4 +314,5 @@ static struct kunit_suite hashtable_test
 
 kunit_test_suites(&hashtable_test_module);
 
+MODULE_DESCRIPTION("KUnit test for the Kernel Hashtable structures");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch

