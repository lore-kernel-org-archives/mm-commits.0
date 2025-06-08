Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89438D27E
	for <mm-commits@vger.kernel.org>; Sun,  8 Jun 2025 22:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749421927; cv=none; b=OkrR7c6C1MR9Y9FXMqVWzs2A9gMJ+KO6hOX598R+RPSYRhtgiG5wIou2OtLLdRtA71hDLs+UPpGBjvBWHTBFFcR6mLpwEydioaLfq0BFLKNH8V3Ik2oVq55uytTZe2iOnod2ijKS46Hy0wFBc3rNP6oAjXPcaMOOGrsBWAVBjN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749421927; c=relaxed/simple;
	bh=scwopm//D0Qez4RWhbFalWwrfn7pztYQgsZAg1UXXrc=;
	h=Date:To:From:Subject:Message-Id; b=YFZNZrpXmcaqcHWbeFF5/jg8sRCdUMBmAKXcyeZNjA6IAYUnPTw3znPJnycTeGPmz8B4Mb5vpQkPKAxr20e0GHDiFCE3toE+ItFXB24UswpfTJRPpKJn8cyC7Lm2queuUQtuQdhv5Fb/HbMWI+SvD+SHWBe+t5qL/WBayCbV5x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I60sS216; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I60sS216"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F03C4CEEE;
	Sun,  8 Jun 2025 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749421927;
	bh=scwopm//D0Qez4RWhbFalWwrfn7pztYQgsZAg1UXXrc=;
	h=Date:To:From:Subject:From;
	b=I60sS216jbdQOjYz1iuyxBXMrX13f+C9JJINVLFrTKl/ZK6TjxTz0vJH8l6+CUsNX
	 5/33XTJ9xZ1wGlEHw2qDqTJ/m9vAMo/+YZJmqh0Hwz9Cd4BjMnWZbHgl9IAzv/Zy1B
	 fmzaT9oujxDZGUdX45XvzvGsK2WZIxPsUNwASxqU=
Date: Sun, 08 Jun 2025 15:32:06 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,liam.howlett@oracle.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,broonie@kernel.org,andrii@kernel.org,wangfushuai@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch removed from -mm tree
Message-Id: <20250608223207.02F03C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: add VM_SHADOW_STACK for arm64 when support GCS
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: wangfushuai <wangfushuai@baidu.com>
Subject: fs/proc/task_mmu: add VM_SHADOW_STACK for arm64 when support GCS
Date: Sat, 7 Jun 2025 21:15:25 +0800

The recent commit adding VM_SHADOW_STACK for arm64 GCS did not update
the /proc/[pid]/smaps display logic to show the "ss" flag for GCS pages.
This patch adds the necessary condition to display "ss" flag.

[akpm@linux-foundation.org: simplify ifdeffery]
Link: https://lkml.kernel.org/r/20250607131525.76746-1-wangfushuai@baidu.com
Fixes: ae80e1629aea ("mm: Define VM_SHADOW_STACK for arm64 when we support GCS")
Signed-off-by: wangfushuai <wangfushuai@baidu.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs
+++ a/fs/proc/task_mmu.c
@@ -991,7 +991,7 @@ static void show_smap_vma_flags(struct s
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 		[ilog2(VM_UFFD_MINOR)]	= "ui",
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
-#ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
+#if defined(CONFIG_ARCH_HAS_USER_SHADOW_STACK) || defined (CONFIG_ARM64_GCS)
 		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
 #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
_

Patches currently in -mm which might be from wangfushuai@baidu.com are

docs-proc-update-vmflags-documentation-in-smaps.patch

