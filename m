Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37982C031B
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482664; cv=none; b=QQ5zeOku49gD4H9Py+tbUPHXTGauiU+Gt7KGZhG9bUU8KcwwbBljiLvj237D1BAkw3QoGUlHJV7mYUsakw7788+ixsDYLMak8CbIqDMP4NBUruxp35rKAzpdPBI1lCTuEFu3PGwL9Z8C74m5+eEHIaahFdobg4d92tAW+hSK08Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482664; c=relaxed/simple;
	bh=ThbU/POH20jrJkie1st4TxaA4cyXXlITKSAz4hTLuRc=;
	h=Date:To:From:Subject:Message-Id; b=gkP/ItQgLVLDBi9/UEKlt5j3EY/d6AMBnInVSBg10ezhWFH3A1u38oG+oznVFznDQuLktNMELUJPa8ISKmvkJZQ7XS57HLXJsUHmcaoSwDvtndEob9YT4Pwj6xcViP9WcMlxCQmMI3B1ID2luNHXr6mMz3mpXpFdTaFGp4EIeso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EulIMANb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EulIMANb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54548C19421;
	Tue, 27 Jan 2026 02:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482664;
	bh=ThbU/POH20jrJkie1st4TxaA4cyXXlITKSAz4hTLuRc=;
	h=Date:To:From:Subject:From;
	b=EulIMANbLt4E862TOyx3UeG+cNzlJKWqrVkPcNZj+9ZT/se/WRQ4VlteTi8ayvEaf
	 a8oeX+wiA04QQSaNg1dAnp1oz7ToeOGIacVrDj3JwZYjKALLJA2SVrq0kFw8vdwSJe
	 OPQzzLHieWq9UHJPV0sLtXd+dLYRkbAvDUrden9M=
Date: Mon, 26 Jan 2026 18:57:43 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,hughd@google.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memfd-export-alloc_file.patch removed from -mm tree
Message-Id: <20260127025744.54548C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memfd: export alloc_file()
has been removed from the -mm tree.  Its filename was
     memfd-export-alloc_file.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: memfd: export alloc_file()
Date: Thu, 22 Jan 2026 16:18:39 +0100

Patch series "mm: memfd_luo hotfixes".

This series contains a couple of fixes for memfd preservation using LUO.


This patch (of 3):

The Live Update Orchestrator's (LUO) memfd preservation works by
preserving all the folios of a memfd, re-creating an empty memfd on the
next boot, and then inserting back the preserved folios.

Currently it creates the file by directly calling shmem_file_setup(). 
This leaves out other work done by alloc_file() like setting up the file
mode, flags, or calling the security hooks.

Export alloc_file() to let memfd_luo use it.  Rename it to
memfd_alloc_file() since it is no longer private and thus needs a
subsystem prefix.

Link: https://lkml.kernel.org/r/20260122151842.4069702-1-pratyush@kernel.org
Link: https://lkml.kernel.org/r/20260122151842.4069702-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memfd.h |    6 ++++++
 mm/memfd.c            |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/memfd.h~memfd-export-alloc_file
+++ a/include/linux/memfd.h
@@ -17,6 +17,7 @@ struct folio *memfd_alloc_folio(struct f
  * to by vm_flags_ptr.
  */
 int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
+struct file *memfd_alloc_file(const char *name, unsigned int flags);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
@@ -31,6 +32,11 @@ static inline int memfd_check_seals_mmap
 {
 	return 0;
 }
+
+static inline struct file *memfd_alloc_file(const char *name, unsigned int flags)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif
 
 #endif /* __LINUX_MEMFD_H */
--- a/mm/memfd.c~memfd-export-alloc_file
+++ a/mm/memfd.c
@@ -456,7 +456,7 @@ err_name:
 	return ERR_PTR(error);
 }
 
-static struct file *alloc_file(const char *name, unsigned int flags)
+struct file *memfd_alloc_file(const char *name, unsigned int flags)
 {
 	unsigned int *file_seals;
 	struct file *file;
@@ -520,5 +520,5 @@ SYSCALL_DEFINE2(memfd_create,
 		return PTR_ERR(name);
 
 	fd_flags = (flags & MFD_CLOEXEC) ? O_CLOEXEC : 0;
-	return FD_ADD(fd_flags, alloc_file(name, flags));
+	return FD_ADD(fd_flags, memfd_alloc_file(name, flags));
 }
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch
liveupdate-luo_file-remember-retrieve-status.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

