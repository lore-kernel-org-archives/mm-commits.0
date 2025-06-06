Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC0533086
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 03:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749181863; cv=none; b=EhkeTO+IdcOo3Soxp1sIjV6Ty7A5qP7T5WADSs3SLRY1QhqeXD5JqBD1B4nCpGwZ6eGEFCGaOu1x9Pjii3/ZUB6AnTJfk+JAEhhX1szfBUVpxkwxR5wJy3UFoqMtkqBWG5Ap8T5LCPCQ20uhZIAGfPjU0L3T1CmN3LGDPxI3ulQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749181863; c=relaxed/simple;
	bh=z9+c/eIlguZsUpT5wT5zRL8mjcV+K6M5EUm2Gld00RM=;
	h=Date:To:From:Subject:Message-Id; b=qhuQ7av7Qs35g5ZiOD2wQlnWn+Cw9YqEt41Gkyzt7K72r0h68HoU8Lq3RjiXym9ip99qBt2rNxuyjMnHtt+x36yQHcw3K8RFB+PiLh2B1y7PzZfPOA5LoE8D7m1oWJ+XkiraDU18cIEkdewiavIDbJGFHQ+ENziTGuN8I842Ozg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t6oMLdA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6oMLdA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473E3C4CEED;
	Fri,  6 Jun 2025 03:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749181862;
	bh=z9+c/eIlguZsUpT5wT5zRL8mjcV+K6M5EUm2Gld00RM=;
	h=Date:To:From:Subject:From;
	b=t6oMLdA3z9Rwh122+BY5nsGMdlOS2GLVSCAMXzGYFJV7YEmmoVgVPTQk80f8a+b2h
	 zuLncFp2/aPqlGfhkgWyDQ9SlKHb6+TUdNutMlu+DHH/Bp1faOno89160R++8sd1CU
	 M3SNIkc+l4jzwgm7HO3piEl2H3VMQOUK+ZUBr2kE=
Date: Thu, 05 Jun 2025 20:51:01 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,viro@zeniv.linux.org.uk,rick.p.edgecombe@intel.com,kirill.shutemov@linux.intel.com,ast@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-avoid-use-after-free-in-proc_reg_open-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250606035102.473E3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: clear FMODE_LSEEK flag correctly for permanent pde
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-avoid-use-after-free-in-proc_reg_open-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-avoid-use-after-free-in-proc_reg_open-fix.patch

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
From: wangzijie <wangzijie1@honor.com>
Subject: proc: clear FMODE_LSEEK flag correctly for permanent pde
Date: Thu, 5 Jun 2025 14:52:52 +0800

Clearing FMODE_LSEEK flag should not rely on whether proc_open ops exists,
fix it.

Link: https://lkml.kernel.org/r/20250605065252.900317-1-wangzijie1@honor.com
Signed-off-by: wangzijie <wangzijie1@honor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/proc/inode.c~proc-avoid-use-after-free-in-proc_reg_open-fix
+++ a/fs/proc/inode.c
@@ -474,12 +474,11 @@ static int proc_reg_open(struct inode *i
 	struct pde_opener *pdeo;
 
 	if (pde_is_permanent(pde)) {
+		if (!pde->proc_ops->proc_lseek)
+			file->f_mode &= ~FMODE_LSEEK;
 		open = pde->proc_ops->proc_open;
-		if (open) {
-			if (!pde->proc_ops->proc_lseek)
-				file->f_mode &= ~FMODE_LSEEK;
+		if (open)
 			rv = open(inode, file);
-		}
 		return rv;
 	}
 
_

Patches currently in -mm which might be from wangzijie1@honor.com are

proc-avoid-use-after-free-in-proc_reg_open.patch
proc-avoid-use-after-free-in-proc_reg_open-fix.patch

