Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C122586FE
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750806829; cv=none; b=Z156gXfj0sFVlzFtOKsi4ZXfo5CREnZEhLrG65b43yKqie1nzz7uHCuA/RcOue/eQTwB68FujXPAeI3HV4+RYu/iwLN9fJi+9aKLYWs0RQb7CBaUAsSGDT3Nl+dPpviiJ2a7i/AnJEFcXSmFNZD+enhjyL3zEk6KeY3TvuaqewI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750806829; c=relaxed/simple;
	bh=jCvRdceHaj9QBZOQLoL3/TpN14+jyJyyndbFMJDwFaM=;
	h=Date:To:From:Subject:Message-Id; b=pLUEwbWRNIBZpWFVTRpjMHwnw9FpPDzO9frjrPwHu1gQLbH4fZt41EqI7Yxo/6MqjWDZ1Spd8+T2LA2PVMmewOwK/76pCP/m4Z0zD/xa7Ceb3dJVsvkszb44srbsTgAJeEH2J/Ahirf6GU0dUjNjFEJ3YehIyt2/9ZqPUWwpyCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sWvNwas9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sWvNwas9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C589C4CEE3;
	Tue, 24 Jun 2025 23:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750806828;
	bh=jCvRdceHaj9QBZOQLoL3/TpN14+jyJyyndbFMJDwFaM=;
	h=Date:To:From:Subject:From;
	b=sWvNwas9pVjcr+hxc5o1gKfFobDEDhblJVfN2p9+VSTTDOqnaDKxcsmQuWvv+mtd3
	 AKEQOLyZklOOkcsEhxPTM4SHmXzEJmFbhW3K3uM1MJuKTBHoW72Thpj7aaVnpT7/er
	 Tk6jqrRgJTspbYMx3qbXxn37XiHqFI4ToARuACyk=
Date: Tue, 24 Jun 2025 16:13:47 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ccross@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch added to mm-new branch
Message-Id: <20250624231348.6C589C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, madvise: extract mm code from prctl_set_vma() to mm/madvise.c
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, madvise: extract mm code from prctl_set_vma() to mm/madvise.c
Date: Tue, 24 Jun 2025 15:03:46 +0200

Setting anon_name is done via madvise_set_anon_name() and behaves a lot of
like other madvise operations.  However, apparently because madvise() has
lacked the 4th argument and prctl() not, the userspace entry point has
been implemented via prctl(PR_SET_VMA, ...) and handled first by
prctl_set_vma().

Currently prctl_set_vma() lives in kernel/sys.c but setting the
vma->anon_name is mm-specific code so extract it to a new
set_anon_vma_name() function under mm.  mm/madvise.c seems to be the most
straightforward place as that's where madvise_set_anon_name() lives.  Stop
declaring the latter in mm.h and instead declare set_anon_vma_name().

Link: https://lkml.kernel.org/r/20250624-anon_name_cleanup-v2-2-600075462a11@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Colin Cross <ccross@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 +++++------
 kernel/sys.c       |   50 -----------------------------------------
 mm/madvise.c       |   52 +++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 58 insertions(+), 58 deletions(-)

--- a/include/linux/mm.h~mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec
+++ a/include/linux/mm.h
@@ -4059,14 +4059,14 @@ unsigned long wp_shared_mapping_range(st
 #endif
 
 #ifdef CONFIG_ANON_VMA_NAME
-int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
-			  unsigned long len_in,
-			  struct anon_vma_name *anon_name);
+int set_anon_vma_name(unsigned long addr, unsigned long size,
+		      const char __user *uname);
 #else
