Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1D02BAEF
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 02:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716518453; cv=none; b=p8xJ/WIXNh3hveZ3aaVFxeDp+gC1PvdXY/RUMecgMULz8NkVuYmxe/TX9uDO3JAV9niL7j5BZSybFDE6dMwX0OaUw13tVNoqT4f4Of189dhhKAMxGL7EMcsEJM2Xpd0RCfGhR7FUs9LLczo510YEysaYyl1F7LOu2+zuqVqTPdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716518453; c=relaxed/simple;
	bh=ICKeMTGKYO+17JUPTMFav3G3m3rzYiU1W/8hhVRbXmw=;
	h=Date:To:From:Subject:Message-Id; b=FvLX4a+C7AYU9wmGiSHfyJvO9SSEt4Qd/Rrm/iK7QS+3KeAo2C1tkVoidEfWWt3FUJwiz0Dgi+dp1xuEoO5x7b846pzOfh0PwomSVW+TitYd1VDVINKs+es4UU2mmkccLPH7jo4Nnl5mWLS57SncJMl1dC+DKbcYDxf4ygYYolg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KrxLxRD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KrxLxRD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEA9C32781;
	Fri, 24 May 2024 02:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716518453;
	bh=ICKeMTGKYO+17JUPTMFav3G3m3rzYiU1W/8hhVRbXmw=;
	h=Date:To:From:Subject:From;
	b=KrxLxRD84VLiDKTHYO+aXvNGuvtWud04kzB2WundLxITpZ/iMIJsZpe6/rVhw7U+J
	 Pb4RML+Y2bQY/PEzW1dvDTxUq+rQKmdq3SgdbS6RCEPZQfl1UWgL4G0tkux38HicRT
	 L4xJx6wXC8KRlWXJ22pJst58ZZe+Mroc4qWzR5s4=
Date: Thu, 23 May 2024 19:40:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,torvalds@linux-foundation.org,surenb@google.com,sroettger@google.com,shuah@kernel.org,pedro.falcato@gmail.com,Liam.Howlett@oracle.com,keescook@chromium.org,jorgelo@chromium.org,jeffxu@google.com,javier.carrasco.cruz@gmail.com,jannh@google.com,groeck@chromium.org,gregkh@linuxfoundation.org,dave.hansen@intel.com,corbet@lwn.net,amer.shanawany@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-add-documentation.patch removed from -mm tree
Message-Id: <20240524024053.0DEA9C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal: add documentation
has been removed from the -mm tree.  Its filename was
     mseal-add-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal: add documentation
Date: Mon, 15 Apr 2024 16:35:23 +0000

Add documentation for mseal().

Link: https://lkml.kernel.org/r/20240415163527.626541-5-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Stephen Röttger <sroettger@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Amer Al Shanawany <amer.shanawany@gmail.com>
Cc: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/index.rst |    1 
 Documentation/userspace-api/mseal.rst |  199 ++++++++++++++++++++++++
 2 files changed, 200 insertions(+)

--- a/Documentation/userspace-api/index.rst~mseal-add-documentation
+++ a/Documentation/userspace-api/index.rst
@@ -20,6 +20,7 @@ System calls
    futex2
    ebpf/index
    ioctl/index
+   mseal
 
 Security-related interfaces
 ===========================
