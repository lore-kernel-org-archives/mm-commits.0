Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B238F40
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727907907; cv=none; b=V160lCkEfMyBQiVvJsVp2hRBcgUQ7DdGxDsmZ7P2JYp2lQQEBT0+yIIxx8yzX2WRWBqlgH3ox6p9fwBsn3DRzowVPQAJU3Fi6yLcQY2bDwSFRgwNfSKl7rHfAQEaX9si4TM6b3NFrA0Nm8bO7ho9SXp8xU9VnA2cGkfh+RDjhdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727907907; c=relaxed/simple;
	bh=cD9cvOMLaiXNdZIc8+qAyUbSFgWoZBslhE/F8pLi/D0=;
	h=Date:To:From:Subject:Message-Id; b=fGqK7n/UKkjd9JSD+P8rrf2bgvvCjEFdhkDpGwbdvKYqN5u1hhF774UBzNSkTgUdQTZh26cmMRaHN/SPvx1+/PWfofiXp8dCdDWbvuX8mYzBzjrUuWMjObJZNy3vlYoo7+VrfrWfFYVqCrqwTJ8l6GZ0gSUocwYMYK3cvx+ZVX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XYejNivq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XYejNivq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E50C4CEC2;
	Wed,  2 Oct 2024 22:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727907906;
	bh=cD9cvOMLaiXNdZIc8+qAyUbSFgWoZBslhE/F8pLi/D0=;
	h=Date:To:From:Subject:From;
	b=XYejNivqLogLxOHnIj3GSorNDEpZuMqG7PvFHST6bN1Rqh04H5YBL3LLL4/MCoLw1
	 w0DvuHMxcXXAMpoaK+JWIm9NexLVUPouXlDN8oAOTudRl8vbJATE2OFMCa9JUd/wJH
	 Ef/VngWi7RzRe24XpkhZ+ioITa+7v329EDl9vEzc=
Date: Wed, 02 Oct 2024 15:25:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,torvalds@linux-foundation.org,surenb@google.com,sroettger@google.com,rdunlap@infradead.org,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,keescook@chromium.org,jorgelo@chromium.org,jannh@google.com,groeck@chromium.org,gregkh@linuxfoundation.org,enh@google.com,corbet@lwn.net,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-update-msealrst-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20241002222506.B9E50C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal: update mseal.rst
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mseal-update-msealrst-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-update-msealrst-v2.patch

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
Subject: mseal: update mseal.rst
Date: Tue, 1 Oct 2024 00:26:27 +0000

update according to Randy Dunlap's comments

Link: https://lkml.kernel.org/r/20241001002628.2239032-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Cc: Elliott Hughes <enh@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Röttger <sroettger@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |   44 ++++++++++++------------
 1 file changed, 23 insertions(+), 21 deletions(-)

--- a/Documentation/userspace-api/mseal.rst~mseal-update-msealrst-v2
+++ a/Documentation/userspace-api/mseal.rst
@@ -27,7 +27,7 @@ SYSCALL
 =======
 mseal syscall signature
 -----------------------
-   **int** mseal(**void \*** addr, **size_t** len, **unsigned long** flags)
+   ``int mseal(void \* addr, size_t len, unsigned long flags)``
 
    **addr**/**len**: virtual memory address range.
       The address range set by **addr**/**len** must meet:
@@ -62,10 +62,10 @@ mseal syscall signature
         memory range could happen. However, those cases should be rare.
 
    **Architecture support**:
-      mseal only works on 64-bit CPUs, not 32-bit CPU.
+      mseal only works on 64-bit CPUs, not 32-bit CPUs.
 
    **Idempotent**:
-      users can call mseal multiple times, mseal on an already sealed memory
+      users can call mseal multiple times. mseal on an already sealed memory
       is a no-action (not error).
 
    **no munseal**
@@ -75,8 +75,8 @@ mseal syscall signature
 
 Blocked mm syscall for sealed mapping
 -------------------------------------
