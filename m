Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3B81B81CA
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992754; cv=none; b=OcQMIHNnbHmmOxlOkev34ODBGBQ90on9xULMS7NSns4qQpXR1dx2Z5JR9CJJNBv4gAoSByRg/ABypIGMrFfv4mQmrmB8hB1GtR2tZVFQN6kNDqScA0GLeLiUY/0eZiPmh5NwqMm1nVWcCHlk8sk1PyHCeJDmBIcahrB5kXpZH60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992754; c=relaxed/simple;
	bh=RS0nw4kUcgVT0j8LHMyZJ8iUP15tgUmhlmLbgYSoUrY=;
	h=Date:To:From:Subject:Message-Id; b=CDxxg57VxLhkK7GcKDZ981f2NRSTKBHDCaddI9tm92JxgB9zZRW+wRvoymeDyAmOD1tpza7tjpGZLOzwUZpSBcGQc/XGW8mlvhRa4jacFPLIl+KkKMlOsdljkbAIikTLgkL666jHcWF8jc7PbY8jsU9ha+N7DtmJYOj5U1h0fEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rCIMbCIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rCIMbCIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FD4C4CEF5;
	Wed, 17 Dec 2025 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765992754;
	bh=RS0nw4kUcgVT0j8LHMyZJ8iUP15tgUmhlmLbgYSoUrY=;
	h=Date:To:From:Subject:From;
	b=rCIMbCIAVMgUlDct0IcmsCy/LMaxqQTTS2tXVcJSN8SCs4bc/1jBExAc2UeWvK1VI
	 srPzXbnRZ/yRL7mfD+jemA6nt5My5NfxD8L1qZEv3rHexQOJMRJ0w85oGRAAYFLhIC
	 7Upl0Rh6/jqwMXn85acJKHfk7nv2BDsos1ytiWtk=
Date: Wed, 17 Dec 2025 09:32:33 -0800
To: mm-commits@vger.kernel.org,ritesh.list@gmail.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch added to mm-new branch
Message-Id: <20251217173234.20FD4C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix-fix
Date: Wed, 17 Dec 2025 16:38:12 +0000

move MODULE_IMPORT_NS(), add comment

Link: https://lkml.kernel.org/r/20251217163812.2633648-2-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/tests/lazy_mmu_mode_kunit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/tests/lazy_mmu_mode_kunit.c~mm-add-basic-tests-for-lazy_mmu-fix-fix-fix
+++ a/mm/tests/lazy_mmu_mode_kunit.c
@@ -2,6 +2,9 @@
 #include <kunit/test.h>
 #include <linux/pgtable.h>
 
+/* For some symbols referenced by arch_{enter,leave}_lazy_mmu_mode on powerpc */
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
 static void expect_not_active(struct kunit *test)
 {
 	KUNIT_EXPECT_FALSE(test, is_lazy_mmu_mode_active());
@@ -69,4 +72,3 @@ kunit_test_suite(lazy_mmu_mode_test_suit
 
 MODULE_DESCRIPTION("Tests for the lazy MMU mode");
 MODULE_LICENSE("GPL");
-MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch
mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch

