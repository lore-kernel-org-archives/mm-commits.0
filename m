Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC830FC23
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 22:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771627564; cv=none; b=mIr8FemM+06Cgxt+vNEKR37+f/cPWap9JJobkOW01Mt6o0I8ef/gtbkdSowJC2yUYSq3547jni2bTj7eIxTOY2ONzPnVWdz4J+p6+39RQKB1/HXyYnUjU2GJ/YUDMNyzv2uHFiAtI6sltCTuS/bYb8Z8/NPuOJKCO+qISqleQ2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771627564; c=relaxed/simple;
	bh=8SHDvnJ9U3fx6VT1mhuqHYVsCbeAq5dDxm14OVn6ISc=;
	h=Date:To:From:Subject:Message-Id; b=ZJdIdXKLG8Jx8vxGo+PkWzQx8Y0SILowtCwey9RQwj0ue2RmF9Lx+PO2BcYdGM6VOR8SNE8hExmOcdP0xDmXmVArV+CDmxY8frvNBTe9VSQ4seymFZWXj9NwVTpwMqJP5rdguC6jIZPayZEzAVOEBeesW+dpyWNsQksayHIpsN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aSWluDH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aSWluDH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0581C116C6;
	Fri, 20 Feb 2026 22:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771627564;
	bh=8SHDvnJ9U3fx6VT1mhuqHYVsCbeAq5dDxm14OVn6ISc=;
	h=Date:To:From:Subject:From;
	b=aSWluDH2d76ceBq14wxrJXhsbchX3PLgs04xr1do7fxuLBL0D2SB5pAooHkLp+xhU
	 kKGtVqrLcdTT1qNdZW8ZrNFaTzJIgQDPE/YVLmnKBvGxM5gSP64mKo2DwZ8uCx4HWZ
	 YyWWrdYNihWtCzWlAnGv2ViaOBOXjWR6n4FijeAs=
Date: Fri, 20 Feb 2026 14:46:03 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,linmiaohe@huawei.com,Liam.Howlett@oracle.com,dev.jain@arm.com,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-duplicate-include-of-unistdh.patch added to mm-new branch
Message-Id: <20260220224603.F0581C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove duplicate include of unistd.h
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-duplicate-include-of-unistdh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-duplicate-include-of-unistdh.patch

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
From: Chen Ni <nichen@iscas.ac.cn>
Subject: selftests/mm: remove duplicate include of unistd.h
Date: Wed, 11 Feb 2026 14:43:11 +0800

Remove duplicate inclusion of unistd.h in memory-failure.c to clean up
redundant code.

Link: https://lkml.kernel.org/r/20260211064311.2981726-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memory-failure.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-remove-duplicate-include-of-unistdh
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -13,7 +13,6 @@
 #include <unistd.h>
 #include <signal.h>
 #include <setjmp.h>
-#include <unistd.h>
 #include <fcntl.h>
 #include <sys/vfs.h>
 #include <linux/magic.h>
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are

selftests-mm-remove-duplicate-include-of-unistdh.patch

