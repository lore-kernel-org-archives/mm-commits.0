Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2F719DF62
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 23:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755904206; cv=none; b=Tou+ZEnB0sK67L6zy1/qxCnWP1iCdNGg9Qb/3MKvlJK58OTMG4BrAE0ev64MK6Y3pdf6LUJITzOtRUYMyAO4xCQIkE4q8lpbWv7sfbWFQ2JEQW865Q/v9JWI/nB1EY8XLAg7jzI25GZtafxIayEgdHwTrgZAQtXze1ZZj+f6rdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755904206; c=relaxed/simple;
	bh=GGZuDVAF7Aqll7Hj11pWFK0avfZzgMgNNR5IKg1JnDQ=;
	h=Date:To:From:Subject:Message-Id; b=QL42vRl0pP+MHB9Q6VOfqgc8PVaqAWWlnb+Dh5oe7VKIlq0mC0IYpcOFIH2FeTPNJt/92cz63dVUr1J83bGX3P1v8LTkzrKRW0/nZF9caNryiSm6X19XAGxN2hcL+M+tfKj1/teA4AWRToPx4PO98oOD+VQRLY1t7qwKE7JiV24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r8beg2nG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r8beg2nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B65AC4CEF1;
	Fri, 22 Aug 2025 23:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755904206;
	bh=GGZuDVAF7Aqll7Hj11pWFK0avfZzgMgNNR5IKg1JnDQ=;
	h=Date:To:From:Subject:From;
	b=r8beg2nG0j8OKle8FeURxTGjvXXxCX4IGBkQFg4+q6aOAdKy4YqUpru6qf1Ki+Nz7
	 HqA0gGX3SyMYUOvDIOTYMv+NzoI8ktIEiqSkJpgo9tww69NOQKT469+hrrNAa1+1Lb
	 JQqfzbQQXZnEh2+pAcO73d5YA2Qugy8crbihV4cM=
Date: Fri, 22 Aug 2025 16:10:05 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,rick.p.edgecombe@intel.com,polynomial-c@gmx.de,k.shutemov@gmail.com,jirislaby@kernel.org,gregkh@linuxfoundation.org,ast@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-fix-missing-pde_set_flags-for-net-proc-files-v3.patch removed from -mm tree
Message-Id: <20250822231006.3B65AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc-fix-missing-pde_set_flags-for-net-proc-files-v3
has been removed from the -mm tree.  Its filename was
     proc-fix-missing-pde_set_flags-for-net-proc-files-v3.patch

This patch was dropped because it was folded into proc-fix-missing-pde_set_flags-for-net-proc-files.patch

------------------------------------------------------
From: wangzijie <wangzijie1@honor.com>
Subject: proc-fix-missing-pde_set_flags-for-net-proc-files-v3
Date: Thu, 21 Aug 2025 18:58:06 +0800

stash pde->proc_ops in a local const variable, per Christian

Link: https://lkml.kernel.org/r/20250821105806.1453833-1-wangzijie1@honor.com
Fixes: ff7ec8dc1b64 ("proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reported-by: Lars Wendler <polynomial-c@gmx.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/proc/generic.c~proc-fix-missing-pde_set_flags-for-net-proc-files-v3
+++ a/fs/proc/generic.c
@@ -369,18 +369,20 @@ static const struct inode_operations pro
 
 static void pde_set_flags(struct proc_dir_entry *pde)
 {
-	if (!pde->proc_ops)
+	const struct proc_ops *proc_ops = pde->proc_ops;
+
+	if (!proc_ops)
 		return;
 
-	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
+	if (proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
 		pde->flags |= PROC_ENTRY_PERMANENT;
-	if (pde->proc_ops->proc_read_iter)
+	if (proc_ops->proc_read_iter)
 		pde->flags |= PROC_ENTRY_proc_read_iter;
 #ifdef CONFIG_COMPAT
-	if (pde->proc_ops->proc_compat_ioctl)
+	if (proc_ops->proc_compat_ioctl)
 		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
 #endif
-	if (pde->proc_ops->proc_lseek)
+	if (proc_ops->proc_lseek)
 		pde->flags |= PROC_ENTRY_proc_lseek;
 }
 
_

Patches currently in -mm which might be from wangzijie1@honor.com are

proc-fix-missing-pde_set_flags-for-net-proc-files.patch

