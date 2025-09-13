Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95482BE058
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801993; cv=none; b=WHOTPIZXiajDJFeCTMDzHhqLJmbIP/XPq2A34c38wJdkXyitKAkuv7M0CLQsKT1F5KgqSGu2dr7VM9zFPCnj0LyKEjzN7Nnt5fNqwzu67/cweBvjOSEHHRsEc7LpgBxKSaiQA9odTEVdKaLvh1szE5wbZvrquKqjU/pBvtocfIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801993; c=relaxed/simple;
	bh=QXX51k+u7knDtrGJozahIjPtHdl9i/0Zpc5ZCSUgrPc=;
	h=Date:To:From:Subject:Message-Id; b=JL169s6qrkmd2QERGWoWbJuQaIiCdojnwiKbTX7ADbGf6zesF9TYDPyGiY0IAxh54fYxfW/I4eDMQ0mOKF2y2TGR8SaAtZNlkaGQx2H1Zp844j10mSgP3Nauq070nsqRDCXmBzyg2TAZSP6EMzKiT3EBm9Ae6ob/8qgf78voTQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vvg3XRub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vvg3XRub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6200BC4CEEB;
	Sat, 13 Sep 2025 22:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801992;
	bh=QXX51k+u7knDtrGJozahIjPtHdl9i/0Zpc5ZCSUgrPc=;
	h=Date:To:From:Subject:From;
	b=Vvg3XRubDt5qm5kqFZ+Ct+jbeFosZJt9GhoXtf11xRD8lpZ7qw+ua9pURMIlbp1zn
	 tgt95qnBGFlYgaGKHWMnkvkKF/xjq7fhAZqf5MQI26pVn3HIxiwSwXyD15VehTNaMz
	 WUhBgb2WnVSMwf48JjlVvwQdLwjNca1+wxtUUtKU=
Date: Sat, 13 Sep 2025 15:19:51 -0700
To: mm-commits@vger.kernel.org,broonie@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-prctl-introduce-tests-for-disabling-thps-completely-fix-2.patch removed from -mm tree
Message-Id: <20250913221952.6200BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: include linux/mman.h for prctl_thp_disable
has been removed from the -mm tree.  Its filename was
     selftests-prctl-introduce-tests-for-disabling-thps-completely-fix-2.patch

This patch was dropped because it was folded into selftests-prctl-introduce-tests-for-disabling-thps-completely.patch

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: selftests/mm: include linux/mman.h for prctl_thp_disable
Date: Wed, 10 Sep 2025 21:46:09 +0100

MADV_COLLAPSE is part of linux/mman.h and needs to be included for this
selftest for glibc compatibility.  It is also included in other tests that
use MADV_COLLAPSE.

Link: https://lkml.kernel.org/r/20250910204609.1720498-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/prctl_thp_disable.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/prctl_thp_disable.c~selftests-prctl-introduce-tests-for-disabling-thps-completely-fix-2
+++ a/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <sys/prctl.h>
 #include <sys/wait.h>
 
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

docs-transhuge-document-process-level-thp-controls.patch
selftest-mm-extract-sz2ord-function-into-vm_utilh.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch
mm-huge_memory-remove-enforce_sysfs-from-__thp_vma_allowable_orders.patch