-static inline int
-madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
-		      unsigned long len_in, struct anon_vma_name *anon_name) {
-	return 0;
+static inline
+int set_anon_vma_name(unsigned long addr, unsigned long size,
+		      const char __user *uname)
+{
+	return -EINVAL;
 }
 #endif
 
--- a/kernel/sys.c~mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec
+++ a/kernel/sys.c
@@ -2343,54 +2343,14 @@ int __weak arch_lock_shadow_stack_status
 
 #define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LOCAL_THROTTLE)
 
-#ifdef CONFIG_ANON_VMA_NAME
-
-#define ANON_VMA_NAME_MAX_LEN		80
-#define ANON_VMA_NAME_INVALID_CHARS	"\\`$[]"
-
-static inline bool is_valid_name_char(char ch)
-{
-	/* printable ascii characters, excluding ANON_VMA_NAME_INVALID_CHARS */
-	return ch > 0x1f && ch < 0x7f &&
-		!strchr(ANON_VMA_NAME_INVALID_CHARS, ch);
-}
-
 static int prctl_set_vma(unsigned long opt, unsigned long addr,
 			 unsigned long size, unsigned long arg)
 {
-	struct mm_struct *mm = current->mm;
-	const char __user *uname;
-	struct anon_vma_name *anon_name = NULL;
 	int error;
 
 	switch (opt) {
 	case PR_SET_VMA_ANON_NAME:
-		uname = (const char __user *)arg;
-		if (uname) {
-			char *name, *pch;
-
-			name = strndup_user(uname, ANON_VMA_NAME_MAX_LEN);
-			if (IS_ERR(name))
-				return PTR_ERR(name);
-
-			for (pch = name; *pch != '\0'; pch++) {
-				if (!is_valid_name_char(*pch)) {
-					kfree(name);
-					return -EINVAL;
-				}
-			}
-			/* anon_vma has its own copy */
-			anon_name = anon_vma_name_alloc(name);
-			kfree(name);
-			if (!anon_name)
-				return -ENOMEM;
-
-		}
-
-		mmap_write_lock(mm);
-		error = madvise_set_anon_name(mm, addr, size, anon_name);
-		mmap_write_unlock(mm);
-		anon_vma_name_put(anon_name);
+		error = set_anon_vma_name(addr, size, (const char __user *)arg);
 		break;
 	default:
 		error = -EINVAL;
@@ -2399,14 +2359,6 @@ static int prctl_set_vma(unsigned long o
 	return error;
 }
 
-#else /* CONFIG_ANON_VMA_NAME */
-static int prctl_set_vma(unsigned long opt, unsigned long start,
-			 unsigned long size, unsigned long arg)
-{
-	return -EINVAL;
-}
-#endif /* CONFIG_ANON_VMA_NAME */
-
 static inline unsigned long get_current_mdwe(void)
 {
 	unsigned long ret = 0;
--- a/mm/madvise.c~mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec
+++ a/mm/madvise.c
@@ -134,8 +134,8 @@ static int replace_anon_vma_name(struct
 	return 0;
 }
 
-int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
-			  unsigned long len_in, struct anon_vma_name *anon_name)
+static int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
+		unsigned long len_in, struct anon_vma_name *anon_name)
 {
 	unsigned long end;
 	unsigned long len;
@@ -2096,3 +2096,51 @@ free_iov:
 out:
 	return ret;
 }
+
+#ifdef CONFIG_ANON_VMA_NAME
+
+#define ANON_VMA_NAME_MAX_LEN		80
+#define ANON_VMA_NAME_INVALID_CHARS	"\\`$[]"
+
+static inline bool is_valid_name_char(char ch)
+{
+	/* printable ascii characters, excluding ANON_VMA_NAME_INVALID_CHARS */
+	return ch > 0x1f && ch < 0x7f &&
+		!strchr(ANON_VMA_NAME_INVALID_CHARS, ch);
+}
+
+int set_anon_vma_name(unsigned long addr, unsigned long size,
+		      const char __user *uname)
+{
+	struct anon_vma_name *anon_name = NULL;
+	struct mm_struct *mm = current->mm;
+	int error;
+
+	if (uname) {
+		char *name, *pch;
+
+		name = strndup_user(uname, ANON_VMA_NAME_MAX_LEN);
+		if (IS_ERR(name))
+			return PTR_ERR(name);
+
+		for (pch = name; *pch != '\0'; pch++) {
+			if (!is_valid_name_char(*pch)) {
+				kfree(name);
+				return -EINVAL;
+			}
+		}
+		/* anon_vma has its own copy */
+		anon_name = anon_vma_name_alloc(name);
+		kfree(name);
+		if (!anon_name)
+			return -ENOMEM;
+	}
+
+	mmap_write_lock(mm);
+	error = madvise_set_anon_name(mm, addr, size, anon_name);
+	mmap_write_unlock(mm);
+	anon_vma_name_put(anon_name);
+
+	return error;
+}
+#endif
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-madvise-simplify-anon_name-handling.patch
mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch
mm-madvise-move-madvise_set_anon_name-down-the-file.patch
mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch

