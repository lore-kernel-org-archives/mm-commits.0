Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD1329F16
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 21:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757539869; cv=none; b=ITw1QZ5jD1UbotRBSQ9tRaZFGaNE0FY2F9G5DcFpkd6ytyrjZRuseec9nc2QBRQeF2iPJN5zMQAMM+iD0vbzT3jaCdq0orw/f16ZwY61gc+LkkMLn75TFo4nmEe8z03JOFsDqFvsBhLrCZf2l86AU/84AUTZ++TrytW5HHMslTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757539869; c=relaxed/simple;
	bh=2j+FWo3eP/9oVlJDzER5RFhzuFqDVQOkJPDs7CBHAPc=;
	h=Date:To:From:Subject:Message-Id; b=YbxXdRJZ/M71ViHCtsbNsMluoyRSCjszijhSlp9TqmxKUdH0olK8zcasVK63u1YATx83knWu4e3J1bBYRls0Jz1ol67NjMpph6SUj404LqQM4adWdw4zn0L5ZZcLcI3swrQmPXTozNEzhuInrv850NA+ygVTCSS7qMGhYrNJIUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2RJ24z2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2RJ24z2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CA1C4CEEB;
	Wed, 10 Sep 2025 21:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757539868;
	bh=2j+FWo3eP/9oVlJDzER5RFhzuFqDVQOkJPDs7CBHAPc=;
	h=Date:To:From:Subject:From;
	b=2RJ24z2DtuhXJ1M5PYMIed4yDx9pjVgkfNFESbsRIoBVnDXnIJtet6HunQa7i7e9L
	 ExNNPZgJK5z0nmMqWJXqjyszLftWYl7LhjBPrp6Rduw+iqKhIs6RPzP+1HcXLJmkJX
	 YeOvbiGOPpRrzXSN0zBJ8HjuhkVAmxpq1zfHRscY=
Date: Wed, 10 Sep 2025 14:31:07 -0700
To: mm-commits@vger.kernel.org,broonie@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-prctl-introduce-tests-for-disabling-thps-completely-fix-2.patch added to mm-unstable branch
Message-Id: <20250910213108.66CA1C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: include linux/mman.h for prctl_thp_disable
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-prctl-introduce-tests-for-disabling-thps-completely-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-prctl-introduce-tests-for-disabling-thps-completely-fix-2.patch

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
selftests-prctl-introduce-tests-for-disabling-thps-completely-fix.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely-fix-2.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch
mm-huge_memory-remove-enforce_sysfs-from-__thp_vma_allowable_orders.patch