--- /dev/null
+++ a/Documentation/userspace-api/mseal.rst
@@ -0,0 +1,199 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+Introduction of mseal
+=====================
+
+:Author: Jeff Xu <jeffxu@chromium.org>
+
+Modern CPUs support memory permissions such as RW and NX bits. The memory
+permission feature improves security stance on memory corruption bugs, i.e.
+the attacker can’t just write to arbitrary memory and point the code to it,
+the memory has to be marked with X bit, or else an exception will happen.
+
+Memory sealing additionally protects the mapping itself against
+modifications. This is useful to mitigate memory corruption issues where a
+corrupted pointer is passed to a memory management system. For example,
+such an attacker primitive can break control-flow integrity guarantees
+since read-only memory that is supposed to be trusted can become writable
+or .text pages can get remapped. Memory sealing can automatically be
+applied by the runtime loader to seal .text and .rodata pages and
+applications can additionally seal security critical data at runtime.
+
+A similar feature already exists in the XNU kernel with the
+VM_FLAGS_PERMANENT flag [1] and on OpenBSD with the mimmutable syscall [2].
+
+User API
+========
+mseal()
+-----------
+The mseal() syscall has the following signature:
+
+``int mseal(void addr, size_t len, unsigned long flags)``
+
+**addr/len**: virtual memory address range.
+
+The address range set by ``addr``/``len`` must meet:
+   - The start address must be in an allocated VMA.
+   - The start address must be page aligned.
+   - The end address (``addr`` + ``len``) must be in an allocated VMA.
+   - no gap (unallocated memory) between start and end address.
+
+The ``len`` will be paged aligned implicitly by the kernel.
+
+**flags**: reserved for future use.
+
+**return values**:
+
+- ``0``: Success.
+
+- ``-EINVAL``:
+    - Invalid input ``flags``.
+    - The start address (``addr``) is not page aligned.
+    - Address range (``addr`` + ``len``) overflow.
+
+- ``-ENOMEM``:
+    - The start address (``addr``) is not allocated.
+    - The end address (``addr`` + ``len``) is not allocated.
+    - A gap (unallocated memory) between start and end address.
+
+- ``-EPERM``:
+    - sealing is supported only on 64-bit CPUs, 32-bit is not supported.
+
+- For above error cases, users can expect the given memory range is
+  unmodified, i.e. no partial update.
+
+- There might be other internal errors/cases not listed here, e.g.
+  error during merging/splitting VMAs, or the process reaching the max
+  number of supported VMAs. In those cases, partial updates to the given
+  memory range could happen. However, those cases should be rare.
+
+**Blocked operations after sealing**:
+    Unmapping, moving to another location, and shrinking the size,
+    via munmap() and mremap(), can leave an empty space, therefore
+    can be replaced with a VMA with a new set of attributes.
+
+    Moving or expanding a different VMA into the current location,
+    via mremap().
+
+    Modifying a VMA via mmap(MAP_FIXED).
+
+    Size expansion, via mremap(), does not appear to pose any
+    specific risks to sealed VMAs. It is included anyway because
+    the use case is unclear. In any case, users can rely on
+    merging to expand a sealed VMA.
+
+    mprotect() and pkey_mprotect().
+
+    Some destructive madvice() behaviors (e.g. MADV_DONTNEED)
+    for anonymous memory, when users don't have write permission to the
+    memory. Those behaviors can alter region contents by discarding pages,
+    effectively a memset(0) for anonymous memory.
+
+    Kernel will return -EPERM for blocked operations.
+
+    For blocked operations, one can expect the given address is unmodified,
+    i.e. no partial update. Note, this is different from existing mm
+    system call behaviors, where partial updates are made till an error is
+    found and returned to userspace. To give an example:
+
+    Assume following code sequence:
+
+    - ptr = mmap(null, 8192, PROT_NONE);
+    - munmap(ptr + 4096, 4096);
+    - ret1 = mprotect(ptr, 8192, PROT_READ);
+    - mseal(ptr, 4096);
+    - ret2 = mprotect(ptr, 8192, PROT_NONE);
+
+    ret1 will be -ENOMEM, the page from ptr is updated to PROT_READ.
+
+    ret2 will be -EPERM, the page remains to be PROT_READ.
+
+**Note**:
+
+- mseal() only works on 64-bit CPUs, not 32-bit CPU.
+
+- users can call mseal() multiple times, mseal() on an already sealed memory
+  is a no-action (not error).
+
+- munseal() is not supported.
+
+Use cases:
+==========
+- glibc:
+  The dynamic linker, during loading ELF executables, can apply sealing to
+  non-writable memory segments.
+
+- Chrome browser: protect some security sensitive data-structures.
+
+Notes on which memory to seal:
+==============================
+
+It might be important to note that sealing changes the lifetime of a mapping,
+i.e. the sealed mapping won’t be unmapped till the process terminates or the
+exec system call is invoked. Applications can apply sealing to any virtual
+memory region from userspace, but it is crucial to thoroughly analyze the
+mapping's lifetime prior to apply the sealing.
+
+For example:
+
+- aio/shm
+
+  aio/shm can call mmap()/munmap() on behalf of userspace, e.g. ksys_shmdt() in
+  shm.c. The lifetime of those mapping are not tied to the lifetime of the
+  process. If those memories are sealed from userspace, then munmap() will fail,
+  causing leaks in VMA address space during the lifetime of the process.
+
+- Brk (heap)
+
+  Currently, userspace applications can seal parts of the heap by calling
+  malloc() and mseal().
+  let's assume following calls from user space:
+
+  - ptr = malloc(size);
+  - mprotect(ptr, size, RO);
+  - mseal(ptr, size);
+  - free(ptr);
+
+  Technically, before mseal() is added, the user can change the protection of
+  the heap by calling mprotect(RO). As long as the user changes the protection
+  back to RW before free(), the memory range can be reused.
+
+  Adding mseal() into the picture, however, the heap is then sealed partially,
+  the user can still free it, but the memory remains to be RO. If the address
+  is re-used by the heap manager for another malloc, the process might crash
+  soon after. Therefore, it is important not to apply sealing to any memory
+  that might get recycled.
+
+  Furthermore, even if the application never calls the free() for the ptr,
+  the heap manager may invoke the brk system call to shrink the size of the
+  heap. In the kernel, the brk-shrink will call munmap(). Consequently,
+  depending on the location of the ptr, the outcome of brk-shrink is
+  nondeterministic.
+
+
+Additional notes:
+=================
+As Jann Horn pointed out in [3], there are still a few ways to write
+to RO memory, which is, in a way, by design. Those cases are not covered
+by mseal(). If applications want to block such cases, sandbox tools (such as
+seccomp, LSM, etc) might be considered.
+
+Those cases are:
+
+- Write to read-only memory through /proc/self/mem interface.
+- Write to read-only memory through ptrace (such as PTRACE_POKETEXT).
+- userfaultfd.
+
+The idea that inspired this patch comes from Stephen Röttger’s work in V8
+CFI [4]. Chrome browser in ChromeOS will be the first user of this API.
+
+Reference:
+==========
+[1] https://github.com/apple-oss-distributions/xnu/blob/1031c584a5e37aff177559b9f69dbd3c8c3fd30a/osfmk/mach/vm_statistics.h#L274
+
+[2] https://man.openbsd.org/mimmutable.2
+
+[3] https://lore.kernel.org/lkml/CAG48ez3ShUYey+ZAFsU2i1RpQn0a5eOs2hzQ426FkcgnfUGLvA@mail.gmail.com
+
+[4] https://docs.google.com/document/d/1O2jwK4dxI3nRcOJuPYkonhTkNQfbmwdvxQMyXgeaRHo/edit#heading=h.bvaojj9fu6hc
_

Patches currently in -mm which might be from jeffxu@chromium.org are

selftest-mm-mseal-read-only-elf-memory-segment.patch

