From: akpm@linux-foundation.org
Subject: + gcov-add-arm64-to-gcov_profile_all.patch added to -mm tree
Date: Tue, 14 Oct 2014 14:38:26 -0700
Message-ID: <543d97d2.sae3pbhrLzH/HW7q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaJNVi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 17:38:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riku.voipio@linaro.org, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: add ARM64 to GCOV_PROFILE_ALL
has been added to the -mm tree.  Its filename is
     gcov-add-arm64-to-gcov_profile_all.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-add-arm64-to-gcov_profile_all.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-add-arm64-to-gcov_profile_all.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Riku Voipio <riku.voipio@linaro.org>
Subject: gcov: add ARM64 to GCOV_PROFILE_ALL

Following up the arm testing of gcov, turns out gcov on ARM64 works fine
as well.  Only change needed is adding ARM64 to Kconfig depends.

Tested with qemu and mach-virt

Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/gcov/Kconfig~gcov-add-arm64-to-gcov_profile_all kernel/gcov/Kconfig
--- a/kernel/gcov/Kconfig~gcov-add-arm64-to-gcov_profile_all
+++ a/kernel/gcov/Kconfig
@@ -35,7 +35,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM
+	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM || ARM64
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
_

Patches currently in -mm which might be from riku.voipio@linaro.org are

origin.patch
gcov-add-arm64-to-gcov_profile_all.patch

