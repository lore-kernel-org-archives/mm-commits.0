Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC6157460
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713994884; cv=none; b=jrGd1AnWKI0UwX0aqxremrTxqSqBPyO4+KFHZ2iN/72zoiuYyriNJoq7XmvK5O7fxnWdlF9mVf+KDKo9QfuxhPJtgk/9hbbBfvDipJkKekA8O4aYKZXbeMgas0C/RKbksJK3ZERHCKsyxawZgXu82CLMN1z5syZ62qkMWkJkBMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713994884; c=relaxed/simple;
	bh=rtHre1LYY3ou8F8A6X+0N1bb2qKlkjmuFMJGWs0k+Ko=;
	h=Date:To:From:Subject:Message-Id; b=OEotn4QxtxJGOZrBwe4QyNxpmiWtwBtJgUCODwJYTXksAZ5HkBYxvPh+qDUACC7ZlWH/vZoSm7mB6CK19U8FudVvsEmV9fcCaF58YRW6836H41E+e46hhluM5krsNmRqTbgj08y/aE7nj3Xwk8UebMJ9uXMt6VHlO0cHQNcO+YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hjRr22PC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hjRr22PC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F02C113CD;
	Wed, 24 Apr 2024 21:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713994884;
	bh=rtHre1LYY3ou8F8A6X+0N1bb2qKlkjmuFMJGWs0k+Ko=;
	h=Date:To:From:Subject:From;
	b=hjRr22PC8F5nnYIVz9T4OH+Pncp5OxFtZMU7g0J/F2/R6NoUOhY8ko2qGiDZYbHYb
	 6LflgzfdhxAMg1sqOAscjiJn9Tfr2LYeiLNDntNAoECmjKbgr8fntV41Qi961xTBnH
	 9ePRvj4zC9h3fCxsMgJxTFIDu1zur2n4PCRAMQ3w=
Date: Wed, 24 Apr 2024 14:41:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,torvalds@linux-foundation.org,surenb@google.com,sroettger@google.com,shuah@kernel.org,pedro.falcato@gmail.com,Liam.Howlett@oracle.com,keescook@chromium.org,jorgelo@chromium.org,jeffxu@google.com,javier.carrasco.cruz@gmail.com,jannh@google.com,groeck@chromium.org,gregkh@linuxfoundation.org,dave.hansen@intel.com,corbet@lwn.net,amer.shanawany@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-add-mseal-syscall-fix.patch added to mm-unstable branch
Message-Id: <20240424214124.50F02C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal: add branch prediction hint
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-add-mseal-syscall-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-add-mseal-syscall-fix.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal: add branch prediction hint
Date: Tue, 23 Apr 2024 19:28:25 +0000

It is unlikely that application calls mm syscall, such as mprotect, on
already sealed mappings, adding branch prediction hint.

Link: https://lkml.kernel.org/r/20240423192825.1273679-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Suggested-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Amer Al Shanawany <amer.shanawany@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Röttger <sroettger@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c  |    2 +-
 mm/mmap.c     |    4 ++--
 mm/mprotect.c |    2 +-
 mm/mremap.c   |    4 ++--
 mm/mseal.c    |    6 +++---
 5 files changed, 9 insertions(+), 9 deletions(-)

