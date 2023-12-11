Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E339C7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yl9kghWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA0AC433CA;
	Mon, 11 Dec 2023 01:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257794;
	bh=mB9kUNh9hm8n3AsStKymf+TxIhQBkUR5oV9eJ8Fz+Q0=;
	h=Date:To:From:Subject:From;
	b=Yl9kghWiMUfFM+z6KVZ1DpBkeIWCkdRwk5qEWzJaWcxazBB39tbfmtRYutXjlteB2
	 aweq/mHUsPr1FVadH9Yg9yI3RlQhG4VRaU8F6tz9Bz/Tt5+P9m9lKawNfioFaLGxBX
	 KnCLCapTwf439g4ErkNRwdwcJKGiQMsx3Q2xqLaA=
Date: Sun, 10 Dec 2023 17:23:14 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-vm_fault-mark-do_page_fault-as-static.patch removed from -mm tree
Message-Id: <20231211012314.ADA0AC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: vm_fault: mark do_page_fault() as static
has been removed from the -mm tree.  Its filename was
     hexagon-vm_fault-mark-do_page_fault-as-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: vm_fault: mark do_page_fault() as static
Date: Thu, 30 Nov 2023 15:58:18 -0700

Clang warns:

  arch/hexagon/mm/vm_fault.c:36:6: warning: no previous prototype for function 'do_page_fault' [-Wmissing-prototypes]
     36 | void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
        |      ^
  arch/hexagon/mm/vm_fault.c:36:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     36 | void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
        | ^
        | static

This function is not used outside of this translation unit, so mark it
as static.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-5-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/vm_fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/hexagon/mm/vm_fault.c~hexagon-vm_fault-mark-do_page_fault-as-static
+++ a/arch/hexagon/mm/vm_fault.c
@@ -33,7 +33,7 @@
 /*
  * Canonical page fault handler
  */
-void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
+static void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

