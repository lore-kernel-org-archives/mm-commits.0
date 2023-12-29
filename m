Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ED513FE6
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0+8+36ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D93C433C8;
	Fri, 29 Dec 2023 20:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880063;
	bh=Ulfzr/PmGt4YrtPyA9C9IMRCrqcsF7yCRGSrMfYEMg4=;
	h=Date:To:From:Subject:From;
	b=0+8+36qliGZAmPRyUsbHpi1SmlAfmRCLa74HTVm2bpQ7GZrAM1UUBorq8mOrCQklP
	 04wYubUfuoJ0Q/exTabbJUiweg9ed+s905ISfUpma0I17CkyCc6RwZNVun2uCRBr8x
	 36+iaHiDCQ/INFwKscYiMX1Or8fzAjkilaJ47hHw=
Date: Fri, 29 Dec 2023 12:01:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songliubraving@fb.com,shy828301@gmail.com,linmiaohe@huawei.com,maskray@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-vm_exec-requirement-for-thp-eligibility.patch removed from -mm tree
Message-Id: <20231229200103.35D93C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove VM_EXEC requirement for THP eligibility
has been removed from the -mm tree.  Its filename was
     mm-remove-vm_exec-requirement-for-thp-eligibility.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Matthew Wilcox <willy@infradead.org>
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