-   It might be imporant to note: **once the mapping is sealed, it will
-   stay in the process's memory till the process terminates**.
+   It might be important to note: **once the mapping is sealed, it will
+   stay in the process's memory until the process terminates**.
 
    Example::
 
@@ -100,9 +100,9 @@ Blocked mm syscall for sealed mapping
    overwrite the existing mapping with another mapping.
 
    mprotect and pkey_mprotect are blocked because they changes the
-   protection bits (rwx) of the mapping.
+   protection bits (RWX) of the mapping.
 
-   Some destructive madvice behaviors (MADV_DONTNEED, MADV_FREE,
+   Some destructive madvise behaviors (MADV_DONTNEED, MADV_FREE,
    MADV_DONTNEED_LOCKED, MADV_FREE, MADV_DONTFORK, MADV_WIPEONFORK)
    for anonymous memory, when users don't have write permission to the
    memory. Those behaviors can alter region contents by discarding pages,
@@ -118,25 +118,25 @@ Blocked mm syscall for sealed mapping
         VMAs before reaching the sealed VMA and return -EPERM.
       - mmap and mremap: undefined behavior.
 
-Use cases:
-==========
+Use cases
+=========
 - glibc:
   The dynamic linker, during loading ELF executables, can apply sealing to
   mapping segments.
 
-- Chrome browser: protect some security sensitive data-structures.
+- Chrome browser: protect some security sensitive data structures.
 
-Don't use mseal on:
-===================
+When not to use mseal
+=====================
 Applications can apply sealing to any virtual memory region from userspace,
 but it is *crucial to thoroughly analyze the mapping's lifetime* prior to
 apply the sealing. This is because the sealed mapping *won’t be unmapped*
-till the process terminates or the exec system call is invoked.
+until the process terminates or the exec system call is invoked.
 
 For example:
    - aio/shm
      aio/shm can call mmap and  munmap on behalf of userspace, e.g.
-     ksys_shmdt() in shm.c. The lifetime of those mapping are not tied to
+     ksys_shmdt() in shm.c. The lifetimes of those mapping are not tied to
      the lifetime of the process. If those memories are sealed from userspace,
      then munmap will fail, causing leaks in VMA address space during the
      lifetime of the process.
@@ -145,8 +145,10 @@ For example:
      Don't use mseal on the memory ptr return from malloc().
      malloc() is implemented by allocator, e.g. by glibc. Heap manager might
      allocate a ptr from brk or mapping created by mmap.
-     If app calls mseal on ptr returned from malloc(), this can affect the heap
-     manager's ability to manage the mappings, the outcome is non-deterministic.
+     If an app calls mseal on a ptr returned from malloc(), this can affect
+     the heap manager's ability to manage the mappings; the outcome is
+     non-deterministic.
+
      Example::
 
         ptr = malloc(size);
@@ -155,10 +157,10 @@ For example:
         /* free will success, allocator can't shrink heap lower than ptr */
         free(ptr);
 
-mseal doesn't block:
-====================
+mseal doesn't block
+===================
 In a nutshell, mseal blocks certain mm syscall from modifying some of VMA's
-attributes, such as protection bits (rwx). Sealed mappings doesn't mean the
+attributes, such as protection bits (RWX). Sealed mappings doesn't mean the
 memory is immutable.
 
 As Jann Horn pointed out in [3], there are still a few ways to write
@@ -173,8 +175,8 @@ Those cases are:
 The idea that inspired this patch comes from Stephen Röttger’s work in V8
 CFI [4]. Chrome browser in ChromeOS will be the first user of this API.
 
-Reference:
-==========
+Reference
+=========
 - [1] https://github.com/apple-oss-distributions/xnu/blob/1031c584a5e37aff177559b9f69dbd3c8c3fd30a/osfmk/mach/vm_statistics.h#L274
 - [2] https://man.openbsd.org/mimmutable.2
 - [3] https://lore.kernel.org/lkml/CAG48ez3ShUYey+ZAFsU2i1RpQn0a5eOs2hzQ426FkcgnfUGLvA@mail.gmail.com
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mseal-update-msealrst.patch
mseal-update-msealrst-v2.patch

