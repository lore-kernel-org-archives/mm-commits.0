Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A9A284B3F
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126248; cv=none; b=RFLekSHOwLUN9n53i38OjfGWxgibFgzaYbMt/iX+MUivAPLngNbwRO3LddNgBReVj3tP7lClSAkQdYx0AFuDVKw7+l5gJngouldg1l93w/PGrHmFXAuCJ0WGNfnNnf445SJSL58AWYTGM8MjYMwcNu16relSn5QNxOSOsIf8jxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126248; c=relaxed/simple;
	bh=x+08GAfV1Rfln4Z2Yc9eC8GoXzzIBZmckg+DncFxRsc=;
	h=Date:To:From:Subject:Message-Id; b=sjOaVNOTKjoCIbFqMjdPDlPI8VEIKAZwh7HryLvi9xR5eudo05Gs3VE6IvfRTmdhNAv8oRzwMUZQVugn6fLFcZitqsIcgejznNmfeZa2IC1cgk0wdoZcN4gFChBaPG/UMtF94sBm5HXMFU29OqBTQXhMNwcVk+HAbA6kcjIQ4mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H1rV988N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H1rV988N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A895C4CEE3;
	Thu, 10 Jul 2025 05:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126248;
	bh=x+08GAfV1Rfln4Z2Yc9eC8GoXzzIBZmckg+DncFxRsc=;
	h=Date:To:From:Subject:From;
	b=H1rV988NIQBHELrINMeGDsSLL9U6e8qdmfuXhXnZPhXxJc9JKS1mfJCkYnlwJXv5o
	 QBDcawyDMFFBNr+GUCLDhZSxr8/CXXnU5RFwpvIZLPvtDfxTz0G6cGWbM4sFn06Gg4
	 ls0MWn/RXPcciQ3ialEyo71xPJxqq1omxuB3QuAI=
Date: Wed, 09 Jul 2025 22:44:08 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,rick.p.edgecombe@intel.com,kirill.shutemov@linux.intel.com,ast@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal.patch removed from -mm tree
Message-Id: <20250710054408.8A895C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al
has been removed from the -mm tree.  Its filename was
     proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wangzijie <wangzijie1@honor.com>
Subject: proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al
Date: Sat, 7 Jun 2025 10:13:53 +0800

Check pde->proc_ops->proc_lseek directly may cause UAF in rmmod scenario. 
It's a gap in proc_reg_open() after commit 654b33ada4ab("proc: fix UAF in
proc_get_inode()").  Followed by AI Viro's suggestion, fix it in same
manner.

Link: https://lkml.kernel.org/r/20250607021353.1127963-1-wangzijie1@honor.com
Fixes: 3f61631d47f1 ("take care to handle NULL ->proc_lseek()")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    2 ++
 fs/proc/inode.c         |    2 +-
 fs/proc/internal.h      |    5 +++++
 include/linux/proc_fs.h |    1 +
 4 files changed, 9 insertions(+), 1 deletion(-)

--- a/fs/proc/generic.c~proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal
+++ a/fs/proc/generic.c
@@ -569,6 +569,8 @@ static void pde_set_flags(struct proc_di
 	if (pde->proc_ops->proc_compat_ioctl)
 		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
 #endif
+	if (pde->proc_ops->proc_lseek)
+		pde->flags |= PROC_ENTRY_proc_lseek;
 }
 
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
--- a/fs/proc/inode.c~proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal
+++ a/fs/proc/inode.c
@@ -473,7 +473,7 @@ static int proc_reg_open(struct inode *i
 	typeof_member(struct proc_ops, proc_open) open;
 	struct pde_opener *pdeo;
 
-	if (!pde->proc_ops->proc_lseek)
+	if (!pde_has_proc_lseek(pde))
 		file->f_mode &= ~FMODE_LSEEK;
 
 	if (pde_is_permanent(pde)) {
--- a/fs/proc/internal.h~proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal
+++ a/fs/proc/internal.h
@@ -99,6 +99,11 @@ static inline bool pde_has_proc_compat_i
 #endif
 }
 
+static inline bool pde_has_proc_lseek(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_lseek;
+}
+
 extern struct kmem_cache *proc_dir_entry_cache;
 void pde_free(struct proc_dir_entry *pde);
 
--- a/include/linux/proc_fs.h~proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal
+++ a/include/linux/proc_fs.h
@@ -27,6 +27,7 @@ enum {
 
 	PROC_ENTRY_proc_read_iter	= 1U << 1,
 	PROC_ENTRY_proc_compat_ioctl	= 1U << 2,
+	PROC_ENTRY_proc_lseek		= 1U << 3,
 };
 
 struct proc_ops {
_

Patches currently in -mm which might be from wangzijie1@honor.com are


