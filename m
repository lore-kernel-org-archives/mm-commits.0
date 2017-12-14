From: akpm@linux-foundation.org
Subject: + mm-introduce-map_fixed_safe.patch added to -mm tree
Date: Wed, 13 Dec 2017 16:32:19 -0800
Message-ID: <5a31c693.uuLhQvn7QBaGyTzD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751459AbdLNAcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:32:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, abdhalee@linux.vnet.ibm.com, davidtgoldblatt@gmail.com, fweimer@redhat.com, jasone@google.com, jhubbard@nvidia.com, joel@jms.id.au, keescook@chromium.org, khalid.aziz@oracle.com, linux@armlinux.org.uk, mpe@ellerman.id.au, trasz@FreeBSD.org, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce MAP_FIXED_SAFE
has been added to the -mm tree.  Its filename is
     mm-introduce-map_fixed_safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-map_fixed_safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-map_fixed_safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: introduce MAP_FIXED_SAFE

Patch series "mm: introduce MAP_FIXED_SAFE", v2.

This has started as a follow up discussion [3][4] resulting in the runtime
failure caused by hardening patch [5] which removes MAP_FIXED from the elf
loader because MAP_FIXED is inherently dangerous as it might silently
clobber an existing underlying mapping (e.g.  stack).  The reason for the
failure is that some architectures enforce an alignment for the given
address hint without MAP_FIXED used (e.g.  for shared or file backed
mappings).

One way around this would be excluding those archs which do alignment
tricks from the hardening [6].  The patch is really trivial but it has
been objected, rightfully so, that this screams for a more generic
solution.  We basically want a non-destructive MAP_FIXED.

The first patch introduced MAP_FIXED_SAFE which enforces the given address
but unlike MAP_FIXED it fails with EEXIST if the given range conflicts
with an existing one.  The flag is introduced as a completely new one
rather than a MAP_FIXED extension because of the backward compatibility. 
We really want a never-clobber semantic even on older kernels which do not
recognize the flag.  Unfortunately mmap sucks wrt.  flags evaluation
because we do not EINVAL on unknown flags.  On those kernels we would
simply use the traditional hint based semantic so the caller can still get
a different address (which sucks) but at least not silently corrupt an
existing mapping.  I do not see a good way around that.  Except we won't
export expose the new semantic to the userspace at all.  

It seems there are users who would like to have something like that. 
Jemalloc has been mentioned by Michael Ellerman [7]

Florian Weimer has mentioned the following:
: glibc ld.so currently maps DSOs without hints.  This means that the kernel
: will map right next to each other, and the offsets between them a completely
: predictable.  We would like to change that and supply a random address in a
: window of the address space.  If there is a conflict, we do not want the
: kernel to pick a non-random address. Instead, we would try again with a
: random address.

John Hubbard has mentioned CUDA example
: a) Searches /proc/<pid>/maps for a "suitable" region of available
: VA space.  "Suitable" generally means it has to have a base address
: within a certain limited range (a particular device model might
: have odd limitations, for example), it has to be large enough, and
: alignment has to be large enough (again, various devices may have
: constraints that lead us to do this).
: 
: This is of course subject to races with other threads in the process.
: 
: Let's say it finds a region starting at va.
: 
: b) Next it does: 
:     p = mmap(va, ...) 
: 
: *without* setting MAP_FIXED, of course (so va is just a hint), to
: attempt to safely reserve that region. If p != va, then in most cases,
: this is a failure (almost certainly due to another thread getting a
: mapping from that region before we did), and so this layer now has to
: call munmap(), before returning a "failure: retry" to upper layers.
: 
:     IMPROVEMENT: --> if instead, we could call this:
: 
:             p = mmap(va, ... MAP_FIXED_SAFE ...)
: 
:         , then we could skip the munmap() call upon failure. This
:         is a small thing, but it is useful here. (Thanks to Piotr
:         Jaroszynski and Mark Hairgrove for helping me get that detail
:         exactly right, btw.)
: 
: c) After that, CUDA suballocates from p, via: 
:  
:      q = mmap(sub_region_start, ... MAP_FIXED ...)
: 
: Interestingly enough, "freeing" is also done via MAP_FIXED, and
: setting PROT_NONE to the subregion. Anyway, I just included (c) for
: general interest.

Atomic address range probing in the multithreaded programs in general
sounds like an interesting thing to me.

The second patch simply replaces MAP_FIXED use in elf loader by
MAP_FIXED_SAFE.  I believe other places which rely on MAP_FIXED should
follow.  Actually real MAP_FIXED usages should be docummented properly and
they should be more of an exception.

[1] http://lkml.kernel.org/r/20171116101900.13621-1-mhocko@kernel.org
[2] http://lkml.kernel.org/r/20171129144219.22867-1-mhocko@kernel.org
[3] http://lkml.kernel.org/r/20171107162217.382cd754@canb.auug.org.au
[4] http://lkml.kernel.org/r/1510048229.12079.7.camel@abdul.in.ibm.com
[5] http://lkml.kernel.org/r/20171023082608.6167-1-mhocko@kernel.org
[6] http://lkml.kernel.org/r/20171113094203.aofz2e7kueitk55y@dhcp22.suse.cz
[7] http://lkml.kernel.org/r/87efp1w7vy.fsf@concordia.ellerman.id.au



This patch (of 2):

