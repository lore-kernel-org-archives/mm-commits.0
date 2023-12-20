Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6963448782
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TIqF5Juk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC22C433C7;
	Wed, 20 Dec 2023 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703094300;
	bh=UU3R/7VU/ay4xvvTLhWiCJ08n1a/+geo470MTKadJVY=;
	h=Date:To:From:Subject:From;
	b=TIqF5Juk5q37WRNSW8bEmReeMmHyZv2dhcKrljch4jNtaBfMeUfKp4PElNYDBH+lL
	 s1F2ImJtiwKCWG3r+/E16xEf0kpB5v2vKWJhzIkGjZa+vMoxlss2tzcfqESyCg7J6P
	 p+pHq77ZbUe91LFE3Z8UJNMJou5DlsOSCSpVf9wc=
Date: Wed, 20 Dec 2023 09:45:00 -0800
To: mm-commits@vger.kernel.org,songliubraving@fb.com,shy828301@gmail.com,linmiaohe@huawei.com,maskray@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-vm_exec-requirement-for-thp-eligibility.patch added to mm-unstable branch
Message-Id: <20231220174500.CAC22C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove VM_EXEC requirement for THP eligibility
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-vm_exec-requirement-for-thp-eligibility.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-vm_exec-requirement-for-thp-eligibility.patch

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
From: Fangrui Song <maskray@google.com>
Subject: mm: remove VM_EXEC requirement for THP eligibility
Date: Tue, 19 Dec 2023 21:41:23 -0800

Commit e6be37b2e7bd ("mm/huge_memory.c: add missing read-only THP checking
in transparent_hugepage_enabled()") introduced the VM_EXEC requirement,
which is not strictly needed.

lld's default --rosegment option and GNU ld's -z separate-code option
(default on Linux/x86 since binutils 2.31) create a read-only PT_LOAD
segment without the PF_X flag, which should be eligible for THP.

Certain architectures support medium and large code models, where .lrodata
may be placed in a separate read-only PT_LOAD segment, which should be
eligible for THP as well.

Link: https://lkml.kernel.org/r/20231220054123.1266001-1-maskray@google.com
Signed-off-by: Fangrui Song <maskray@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-remove-vm_exec-requirement-for-thp-eligibility
+++ a/include/linux/huge_mm.h
@@ -206,7 +206,6 @@ static inline bool file_thp_enabled(stru
 	inode = vma->vm_file->f_inode;
 
 	return (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS)) &&
-	       (vma->vm_flags & VM_EXEC) &&
 	       !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
_

Patches currently in -mm which might be from maskray@google.com are

mm-remove-vm_exec-requirement-for-thp-eligibility.patch