--- a/mm/madvise.c~mseal-add-mseal-syscall-fix
+++ a/mm/madvise.c
@@ -1436,7 +1436,7 @@ int do_madvise(struct mm_struct *mm, uns
 	 * Check if the address range is sealed for do_madvise().
 	 * can_modify_mm_madv assumes we have acquired the lock on MM.
 	 */
-	if (!can_modify_mm_madv(mm, start, end, behavior)) {
+	if (unlikely(!can_modify_mm_madv(mm, start, end, behavior))) {
 		error = -EPERM;
 		goto out;
 	}
--- a/mm/mmap.c~mseal-add-mseal-syscall-fix
+++ a/mm/mmap.c
@@ -2740,7 +2740,7 @@ int do_vmi_munmap(struct vma_iterator *v
 	 * Prevent unmapping a sealed VMA.
 	 * can_modify_mm assumes we have acquired the lock on MM.
 	 */
-	if (!can_modify_mm(mm, start, end))
+	if (unlikely(!can_modify_mm(mm, start, end)))
 		return -EPERM;
 
 	 /* arch_unmap() might do unmaps itself.  */
@@ -3163,7 +3163,7 @@ int do_vma_munmap(struct vma_iterator *v
 	 * Prevent unmapping a sealed VMA.
 	 * can_modify_mm assumes we have acquired the lock on MM.
 	 */
-	if (!can_modify_mm(mm, start, end))
+	if (unlikely(!can_modify_mm(mm, start, end)))
 		return -EPERM;
 
 	arch_unmap(mm, start, end);
--- a/mm/mprotect.c~mseal-add-mseal-syscall-fix
+++ a/mm/mprotect.c
@@ -749,7 +749,7 @@ static int do_mprotect_pkey(unsigned lon
 	 * checking if memory is sealed.
 	 * can_modify_mm assumes we have acquired the lock on MM.
 	 */
-	if (!can_modify_mm(current->mm, start, end)) {
+	if (unlikely(!can_modify_mm(current->mm, start, end))) {
 		error = -EPERM;
 		goto out;
 	}
--- a/mm/mremap.c~mseal-add-mseal-syscall-fix
+++ a/mm/mremap.c
@@ -912,7 +912,7 @@ static unsigned long mremap_to(unsigned
 	 *
 	 * can_modify_mm assumes we have acquired the lock on MM.
 	 */
-	if (!can_modify_mm(mm, addr, addr + old_len))
+	if (unlikely(!can_modify_mm(mm, addr, addr + old_len)))
 		return -EPERM;
 
 	if (flags & MREMAP_FIXED) {
@@ -1087,7 +1087,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	 * Place can_modify_mm here so we can keep the logic related to
 	 * shrink/expand together.
 	 */
-	if (!can_modify_mm(mm, addr, addr + old_len)) {
+	if (unlikely(!can_modify_mm(mm, addr, addr + old_len))) {
 		ret = -EPERM;
 		goto out;
 	}
--- a/mm/mseal.c~mseal-add-mseal-syscall-fix
+++ a/mm/mseal.c
@@ -32,7 +32,7 @@ static inline void set_vma_sealed(struct
  */
 static bool can_modify_vma(struct vm_area_struct *vma)
 {
-	if (vma_is_sealed(vma))
+	if (unlikely(vma_is_sealed(vma)))
 		return false;
 
 	return true;
@@ -75,7 +75,7 @@ bool can_modify_mm(struct mm_struct *mm,
 
 	/* going through each vma to check. */
 	for_each_vma_range(vmi, vma, end) {
-		if (!can_modify_vma(vma))
+		if (unlikely(!can_modify_vma(vma)))
 			return false;
 	}
 
@@ -100,7 +100,7 @@ bool can_modify_mm_madv(struct mm_struct
 
 	/* going through each vma to check. */
 	for_each_vma_range(vmi, vma, end)
-		if (is_ro_anon(vma) && !can_modify_vma(vma))
+		if (unlikely(is_ro_anon(vma) && !can_modify_vma(vma)))
 			return false;
 
 	/* Allow by default. */
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mseal-wire-up-mseal-syscall.patch
mseal-add-mseal-syscall.patch
mseal-add-mseal-syscall-fix.patch
selftest-mm-mseal-memory-sealing.patch
mseal-add-documentation.patch
selftest-mm-mseal-read-only-elf-memory-segment.patch
selftest-mm-mseal-read-only-elf-memory-segment-fix.patch
selftest-mm-mseal-read-only-elf-memory-segment-fix-3.patch