MAP_FIXED is used quite often to enforce mapping at the particular range. 
The main problem of this flag is, however, that it is inherently dangerous
because it unmaps existing mappings covered by the requested range.  This
can cause silent memory corruptions.  Some of them even with serious
security implications.  While the current semantic might be really
desiderable in many cases there are others which would want to enforce the
given range but rather see a failure than a silent memory corruption on a
clashing range.  Please note that there is no guarantee that a given range
is obeyed by the mmap even when it is free - e.g.  arch specific code is
allowed to apply an alignment.

Introduce a new MAP_FIXED_SAFE flag for mmap to achieve this behavior.  It
has the same semantic as MAP_FIXED wrt.  the given address request with a
single exception that it fails with EEXIST if the requested address is
already covered by an existing mapping.  We still do rely on
get_unmaped_area to handle all the arch specific MAP_FIXED treatment and
check for a conflicting vma after it returns.

The flag is introduced as a completely new one rather than a MAP_FIXED
extension because of the backward compatibility.  We really want a
never-clobber semantic even on older kernels which do not recognize the
flag.  Unfortunately mmap sucks wrt.  flags evaluation because we do not
EINVAL on unknown flags.  On those kernels we would simply use the
traditional hint based semantic so the caller can still get a different
address (which sucks) but at least not silently corrupt an existing
mapping.  I do not see a good way around that.

[fail on clashing range with EEXIST as per Florian Weimer]
[set MAP_FIXED before round_hint_to_min as per Khalid Aziz]
Link: http://lkml.kernel.org/r/20171213092550.2774-2-mhocko@kernel.org
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Evans <jasone@google.com>
Cc: David Goldblatt <davidtgoldblatt@gmail.com>
Cc: Edward Tomasz Napierała <trasz@FreeBSD.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |    1 +
 arch/mips/include/uapi/asm/mman.h      |    2 ++
 arch/parisc/include/uapi/asm/mman.h    |    2 ++
 arch/sparc/include/uapi/asm/mman.h     |    1 -
 arch/xtensa/include/uapi/asm/mman.h    |    2 ++
 include/uapi/asm-generic/mman-common.h |    1 +
 mm/mmap.c                              |   11 +++++++++++
 7 files changed, 19 insertions(+), 1 deletion(-)

diff -puN arch/alpha/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -32,6 +32,7 @@
 #define MAP_NONBLOCK	0x40000		/* do not block on IO */
 #define MAP_STACK	0x80000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x100000	/* create a huge page mapping */
+#define MAP_FIXED_SAFE	0x200000	/* MAP_FIXED which doesn't unmap underlying mapping */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_SYNC		2		/* synchronous memory sync */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -51,6 +51,8 @@
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
+#define MAP_FIXED_SAFE	0x100000	/* MAP_FIXED which doesn't unmap underlying mapping */
+
 /*
  * Flags for msync
  */
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -27,6 +27,8 @@
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
+#define MAP_FIXED_SAFE	0x100000	/* MAP_FIXED which doesn't unmap underlying mapping */
+
 #define MS_SYNC		1		/* synchronous memory sync */
 #define MS_ASYNC	2		/* sync memory asynchronously */
 #define MS_INVALIDATE	4		/* invalidate the caches */
diff -puN arch/sparc/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe arch/sparc/include/uapi/asm/mman.h
--- a/arch/sparc/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe
+++ a/arch/sparc/include/uapi/asm/mman.h
@@ -25,5 +25,4 @@
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
-
 #endif /* _UAPI__SPARC_MMAN_H__ */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -57,6 +57,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
+#define MAP_FIXED_SAFE	0x100000	/* MAP_FIXED which doesn't unmap underlying mapping */
 #ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
 # define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be
 					 * uninitialized */
@@ -64,6 +65,7 @@
 # define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
 
+
 /*
  * Flags for msync
  */
diff -puN include/uapi/asm-generic/mman-common.h~mm-introduce-map_fixed_safe include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~mm-introduce-map_fixed_safe
+++ a/include/uapi/asm-generic/mman-common.h
@@ -26,6 +26,7 @@
 #else
 # define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
+#define MAP_FIXED_SAFE	0x80000		/* MAP_FIXED which doesn't unmap underlying mapping */
 
 /*
  * Flags for mlock
diff -puN mm/mmap.c~mm-introduce-map_fixed_safe mm/mmap.c
--- a/mm/mmap.c~mm-introduce-map_fixed_safe
+++ a/mm/mmap.c
@@ -1342,6 +1342,10 @@ unsigned long do_mmap(struct file *file,
 		if (!(file && path_noexec(&file->f_path)))
 			prot |= PROT_EXEC;
 
+	/* force arch specific MAP_FIXED handling in get_unmapped_area */
+	if (flags & MAP_FIXED_SAFE)
+		flags |= MAP_FIXED;
+
 	if (!(flags & MAP_FIXED))
 		addr = round_hint_to_min(addr);
 
@@ -1365,6 +1369,13 @@ unsigned long do_mmap(struct file *file,
 	if (offset_in_page(addr))
 		return addr;
 
+	if (flags & MAP_FIXED_SAFE) {
+		struct vm_area_struct *vma = find_vma(mm, addr);
+
+		if (vma && vma->vm_start <= addr)
+			return -EEXIST;
+	}
+
 	if (prot == PROT_EXEC) {
 		pkey = execute_only_pkey(mm);
 		if (pkey < 0)
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-fix-memory-corruption.patch
mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch

