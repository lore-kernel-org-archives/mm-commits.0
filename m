Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7C719CD1A
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 19:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518399; cv=none; b=rNJ7LpaBHmoUzOTN2XBbzKPlQp+3iS95zXSxG2pMT68PRTj2ntvHeRCWOl3EHlO1Ktx9aWGh7vizhUz/3hAYTe3iDr6WbJKhpz1ivrQ7BzbR8/NGFkhgdV2K8JXHIFesvl9VpOCiNao1iZSXezFrs8A/nQUWUDXK/wDVY1TpmtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518399; c=relaxed/simple;
	bh=uTe+y4BrYwAqJIbMmjJz+n1K0np3Dyg//zPuoSWESfU=;
	h=Date:To:From:Subject:Message-Id; b=BdggyGW0GXGPypg3YZarHUv2Bnl0iUdDyy30EUu0nwETM/6hVTVGSsrP6xyp/TA7HWbML1IMjBIXTpnucA+8z0CtcYH0+Y+mnr+odmiqHQo4dvVNOjDyv5y3sCcfaquSc73AQuc5NrdTIFyvfZEET5W6NJpRquP9ewn219l7EFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uf+XPnWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uf+XPnWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099FEC2BBFC;
	Thu, 27 Jun 2024 19:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719518399;
	bh=uTe+y4BrYwAqJIbMmjJz+n1K0np3Dyg//zPuoSWESfU=;
	h=Date:To:From:Subject:From;
	b=uf+XPnWaS1er3IhXRXgd6BZyMdFNc/d82EBOmQooVUzziq/kFii8gdxLnzc5dvV7O
	 Z4tA571RgavqBzF8Qy1THh7UEBzrV2vIVX9moxg6r4gsOr3VoU2Hc24TOZpbNxwdYf
	 VINjgpaxapX3kUGMVPlk2Fc+aKdnIPx9Ld2pPqg4=
Date: Thu, 27 Jun 2024 12:59:58 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,rppt@kernel.org,Liam.Howlett@oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-procfs-add-build-id-fetching-to-procmap_query-api.patch added to mm-unstable branch
Message-Id: <20240627195959.099FEC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/procfs: add build ID fetching to PROCMAP_QUERY API
has been added to the -mm mm-unstable branch.  Its filename is
     fs-procfs-add-build-id-fetching-to-procmap_query-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-procfs-add-build-id-fetching-to-procmap_query-api.patch

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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: fs/procfs: add build ID fetching to PROCMAP_QUERY API
Date: Thu, 27 Jun 2024 10:08:55 -0700

The need to get ELF build ID reliably is an important aspect when dealing
with profiling and stack trace symbolization, and /proc/<pid>/maps textual
representation doesn't help with this.

To get backing file's ELF build ID, application has to first resolve VMA,
then use it's start/end address range to follow a special
/proc/<pid>/map_files/<start>-<end> symlink to open the ELF file (this is
necessary because backing file might have been removed from the disk or
was already replaced with another binary in the same file path.

Such approach, beyond just adding complexity of having to do a bunch of
extra work, has extra security implications.  Because application opens
underlying ELF file and needs read access to its entire contents (as far
as kernel is concerned), kernel puts additional capable() checks on
following /proc/<pid>/map_files/<start>-<end> symlink.  And that makes
sense in general.

But in the case of build ID, profiler/symbolizer doesn't need the contents
of ELF file, per se.  It's only build ID that is of interest, and ELF
build ID itself doesn't provide any sensitive information.

So this patch adds a way to request backing file's ELF build ID along the
rest of VMA information in the same API.  User has control over whether
this piece of information is requested or not by either setting
build_id_size field to zero or non-zero maximum buffer size they provided
through build_id_addr field (which encodes user pointer as __u64 field). 
This is a completely optional piece of information, and so has no
performance implications for user cases that don't care about build ID,
while improving performance and simplifying the setup for those
application that do need it.

Kernel already implements build ID fetching, which is used from BPF
subsystem.  We are reusing this code here, but plan a follow up changes to
make it work better under more relaxed assumption (compared to what
existing code assumes) of being called from user process context, in which
page faults are allowed.  BPF-specific implementation currently bails out
if necessary part of ELF file is not paged in, all due to extra
BPF-specific restrictions (like the need to fetch build ID in restrictive
contexts such as NMI handler).

Link: https://lkml.kernel.org/r/20240627170900.1672542-4-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   25 ++++++++++++++++++++++++-
 include/uapi/linux/fs.h |   28 ++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-procfs-add-build-id-fetching-to-procmap_query-api
+++ a/fs/proc/task_mmu.c
@@ -22,6 +22,7 @@
 #include <linux/pkeys.h>
 #include <linux/minmax.h>
 #include <linux/overflow.h>
+#include <linux/buildid.h>
 
 #include <asm/elf.h>
 #include <asm/tlb.h>
@@ -445,6 +446,7 @@ skip_vma:
 	addr = vma->vm_end;
 	if (flags & PROCMAP_QUERY_COVERING_OR_NEXT_VMA)
 		goto next_vma;
+
 no_vma:
 	return ERR_PTR(-ENOENT);
 }
@@ -455,7 +457,7 @@ static int do_procmap_query(struct proc_
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	const char *name = NULL;
-	char *name_buf = NULL;
+	char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf = NULL;
 	__u64 usize;
 	int err;
 
@@ -477,6 +479,8 @@ static int do_procmap_query(struct proc_
 	/* either both buffer address and size are set, or both should be zero */
 	if (!!karg.vma_name_size != !!karg.vma_name_addr)
 		return -EINVAL;
+	if (!!karg.build_id_size != !!karg.build_id_addr)
+		return -EINVAL;
 
 	mm = priv->mm;
 	if (!mm || !mmget_not_zero(mm))
@@ -539,6 +543,21 @@ static int do_procmap_query(struct proc_
 		}
 	}
 
+	if (karg.build_id_size) {
+		__u32 build_id_sz;
+
+		err = build_id_parse(vma, build_id_buf, &build_id_sz);
+		if (err) {
+			karg.build_id_size = 0;
+		} else {
+			if (karg.build_id_size < build_id_sz) {
+				err = -ENAMETOOLONG;
+				goto out;
+			}
+			karg.build_id_size = build_id_sz;
+		}
+	}
+
 	if (karg.vma_name_size) {
 		size_t name_buf_sz = min_t(size_t, PATH_MAX, karg.vma_name_size);
 		const struct path *path;
@@ -583,6 +602,10 @@ static int do_procmap_query(struct proc_
 	}
 	kfree(name_buf);
 
+	if (karg.build_id_size && copy_to_user((void __user *)karg.build_id_addr,
+					       build_id_buf, karg.build_id_size))
+		return -EFAULT;
+
 	if (copy_to_user(uarg, &karg, min_t(size_t, sizeof(karg), usize)))
 		return -EFAULT;
 
--- a/include/uapi/linux/fs.h~fs-procfs-add-build-id-fetching-to-procmap_query-api
+++ a/include/uapi/linux/fs.h
@@ -512,6 +512,26 @@ struct procmap_query {
 	 */
 	__u32 vma_name_size;		/* in/out */
 	/*
+	 * If set to non-zero value, signals the request to extract and return
+	 * VMA's backing file's build ID, if the backing file is an ELF file
+	 * and it contains embedded build ID.
+	 *
+	 * Kernel will set this field to zero, if VMA has no backing file,
+	 * backing file is not an ELF file, or ELF file has no build ID
+	 * embedded.
+	 *
+	 * Build ID is a binary value (not a string). Kernel will set
+	 * build_id_size field to exact number of bytes used for build ID.
+	 * If build ID is requested and present, but needs more bytes than
+	 * user-supplied maximum buffer size (see build_id_addr field below),
+	 * -E2BIG error will be returned.
+	 *
+	 * If this field is set to non-zero value, build_id_addr should point
+	 * to valid user space memory buffer of at least build_id_size bytes.
+	 * If set to zero, build_id_addr should be set to zero as well
+	 */
+	__u32 build_id_size;		/* in/out */
+	/*
 	 * User-supplied address of a buffer of at least vma_name_size bytes
 	 * for kernel to fill with matched VMA's name (see vma_name_size field
 	 * description above for details).
@@ -519,6 +539,14 @@ struct procmap_query {
 	 * Should be set to zero if VMA name should not be returned.
 	 */
 	__u64 vma_name_addr;		/* in */
+	/*
+	 * User-supplied address of a buffer of at least build_id_size bytes
+	 * for kernel to fill with matched VMA's ELF build ID, if available
+	 * (see build_id_size field description above for details).
+	 *
+	 * Should be set to zero if build ID should not be returned.
+	 */
+	__u64 build_id_addr;		/* in */
 };
 
 #endif /* _UAPI_LINUX_FS_H */
_

Patches currently in -mm which might be from andrii@kernel.org are

fs-procfs-extract-logic-for-getting-vma-name-constituents.patch
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api.patch
docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch
tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch
selftests-proc-add-procmap_query-ioctl-tests.patch

