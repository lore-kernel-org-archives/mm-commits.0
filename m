From: akpm@linux-foundation.org
Subject: + remove-open_max.patch added to -mm tree
Date: Wed, 11 Jul 2007 18:07:24 -0700
Message-ID: <200707120107.l6C17O2t032330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758466AbXGLBIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 21:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com


The patch titled
     Remove OPEN_MAX
has been added to the -mm tree.  Its filename is
     remove-open_max.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove OPEN_MAX
From: Roland McGrath <roland@redhat.com>

The OPEN_MAX macro in limits.h should not be there.  It claims to be the
limit on file descriptors in a process, but its value is wrong for that. 
There is no constant value, but a variable resource limit (RLIMIT_NOFILE). 
Nothing in the kernel uses OPEN_MAX except things that are wrong to do so. 
I've submitted other patches to remove those uses.

The proper thing to do according to POSIX is not to define OPEN_MAX at all.
The sysconf (_SC_OPEN_MAX) implementation works by calling getrlimit.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/limits.h |    1 -
 1 files changed, 1 deletion(-)

diff -puN include/linux/limits.h~remove-open_max include/linux/limits.h
--- a/include/linux/limits.h~remove-open_max
+++ a/include/linux/limits.h
@@ -6,7 +6,6 @@
 #define NGROUPS_MAX    65536	/* supplemental group IDs are available */
 #define ARG_MAX       131072	/* # bytes of args + environ for exec() */
 #define CHILD_MAX        999    /* no limit :-) */
-#define OPEN_MAX         256	/* # open files a process may have */
 #define LINK_MAX         127	/* # links a file may have */
 #define MAX_CANON        255	/* size of the canonical input queue */
 #define MAX_INPUT        255	/* size of the type-ahead buffer */
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
avoid-open_max-in-scm_max_fd.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
i386-vdso-install-unstripped-copies-on-disk.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
pie-randomization.patch
remove-open_max.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch
alpha-put-allocated-elf-notes-in-read-only-data-segment.patch
powerpc-put-allocated-elf-notes-in-read-only-data-segment.patch
s390-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
