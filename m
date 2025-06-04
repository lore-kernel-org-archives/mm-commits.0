Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB2215078
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 22:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749076029; cv=none; b=uBqodT25lJUr/bEkUySHOc3YfSyYydlxUagPcXU+RMJPW0DdvOR65KbLcjOiaWhid+lqQX/yT4paY74OtwUzVdhv+GGMVCUWqaVasIai2cosuj0b76DS+/LLweVkuEdwK6p5mbt1YVNTpd640vN321FWzmBeSv3HTaoxngGs9nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749076029; c=relaxed/simple;
	bh=9MOFWMsVD59Vq9ECSm4rHoMx2LxGFiUjfk/13GpcQ3M=;
	h=Date:To:From:Subject:Message-Id; b=GRMoverz0OPAYo3MA2ttmi1Gj5Uy6cP3eTCpyVQsJwQy2Yuhz+nVTnrzlJB3VLaAqPEN5TK73zGq9+r1cD2utf8VADl1lTqBNLl1Cn0adf9C81cotj5Ttt9HdV+BmaAqn3kN680w+XjVfaw2Gfhr4jGwrmUNB3m2Sm5byINCqAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZyCk/4mx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZyCk/4mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEF7C4CEE4;
	Wed,  4 Jun 2025 22:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749076028;
	bh=9MOFWMsVD59Vq9ECSm4rHoMx2LxGFiUjfk/13GpcQ3M=;
	h=Date:To:From:Subject:From;
	b=ZyCk/4mxE3/n9mDsGL9dX5m1xOPoshQ8ttP+1Rgg6lCQcnYJQ/iup3yXu7z/R4SQR
	 7vRQmYnnUGdmQQOTxiiVzLjqiDlvNFM+uPtdDY8GIViow0Q8NGj9r1YyyhEhh6lLi2
	 oYA1A5friHplaH9cLuGmanaE6rxOWPgYGTo8G1JU=
Date: Wed, 04 Jun 2025 15:27:07 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,rick.p.edgecombe@intel.com,kirill.shutemov@linux.intel.com,ast@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-avoid-use-after-free-in-proc_reg_open.patch added to mm-nonmm-unstable branch
Message-Id: <20250604222708.7FEF7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: avoid use-after-free in proc_reg_open()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-avoid-use-after-free-in-proc_reg_open.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-avoid-use-after-free-in-proc_reg_open.patch

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
Subject: proc: avoid use-after-free in proc_reg_open()
Date: Wed, 28 May 2025 11:47:56 +0800

Like the rmmod scenario mentioned by Ye Bin in proc: fix use-after-free in
proc_get_inode()[1], we should get pde->proc_ops after use_pde for
non-permanent pde to avoid UAF in proc_reg_open().

[1] https://lore.kernel.org/all/20250301034024.277290-1-yebin@huaweicloud.com/

Link: https://lkml.kernel.org/r/20250528034756.4069180-1-wangzijie1@honor.com
Signed-off-by: wangzijie <wangzijie1@honor.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/proc/inode.c~proc-avoid-use-after-free-in-proc_reg_open
+++ a/fs/proc/inode.c
@@ -473,13 +473,13 @@ static int proc_reg_open(struct inode *i
 	typeof_member(struct proc_ops, proc_open) open;
 	struct pde_opener *pdeo;
 
-	if (!pde->proc_ops->proc_lseek)
-		file->f_mode &= ~FMODE_LSEEK;
-
 	if (pde_is_permanent(pde)) {
 		open = pde->proc_ops->proc_open;
-		if (open)
+		if (open) {
+			if (!pde->proc_ops->proc_lseek)
+				file->f_mode &= ~FMODE_LSEEK;
 			rv = open(inode, file);
+		}
 		return rv;
 	}
 
@@ -506,6 +506,9 @@ static int proc_reg_open(struct inode *i
 		}
 	}
 
+	if (!pde->proc_ops->proc_lseek)
+		file->f_mode &= ~FMODE_LSEEK;
+
 	open = pde->proc_ops->proc_open;
 	if (open)
 		rv = open(inode, file);
_

Patches currently in -mm which might be from wangzijie1@honor.com are

proc-avoid-use-after-free-in-proc_reg_open.patch

