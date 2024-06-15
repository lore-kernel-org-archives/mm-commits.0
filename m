Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F4B1FBA
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 01:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718413958; cv=none; b=FrggDwdjRfr0p4xIjEjItH3r2ZApx5odr+7lutTCQaVMaVNjhhBaNzFGifRsGH9bXzK3DsbZSEkT8RsrVZ2tiyU/MdYge14Fng4jOa+SIA+4GbllvRyjXA9PTiXmCWDLPETr7sMYHZ2qwd0OF+W17BOQYYIUhQ5ASaYB6l6IaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718413958; c=relaxed/simple;
	bh=JeLNoTJMRGbIpDQ8j70PIVN4rGyFL+PJFEOs8vnTi5E=;
	h=Date:To:From:Subject:Message-Id; b=mMf0UDB7cjwy0hgqkWhCKBKff+LZsReSYMm6XKEwuEJ6oIXUkz0aQxWmechLAvjTf8XBIS3Ke8KRZabIyy7sBrioNfTkPGJqxQXYWkRkVIn3N/3cjzjjzXgshw1rdPIZb3Y68tbDZGbrdtpnFDZPAwlKKMiDdva/GPDOrSQfBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ugKyaV4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ugKyaV4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED42C2BD10;
	Sat, 15 Jun 2024 01:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718413957;
	bh=JeLNoTJMRGbIpDQ8j70PIVN4rGyFL+PJFEOs8vnTi5E=;
	h=Date:To:From:Subject:From;
	b=ugKyaV4+LdG3Q8nADg4IVOCho/4oBYgZEEa4Nus9Aq80FgqIPhTsu8IbPz+9EPloA
	 vJb/aqHQnT34XzgUaZdLAZ1MgzAN99G155tgPigypmuAeHXHf+F+C4gMOVgfOPWM7B
	 FVs5ii9cowakAhFo4NdaLT65AOe9JpSARUOkpxjc=
Date: Fri, 14 Jun 2024 18:12:36 -0700
To: mm-commits@vger.kernel.org,sroettger@google.com,rdunlap@infradead.org,keescook@chromium.org,jorgelo@chromium.org,jannh@google.com,david@redhat.com,adhemerval.zanella@linaro.org,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-pid-smaps-add-mseal-info-for-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20240615011237.6ED42C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: /proc/pid/smaps: add mseal info for vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-pid-smaps-add-mseal-info-for-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-pid-smaps-add-mseal-info-for-vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jeff Xu <jeffxu@chromium.org>
Subject: /proc/pid/smaps: add mseal info for vma
Date: Fri, 14 Jun 2024 23:20:14 +0000

Add sl in /proc/pid/smaps to indicate vma is sealed

Link: https://lkml.kernel.org/r/20240614232014.806352-2-jeffxu@google.com
Fixes: 8be7258aad44 ("mseal: add mseal syscall")
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
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

mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch
mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch
mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch
proc-pid-smaps-add-mseal-info-for-vma.patch

