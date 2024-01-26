Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64C660EEA
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255674; cv=none; b=C9ozeJ2aevfyW8s/OpCzLEFAPOECC9eOq4vuta8ZllWnCnx35ZdKpTnzlORQeCpTRopNCL5JqH+iz0S7FYKQkTN5M1kKZsmu4uTjAnCXLt+SU6BU80qMJN/DemlMfadTtkhlQ7fJaIjW15rMfEF/j1eQpNG6TgJEimXhQVLd574=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255674; c=relaxed/simple;
	bh=/bxYPoi+YVTu/V0uMhazbl26lM20BAPJz4trGPB/AAU=;
	h=Date:To:From:Subject:Message-Id; b=djvVRDeg1cX7XeDyRyzdrZmApPo98Cg9uL7I18lBJjSckE2aLsy652uzbOqn7GtRFmn6kN0lCN2iZhA0ttXIrQb3GLzi7uNlu9ibVmZnZ95kAKfGxtie9h6AsxCC4Id25v9auCAgUj4yFK98q4/hXBGkg1hlJytIsT35/fJxr2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yuw6K1Og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yuw6K1Og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED417C433F1;
	Fri, 26 Jan 2024 07:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255673;
	bh=/bxYPoi+YVTu/V0uMhazbl26lM20BAPJz4trGPB/AAU=;
	h=Date:To:From:Subject:From;
	b=yuw6K1Og0+UWXvs0M7K/AbU9AGtRZh5ogZ5k94H8YX8+VJuGSOq7O8FPl07H9/84x
	 yCx6tL6LXeUFMin+XOrOL8qXavqMGy9QVHpwEURLNakCzCm1RfdSnlN+yHPTpWAb0T
	 mCz6Bp1k5ZQI+Zoqx2Yr+I0vKKPPPSHkpwjnnSw4=
Date: Thu, 25 Jan 2024 23:54:30 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-split-vmcoreinfo-exporting-code-out-from-crash_corec-fix.patch added to mm-unstable branch
Message-Id: <20240126075432.ED417C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: remove duplicated include in vmcore_info.c
has been added to the -mm mm-unstable branch.  Its filename is
     crash-split-vmcoreinfo-exporting-code-out-from-crash_corec-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-split-vmcoreinfo-exporting-code-out-from-crash_corec-fix.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: crash: remove duplicated include in vmcore_info.c
Date: Fri, 26 Jan 2024 08:57:44 +0800

The header files kexec.h is included twice in vmcore_info.c,
so one inclusion can be removed.

Link: https://lkml.kernel.org/r/20240126005744.16561-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/vmcore_info.c~crash-split-vmcoreinfo-exporting-code-out-from-crash_corec-fix
+++ a/kernel/vmcore_info.c
@@ -13,7 +13,6 @@
 #include <linux/memory.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
-#include <linux/kexec.h>
 #include <linux/kmemleak.h>
 
 #include <asm/page.h>
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

crash-split-vmcoreinfo-exporting-code-out-from-crash_corec-fix.patch

