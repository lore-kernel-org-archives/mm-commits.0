Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D235638F9A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 03:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287556; cv=none; b=Yk9adH42N26ILM8wj6UhmHtp+aqTmnB2iWZdvRm7WWx6zUccc6Yhg3ZJAaQws34XUtp+AMzrGPyn1McH0y8m/4gfmEG3Wc3yIJ0AOwRw005ZZ6G09SmNWuD9eVELLUICRaSUtZgf0HZ4Q61+A1EgVMIslytQrxOdMaBuwVEYZZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287556; c=relaxed/simple;
	bh=c8PA3qIBNAInK1+InB3wYEdaU6jhiMh5fPNEAtr5Ofc=;
	h=Date:To:From:Subject:Message-Id; b=Sh0Yq29AjfIfFnPlWPtVUa3wG7R7XhjenMPkVCp/CxMe5Lxd/7fF7j/YiwI+cRVdaIozmoSjFhOHPhTjUScmHcFf9+OblskJ5l1uw9MStZ+ohX6JV5qw8XgRfIG7HgB+H9V7ggE2YwCb5dvPih3w9XdW0VVejTX3SAjsEcWiFvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q3EVMqYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q3EVMqYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E061C32789;
	Tue, 25 Jun 2024 03:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287555;
	bh=c8PA3qIBNAInK1+InB3wYEdaU6jhiMh5fPNEAtr5Ofc=;
	h=Date:To:From:Subject:From;
	b=q3EVMqYZo1x+la+ePb3EiwmX0soIoIrW967pMDG4+LrklFBhvCz0H408dxnufjezv
	 RzAYDn/kKIILCPQF8Zu69/OklAhfXITrSSvguzZwbX7WZ5YaqBIfj+Qaxye+a4tiGk
	 NIy48tnP+jmrSSD+WsxZewpa1xo0go9Ity8L27XM=
Date: Mon, 24 Jun 2024 20:52:34 -0700
To: mm-commits@vger.kernel.org,sroettger@google.com,rdunlap@infradead.org,keescook@chromium.org,jorgelo@chromium.org,jannh@google.com,david@redhat.com,adhemerval.zanella@linaro.org,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-pid-smaps-add-mseal-info-for-vma.patch removed from -mm tree
Message-Id: <20240625035235.3E061C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: /proc/pid/smaps: add mseal info for vma
has been removed from the -mm tree.  Its filename was
     proc-pid-smaps-add-mseal-info-for-vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: /proc/pid/smaps: add mseal info for vma
Date: Fri, 14 Jun 2024 23:20:14 +0000

Add sl in /proc/pid/smaps to indicate vma is sealed

Link: https://lkml.kernel.org/r/20240614232014.806352-2-jeffxu@google.com
Fixes: 8be7258aad44 ("mseal: add mseal syscall")
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Röttger <sroettger@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    1 +
 fs/proc/task_mmu.c                 |    3 +++
 include/linux/mm.h                 |    5 +++++
 mm/internal.h                      |    5 -----
 4 files changed, 9 insertions(+), 5 deletions(-)

--- a/Documentation/filesystems/proc.rst~proc-pid-smaps-add-mseal-info-for-vma
+++ a/Documentation/filesystems/proc.rst
@@ -571,6 +571,7 @@ encoded manner. The codes are the follow
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
     ss    shadow stack page
+    sl    sealed
     ==    =======================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
--- a/fs/proc/task_mmu.c~proc-pid-smaps-add-mseal-info-for-vma
+++ a/fs/proc/task_mmu.c
@@ -707,6 +707,9 @@ static void show_smap_vma_flags(struct s
 #ifdef CONFIG_X86_USER_SHADOW_STACK
 		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
+#ifdef CONFIG_64BIT
+		[ilog2(VM_SEALED)] = "sl",
+#endif
 	};
 	size_t i;
 
--- a/include/linux/mm.h~proc-pid-smaps-add-mseal-info-for-vma
+++ a/include/linux/mm.h
@@ -406,6 +406,11 @@ extern unsigned int kobjsize(const void
 #define VM_ALLOW_ANY_UNCACHED		VM_NONE
 #endif
 
+#ifdef CONFIG_64BIT
+/* VM is sealed, in vm_flags */
+#define VM_SEALED	_BITUL(63)
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
--- a/mm/internal.h~proc-pid-smaps-add-mseal-info-for-vma
+++ a/mm/internal.h
@@ -1435,11 +1435,6 @@ unsigned long shrink_slab(gfp_t gfp_mask
 			  int priority);
 
 #ifdef CONFIG_64BIT
-/* VM is sealed, in vm_flags */
-#define VM_SEALED	_BITUL(63)
-#endif
-
-#ifdef CONFIG_64BIT
 static inline int can_do_mseal(unsigned long flags)
 {
 	if (flags)
_

Patches currently in -mm which might be from jeffxu@chromium.org are


