Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248EC3FE37
	for <mm-commits@vger.kernel.org>; Fri, 15 Dec 2023 19:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rzBq9YxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA2CC433C8;
	Fri, 15 Dec 2023 19:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702667619;
	bh=CEnhyqZivws0WfDjGzL79YKzNurLSeZDcc8rkCrRH3o=;
	h=Date:To:From:Subject:From;
	b=rzBq9YxTnuP3aq5gOXIT7orFitLm0k8iEmiCJzWG20jiXo2wGO5a9JRxNFTR4k6kQ
	 OzxNtqRBYGBlkoh8dsGIqUEc+sPL+I2Wm+x4REblgQAnzJbVYMFYSkTVwzTgPIQAtN
	 JxKbS+4t6fgKRFziYDUKkCkZ4/OMtoQGxz+4StmQ=
Date: Fri, 15 Dec 2023 11:13:38 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,wangjinchao@xfusion.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_core-remove-duplicated-including-of-kexech.patch added to mm-nonmm-unstable branch
Message-Id: <20231215191339.8DA2CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_core: remove duplicated including of kexec.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_core-remove-duplicated-including-of-kexech.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_core-remove-duplicated-including-of-kexech.patch

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
From: Wang Jinchao <wangjinchao@xfusion.com>
Subject: crash_core: remove duplicated including of kexec.h
Date: Fri, 15 Dec 2023 16:54:51 +0800

Remove second include of linux/kexec.h

Link: https://lkml.kernel.org/r/202312151654+0800-wangjinchao@xfusion.com
Signed-off-by: Wang Jinchao <wangjinchao@xfusion.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/crash_core.c~crash_core-remove-duplicated-including-of-kexech
+++ a/kernel/crash_core.c
@@ -13,7 +13,6 @@
 #include <linux/memory.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
-#include <linux/kexec.h>
 #include <linux/kmemleak.h>
 
 #include <asm/page.h>
_

Patches currently in -mm which might be from wangjinchao@xfusion.com are

crash_core-remove-duplicated-including-of-kexech.patch

