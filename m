Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460C8156653
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736309799; cv=none; b=KzGmAEQKfTyMqMVyRc90skHcfcsKc51wDPCWpf/ODKchbxgt3AFekTeysGHzHzRddyNI1i3yJdUgVRHnyDpOaarKIzAa+O6nfPZo/On+aIn+7iOPyeeTtT1GH59iK8yxtAl+FplrH2zIQCMr693/jTnXnu0gz3MKVjYDWMt8/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736309799; c=relaxed/simple;
	bh=W0qxrcyGv95l93o7pA1PEktjofM5ER31MFE+3KiNd7o=;
	h=Date:To:From:Subject:Message-Id; b=dJkziQWQMaYj/NnZUXZbtNogiU0uZ79/lDSZF1Izcg+62trjXuIK4XhfwfAZ7Aqqz4EHcLcytgl2hLvS8Q2YLtsWEgSCklIakJDKvAxMRMHiiVT1+Rbw/xSFk7Ubdn2UCWL/en3j6t7pFeN+uQWiiVpmVfVqei5AcCk96Zr+pd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VLOGalSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VLOGalSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B273BC4CED0;
	Wed,  8 Jan 2025 04:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736309798;
	bh=W0qxrcyGv95l93o7pA1PEktjofM5ER31MFE+3KiNd7o=;
	h=Date:To:From:Subject:From;
	b=VLOGalSsGcsKY7LVeOox5Suc8OsSidY5vGtD/NZ5mVdFEpNu5n539yGkuVzHAC8dZ
	 ewHd87opv1jKuvNgU8ye5hTZIczfjd1F2BoiOngMtF7uoxn0uFacA/5ef1gjbjw90F
	 ynXA+oR+7hIIPsOUtnc6NA4thE5Bj1iS1sBojoxk=
Date: Tue, 07 Jan 2025 20:16:38 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,kaleshsingh@google.com,jstultz@google.com,aliceryhl@google.com,isaacmanjarres@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch added to mm-unstable branch
Message-Id: <20250108041638.B273BC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: refactor and cleanup the logic in memfd_create()
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
Subject: mm/memfd: refactor and cleanup the logic in memfd_create()
Date: Tue, 7 Jan 2025 10:48:01 -0800

Patch series "Cleanup for memfd_create()".

memfd_create() handles all of its logic in a single function.  Some of the
logic in the function is also somewhat contrived (i.e.  copying the memfd
name from userpace).

This series aims to cleanup memfd_create() by splitting out the logic into
helper functions, and simplifying the memfd name copying to make the code
easier to follow.

This has no intended functional changes.


This patch (of 2):

memfd_create() is a pretty busy function that could be easier to read if
some of the logic was split out into helper functions.

Therefore, split the flags check, name creation, and file creation into
their own helper functions, and create the file structure before creating
the memfd.  This allows for simplifying the error handling path in
memfd_create().

No functional change.

Link: https://lkml.kernel.org/r/20250107184804.4074147-1-isaacmanjarres@google.com
Link: https://lkml.kernel.org/r/20250107184804.4074147-2-isaacmanjarres@google.com
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: John Stultz <jstultz@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   87 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 31 deletions(-)

--- a/mm/memfd.c~mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create
+++ a/mm/memfd.c
@@ -369,16 +369,8 @@ int memfd_check_seals_mmap(struct file *
 	return err;
 }
 
-SYSCALL_DEFINE2(memfd_create,
-		const char __user *, uname,
-		unsigned int, flags)
+static int memfd_validate_flags(unsigned int flags)
 {
-	unsigned int *file_seals;
-	struct file *file;
-	int fd, error;
-	char *name;
-	long len;
-
 	if (!(flags & MFD_HUGETLB)) {
 		if (flags & ~(unsigned int)MFD_ALL_FLAGS)
 			return -EINVAL;
@@ -393,20 +385,25 @@ SYSCALL_DEFINE2(memfd_create,
 	if ((flags & MFD_EXEC) && (flags & MFD_NOEXEC_SEAL))
 		return -EINVAL;
 
-	error = check_sysctl_memfd_noexec(&flags);
-	if (error < 0)
-		return error;
+	return check_sysctl_memfd_noexec(&flags);
+}
+
+static char *memfd_create_name(const char __user *uname)
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
@@ -420,11 +417,22 @@ SYSCALL_DEFINE2(memfd_create,
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
+static struct file *memfd_file_create(const char *name, unsigned int flags)
+{
+	unsigned int *file_seals;
+	struct file *file;
+	int error;
+
+	error = memfd_validate_flags(flags);
+	if (error < 0)
+		return ERR_PTR(error);
 
 	if (flags & MFD_HUGETLB) {
 		file = hugetlb_file_setup(name, 0, VM_NORESERVE,
@@ -433,10 +441,8 @@ SYSCALL_DEFINE2(memfd_create,
 					MFD_HUGE_MASK);
 	} else
 		file = shmem_file_setup(name, 0, VM_NORESERVE);
-	if (IS_ERR(file)) {
-		error = PTR_ERR(file);
-		goto err_fd;
-	}
+	if (IS_ERR(file))
+		return file;
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	file->f_flags |= O_LARGEFILE;
 
@@ -456,13 +462,32 @@ SYSCALL_DEFINE2(memfd_create,
 			*file_seals &= ~F_SEAL_SEAL;
 	}
 
-	fd_install(fd, file);
-	kfree(name);
-	return fd;
+	return file;
+}
 
-err_fd:
-	put_unused_fd(fd);
-err_name:
+SYSCALL_DEFINE2(memfd_create,
+		const char __user *, uname,
+		unsigned int, flags)
+{
+	struct file *file;
+	int fd;
+	char *name;
+
+	name = memfd_create_name(uname);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	file = memfd_file_create(name, flags);
+	/* name is not needed beyond this point. */
 	kfree(name);
-	return error;
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	fd = get_unused_fd_flags((flags & MFD_CLOEXEC) ? O_CLOEXEC : 0);
+	if (fd >= 0)
+		fd_install(fd, file);
+	else
+		fput(file);
+
+	return fd;
 }
_

Patches currently in -mm which might be from isaacmanjarres@google.com are

mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch
mm-memfd-use-strncpy_from_user-to-read-memfd-name.patch

