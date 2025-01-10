Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD30A2063E0
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736551199; cv=none; b=LvoiHXe1I37kDf1YfZRm887V6HFpOL8AFsowSFX8xi80uslAd6rrv1egWdaxty4IBphmUDnDT+FizhSlJQ0ytn8IHkoJrUD6YQkyO9g5fibjsmU95FjnABmboHcdkqPccKMTveB8HKFqr9k8UwrbJJ5oNUYIjVqdWk8e1wuyBr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736551199; c=relaxed/simple;
	bh=jYCFiwHSHTZ9xktZNAVFM8dHGFFhK1l5zWycbJUIZRo=;
	h=Date:To:From:Subject:Message-Id; b=ltGV4Tnt2M8k/wJ5Se1P6p/Rzit3TULdK338pvc99XS8v6oUxr3Mj7izSuX3VySnDhVvHJIJxbzryErP6q6H180Ij9QrIAmxzNQha658wI5rX1WA7F20aToyJe2xQHzIQ1CnYaIJKs+67PkCWnC0AIPfJFIZottFNSo68xNxg4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y9VUHR43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y9VUHR43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABD3C4CEE8;
	Fri, 10 Jan 2025 23:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736551199;
	bh=jYCFiwHSHTZ9xktZNAVFM8dHGFFhK1l5zWycbJUIZRo=;
	h=Date:To:From:Subject:From;
	b=Y9VUHR43SQ+vf7NphLFlHm4dWAPJshiR9K6VNcQL7kgi9odf06tVyFfgfupl5GN69
	 7fKONJJnANFdodWvs9Gx3ujfVVH3ocdpTvPRlAKd8L6bcC7z8zxSJYC5ZEhdxehmjx
	 RcFycFyhCGGooVtuJTv9hNmF5K4Pur4jZX4HQ44g=
Date: Fri, 10 Jan 2025 15:19:58 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,kaleshsingh@google.com,jstultz@google.com,aliceryhl@google.com,isaacmanjarres@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch added to mm-unstable branch
Message-Id: <20250110231959.3ABD3C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: Refactor and cleanup the logic in memfd_create()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch

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
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: mm/memfd: Refactor and cleanup the logic in memfd_create()
Date: Fri, 10 Jan 2025 08:58:59 -0800

Patch series "Cleanup for memfd_create()", v4.

memfd_create() handles all of its logic in a single function.  Some of the
logic in the function is also somewhat contrived (i.e.  copying the memfd
name from userpace).

This series aims to cleanup memfd_create() by splitting out the logic into
helper functions, and simplifying the memfd name copying to make the code
easier to follow.

This has no intended functional changes.

Thank you Alice and Lorenzo for reviewing v3 of this series and for your
feedback!


This patch (of 2):

memfd_create() is a pretty busy function that could be easier to read if
some of the logic was split out into helper functions.

Therefore, split the flags sanitization, name allocation, and file
structure allocation into their own helper functions.

No functional change.

Link: https://lkml.kernel.org/r/20250110165904.3437374-1-isaacmanjarres@google.com
Link: https://lkml.kernel.org/r/20250110165904.3437374-2-isaacmanjarres@google.com
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: John Stultz <jstultz@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   81 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 23 deletions(-)

--- a/mm/memfd.c~mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create
+++ a/mm/memfd.c
@@ -369,15 +369,9 @@ int memfd_check_seals_mmap(struct file *
 	return err;
 }
 
-SYSCALL_DEFINE2(memfd_create,
-		const char __user *, uname,
-		unsigned int, flags)
+static int sanitize_flags(unsigned int *flags_ptr)
 {
-	unsigned int *file_seals;
-	struct file *file;
-	int fd, error;
-	char *name;
-	long len;
+	unsigned int flags = *flags_ptr;
 
 	if (!(flags & MFD_HUGETLB)) {
 		if (flags & ~(unsigned int)MFD_ALL_FLAGS)
@@ -393,20 +387,25 @@ SYSCALL_DEFINE2(memfd_create,
 	if ((flags & MFD_EXEC) && (flags & MFD_NOEXEC_SEAL))
 		return -EINVAL;
 
-	error = check_sysctl_memfd_noexec(&flags);
-	if (error < 0)
-		return error;
+	return check_sysctl_memfd_noexec(flags_ptr);
+}
+
+static char *alloc_name(const char __user *uname)
+{
+	int error;
+	char *name;
+	long len;
 
 	/* length includes terminating zero */
 	len = strnlen_user(uname, MFD_NAME_MAX_LEN + 1);
 	if (len <= 0)
-		return -EFAULT;
+		return ERR_PTR(-EFAULT);
 	if (len > MFD_NAME_MAX_LEN + 1)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	name = kmalloc(len + MFD_NAME_PREFIX_LEN, GFP_KERNEL);
 	if (!name)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	strcpy(name, MFD_NAME_PREFIX);
 	if (copy_from_user(&name[MFD_NAME_PREFIX_LEN], uname, len)) {
@@ -420,23 +419,28 @@ SYSCALL_DEFINE2(memfd_create,
 		goto err_name;
 	}
 
-	fd = get_unused_fd_flags((flags & MFD_CLOEXEC) ? O_CLOEXEC : 0);
-	if (fd < 0) {
-		error = fd;
-		goto err_name;
-	}
+	return name;
+
+err_name:
+	kfree(name);
+	return ERR_PTR(error);
+}
+
+static struct file *alloc_file(const char *name, unsigned int flags)
+{
+	unsigned int *file_seals;
+	struct file *file;
 
 	if (flags & MFD_HUGETLB) {
 		file = hugetlb_file_setup(name, 0, VM_NORESERVE,
 					HUGETLB_ANONHUGE_INODE,
 					(flags >> MFD_HUGE_SHIFT) &
 					MFD_HUGE_MASK);
-	} else
+	} else {
 		file = shmem_file_setup(name, 0, VM_NORESERVE);
-	if (IS_ERR(file)) {
-		error = PTR_ERR(file);
-		goto err_fd;
 	}
+	if (IS_ERR(file))
+		return file;
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	file->f_flags |= O_LARGEFILE;
 
@@ -456,6 +460,37 @@ SYSCALL_DEFINE2(memfd_create,
 			*file_seals &= ~F_SEAL_SEAL;
 	}
 
+	return file;
+}
+
+SYSCALL_DEFINE2(memfd_create,
+		const char __user *, uname,
+		unsigned int, flags)
+{
+	struct file *file;
+	int fd, error;
+	char *name;
+
+	error = sanitize_flags(&flags);
+	if (error < 0)
+		return error;
+
+	name = alloc_name(uname);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	fd = get_unused_fd_flags((flags & MFD_CLOEXEC) ? O_CLOEXEC : 0);
+	if (fd < 0) {
+		error = fd;
+		goto err_name;
+	}
+
+	file = alloc_file(name, flags);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto err_fd;
+	}
+
 	fd_install(fd, file);
 	kfree(name);
 	return fd;
_

Patches currently in -mm which might be from isaacmanjarres@google.com are

mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch
mm-memfd-use-strncpy_from_user-to-read-memfd-name.patch

