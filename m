Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FFF2505CE
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160872; cv=none; b=kb1dMixUGk3HLCCqqhC7T9l5xC5Jpi8jA6vaXh4RTm/BBYfEymSJdJZq3wV69ExnAfZdVpfG8JCzTYMfBiNNfkLDtLTuJ0Ye8zKVYxui68j+9VwGVANU7Tq60kzabmu1JvZEcKVU1eMU2UIF4tG1bwgxwigm/qLfat09+FRstB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160872; c=relaxed/simple;
	bh=zQmUM0ET6SPGhVpwtPF1PELtByhYXuMiKi7MrbFUzEA=;
	h=Date:To:From:Subject:Message-Id; b=qQm1zVZ98/jGQgZ5Y97lOvLdL8+lNZOJS9MCysoxXGi9fkyGbwn4NR/VrzR7C9b/e9ic2WtXlQ6NMgoTMUE0DxNQS8n4ds/nDHzdlpsQ839Vire+D1o5IHVB+xzDvhBI34u25Licz1+qlLlNoo77Rx3QF+MVwDJJZDRW2ozI/6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mKkJt5LC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mKkJt5LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA89C4CEEF;
	Sat,  2 Aug 2025 18:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160871;
	bh=zQmUM0ET6SPGhVpwtPF1PELtByhYXuMiKi7MrbFUzEA=;
	h=Date:To:From:Subject:From;
	b=mKkJt5LC9lC0173t/deGPL0PIqtwtPww2ckPsRKbTqcejHdvCFFRqfVysPNhTw/oh
	 SFdW/epJyP03qIgtqBghR2jolhQBY9jWTPSL8Yi1Ki400AE5oBCEetXNCxsrhJnuf7
	 RDmFhX0jKS1LwckwyymRfniJ8fC3kkZiQ5zxVa7k=
Date: Sat, 02 Aug 2025 11:54:31 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch removed from -mm tree
Message-Id: <20250802185431.CDA89C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: execmem: move execmem_force_rw() and execmem_restore_rox() before use
has been removed from the -mm tree.  Its filename was
     execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: execmem: move execmem_force_rw() and execmem_restore_rox() before use
Date: Sun, 13 Jul 2025 10:17:26 +0300

to avoid static declarations.

Link: https://lkml.kernel.org/r/20250713071730.4117334-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

--- a/mm/execmem.c~execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use
+++ a/mm/execmem.c
@@ -137,6 +137,27 @@ err_restore:
 	return err;
 }
 
+static int execmem_force_rw(void *ptr, size_t size)
+{
+	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	unsigned long addr = (unsigned long)ptr;
+	int ret;
+
+	ret = set_memory_nx(addr, nr);
+	if (ret)
+		return ret;
+
+	return set_memory_rw(addr, nr);
+}
+
+int execmem_restore_rox(void *ptr, size_t size)
+{
+	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	unsigned long addr = (unsigned long)ptr;
+
+	return set_memory_rox(addr, nr);
+}
+
 static void execmem_cache_clean(struct work_struct *work)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
@@ -328,8 +349,6 @@ static inline void *pending_free_clear(v
 	return (void *)((unsigned long)ptr & ~PENDING_FREE_MASK);
 }
 
-static int execmem_force_rw(void *ptr, size_t size);
-
 static int __execmem_cache_free(struct ma_state *mas, void *ptr, gfp_t gfp_mask)
 {
 	size_t size = mas_range_len(mas);
@@ -415,27 +434,6 @@ static bool execmem_cache_free(void *ptr
 	return true;
 }
 
-static int execmem_force_rw(void *ptr, size_t size)
-{
-	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	unsigned long addr = (unsigned long)ptr;
-	int ret;
-
-	ret = set_memory_nx(addr, nr);
-	if (ret)
-		return ret;
-
-	return set_memory_rw(addr, nr);
-}
-
-int execmem_restore_rox(void *ptr, size_t size)
-{
-	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	unsigned long addr = (unsigned long)ptr;
-
-	return set_memory_rox(addr, nr);
-}
-
 #else /* CONFIG_ARCH_HAS_EXECMEM_ROX */
 /*
  * when ROX cache is not used the permissions defined by architectures for
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch

