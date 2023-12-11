Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A667E7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n9E2kzdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE70C433C8;
	Mon, 11 Dec 2023 01:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257807;
	bh=FjA+7Po//T9QuUPlDTq51MZDFEQucZX4xB6g6vXWdbk=;
	h=Date:To:From:Subject:From;
	b=n9E2kzdBMemWmhgvMKpuUHEfGi/ZSZOF8mos4jgIgAaXnTSOVtZ5KG21TvoP9ubyM
	 XC8TM+oB4OoWh9jbTWT61p9kRXK4+ZJM/A+CH2+57wETpVJWsf1obdqxyvrG/SJK8s
	 akKesenpALTKhNBxTBAyiRwJgi4e/WUgZlf7WRDg=
Date: Sun, 10 Dec 2023 17:23:26 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-traps-remove-sys_syscall.patch removed from -mm tree
Message-Id: <20231211012327.6FE70C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: traps: remove sys_syscall()
has been removed from the -mm tree.  Its filename was
     hexagon-traps-remove-sys_syscall.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: traps: remove sys_syscall()
Date: Thu, 30 Nov 2023 15:58:31 -0700

Clang warns:

  arch/hexagon/kernel/traps.c:335:6: warning: no previous prototype for function 'sys_syscall' [-Wmissing-prototypes]
    335 | long sys_syscall(void)
        |      ^
  arch/hexagon/kernel/traps.c:335:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    335 | long sys_syscall(void)
        | ^
        | static

This function is not used anywhere, so remove it.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-18-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/traps.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/hexagon/kernel/traps.c~hexagon-traps-remove-sys_syscall
+++ a/arch/hexagon/kernel/traps.c
@@ -331,13 +331,6 @@ void do_genex(struct pt_regs *regs)
 	}
 }
 
-/* Indirect system call dispatch */
-long sys_syscall(void)
-{
-	printk(KERN_ERR "sys_syscall invoked!\n");
-	return -ENOSYS;
-}
-
 void do_trap0(struct pt_regs *regs)
 {
 	syscall_fn syscall;
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

