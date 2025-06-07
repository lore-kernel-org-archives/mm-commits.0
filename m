Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737A620012B
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 22:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749334444; cv=none; b=NQGubHCYzcHs7wczqB1HbyautkS8oZ+7sezGZvErWuVf1OEQYI5VYvf7egotuwePVD6IRD5/eh63PwwcyYfYFLxzhhNnUf0VmLCIkn2U2cOICijIK3bWbPVkuVwLnhh8rl1nExG037kZieHaFIOl4G+FNRLLv+HFoUfkH03opkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749334444; c=relaxed/simple;
	bh=eEoBrxRc1OvalNYNG7TRv7FxcQaii4MRzb7fQWm7akM=;
	h=Date:To:From:Subject:Message-Id; b=rlPsiBRAsLFDhyJDriUbD5tPmOxfpzCr6S+l7RnulBlgod/g/d5ugz0bmkhKhn9tnkJdX0fZxaQg0QpEPWJ+8g6zIbAFeSWn+ia6lUrQIIVH84pIrbieKdEGhWumlgXhPIWn54w3Y8UNRRKI4qINk1ckp+tExl9urH1/65t1b1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ykoMg4kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ykoMg4kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7582C4CEE4;
	Sat,  7 Jun 2025 22:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749334443;
	bh=eEoBrxRc1OvalNYNG7TRv7FxcQaii4MRzb7fQWm7akM=;
	h=Date:To:From:Subject:From;
	b=ykoMg4kneaD4Dqp0LPZddLnbQqEqmZMGY9VNz3mAX44lSq2RS53MXsVSMS4UuVcAR
	 cE5KHhyXWSSVtmOj3RTZrcasaXmUdzT9CapQVTt70+d16gzEHAgNSjXyMXzx0XqvHq
	 rDVZrGG/kbnr3hE+worKlX43cRvXul7XCUGqwfQ8=
Date: Sat, 07 Jun 2025 15:14:03 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,rick.p.edgecombe@intel.com,kirill.shutemov@linux.intel.com,ast@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal.patch added to mm-new branch
Message-Id: <20250607221403.D7582C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al.
has been added to the -mm mm-new branch.  Its filename is
     proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al.
Date: Sat, 7 Jun 2025 10:13:53 +0800

Check pde->proc_ops->proc_lseek directly may cause UAF in rmmod scenario. 
It's a gap in proc_reg_open() after commit 654b33ada4ab("proc: fix UAF in
proc_get_inode()").  Followed by AI Viro's suggestion, fix it in same
manner.

Link: https://lkml.kernel.org/r/20250607021353.1127963-1-wangzijie1@honor.com
Signed-off-by: wangzijie <wangzijie1@honor.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
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

proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal.patch

