Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B485A1EE7B7
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449988; cv=none; b=j91702ZKqfDhRLvzy5DJugYMQBd2zKziGMcMMGwEdMWH19oFLhuku2NAeLwne8rYSXctvDVMkaf904mAuKYX+N+qajN3/G5esGxU6uWXa0JsZZYk1XJljDWiXAwbdmMPpz1X++l0hxabOkmygp8ErzCev9WO7XwcOtZFqMV1Ets=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449988; c=relaxed/simple;
	bh=hjDpnQQtbRxYDE2XJEN7Esl9R9qwLCSvm5psRXpIS1Y=;
	h=Date:To:From:Subject:Message-Id; b=MjUZ0ReLIxnrGbWVzu7NRRa6W3SxMFkqZeU3V+ScjmJIFjCaIqWWu0KgDG04T22FdAJeCMfTWEJ12ssaCBX9X5DwucHk/yzcYBBbOhYTvM/MaS6KTo1is+NImJza3d43qAvIPOMuJF5Ax2wWontRTovN4Ot4To7uCwZkkmeuT/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ChZdJ7G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ChZdJ7G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8831BC4CEE3;
	Sun, 13 Jul 2025 23:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449988;
	bh=hjDpnQQtbRxYDE2XJEN7Esl9R9qwLCSvm5psRXpIS1Y=;
	h=Date:To:From:Subject:From;
	b=ChZdJ7G8ebfxcZK0bEBT3KMBscY/+Y+aLZhYJLKPNgPnaPnG3y9kCRCZPOPb08P8b
	 dflDXdxAXLJVoDvi2R7ZvwluUQq+12iIpfmd4OrqwQZwDmQbwlZlLaFb822thTAMhW
	 FUWAcX+dCK2BLfplQ6wwtoPExiRajQPnU7KPw/uo=
Date: Sun, 13 Jul 2025 16:39:48 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ccross@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch removed from -mm tree
Message-Id: <20250713233948.8831BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, madvise: extract mm code from prctl_set_vma() to mm/madvise.c
has been removed from the -mm tree.  Its filename was
     mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch
mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch

