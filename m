Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8247493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mGBJze2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7900C433C9;
	Mon, 11 Dec 2023 01:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257803;
	bh=WdKKAwV2p5rQ52KXnvS8N1UgAgCaRuRk0fH5CsxSYHE=;
	h=Date:To:From:Subject:From;
	b=mGBJze2mAFGZPvumlJ4WZspbrzbK7rkFTG1TuM2pGX8YKvdC4SXK4PJpPM6FyGyrs
	 3dakbuk6JObnbix0xnSxGLqyIV83PwxRxVCuPoXHC2evt57+WccugmNnEp+LwGv5zO
	 SLTTIqlt4wxP3tDz/BKoL2nJ1WOF3InsCcxmZmnc=
Date: Sun, 10 Dec 2023 17:23:23 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-process-add-internal-prototype-for-do_work_pending.patch removed from -mm tree
Message-Id: <20231211012323.A7900C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: process: add internal prototype for do_work_pending()
has been removed from the -mm tree.  Its filename was
     hexagon-process-add-internal-prototype-for-do_work_pending.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: process: add internal prototype for do_work_pending()
Date: Thu, 30 Nov 2023 15:58:27 -0700

Clang warns:

  arch/hexagon/kernel/process.c:155:5: warning: no previous prototype for function 'do_work_pending' [-Wmissing-prototypes]
    155 | int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
        |     ^
  arch/hexagon/kernel/process.c:155:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    155 | int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
        | ^
        | static

This function is only referenced from assembly, so it does not technically
need a prototype.  Add one right above the definition anyways to clear up
the warning.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-14-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/process.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/process.c~hexagon-process-add-internal-prototype-for-do_work_pending
+++ a/arch/hexagon/kernel/process.c
@@ -153,6 +153,7 @@ unsigned long __get_wchan(struct task_st
  * Returns 0 if there's no need to re-check for more work.
  */
 
+int do_work_pending(struct pt_regs *regs, u32 thread_info_flags);
 int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 {
 	if (!(thread_info_flags & _TIF_WORK_MASK)) {
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

