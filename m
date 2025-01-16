Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E140417E00E
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006293; cv=none; b=UKCB/lQvHC6AYknYj+D1MMCIqGj5ZYplNFBj5H3yR0lwvx6Ld7spehnGXVgNjN7Nnuzo1njgt/4lf8e4P2voMPq+sDbRmQZLkNzQ9GGHbOCVZ3bfQX9oXHyDBx3h7+W6M8cffzagF7njQbo1FTLucjrfKdXOUI5ADeznx46BDF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006293; c=relaxed/simple;
	bh=R3S57U/zYnprFLmKf39EktNRvfvkkuLMY+Ru7jB+6lg=;
	h=Date:To:From:Subject:Message-Id; b=NZSkaoMJX9pGKD5j7IAMZaSTy5ebnFpWuIoD8n594kwHrRli5aZ20E+Vhms2ZAWxbOR6zoE8cG8Kjr/XCk8EENEpk+/MyGUsaMqnSuKG7d988RyTB56WhXMtSpjTbyjQirZtkGcKwGruJ8EdwdqwIjy2U3vqs5gUzbrHIY+5FtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vl+vDEFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vl+vDEFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FA9C4CED6;
	Thu, 16 Jan 2025 05:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006292;
	bh=R3S57U/zYnprFLmKf39EktNRvfvkkuLMY+Ru7jB+6lg=;
	h=Date:To:From:Subject:From;
	b=Vl+vDEFdMIIWbkhyokWxeTTZ8QcQdoxzVkgoJJa6R3Lc7Woey6vqUMNGPvVCax81A
	 8WFi5mxeAsIv9JpQtYVyezT4eqNqeHTn6yyO9dFYVB4aLb7ahlQpk0oxva8cU1+PNE
	 cZ+vFwO2D14JD+3dKpToxrJKLwGgjAI7FHvpXZxo=
Date: Wed, 15 Jan 2025 21:44:52 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,kaleshsingh@google.com,jstultz@google.com,aliceryhl@google.com,isaacmanjarres@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch removed from -mm tree
Message-Id: <20250116054452.B4FA9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: refactor and cleanup the logic in memfd_create()
has been removed from the -mm tree.  Its filename was
     mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: mm/memfd: refactor and cleanup the logic in memfd_create()
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


