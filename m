From: akpm@linux-foundation.org
Subject: + nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable.patch added to -mm tree
Date: Tue, 05 May 2009 15:17:03 -0700
Message-ID: <200905052217.n45MH4NX016660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbZEEWTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 18:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, lanttor.guo@freescale.com


The patch titled
     nommu: make the initial mmap allocation excess behaviour Kconfig configurable
has been added to the -mm tree.  Its filename is
     nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: make the initial mmap allocation excess behaviour Kconfig configurable
From: David Howells <dhowells@redhat.com>

NOMMU mmap() has an option controlled by a sysctl variable that determines
whether the allocations made by do_mmap_private() should have the excess
space trimmed off and returned to the allocator.  Make the initial setting
of this variable a Kconfig configuration option.

The reason there can be excess space is that the allocator only allocates
in power-of-2 size chunks, but mmap()'s can be made in sizes that aren't a
power of 2.

There are two alternatives:

 (1) Keep the excess as dead space.  The dead space then remains unused for the
     lifetime of the mapping.  Mappings of shared objects such as libc, ld.so
     or busybox's text segment may retain their dead space forever.

 (2) Return the excess to the allocator.  This means that the dead space is
     limited to less than a page per mapping, but it means that for a transient
     process, there's more chance of fragmentation as the excess space may be
     reused fairly quickly.

During the boot process, a lot of transient processes are created, and
this can cause a lot of fragmentation as the pagecache and various slabs
grow greatly during this time.

By turning off the trimming of excess space during boot and disabling
batching of frees, Coldfire can manage to boot.

A better way of doing things might be to have /sbin/init turn this option
off.  By that point libc, ld.so and init - which are all long-duration
processes - have all been loaded and trimmed.

Reported-by: Lanttor Guo <lanttor.guo@freescale.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Lanttor Guo <lanttor.guo@freescale.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   28 ++++++++++++++++++++++++++++
 mm/nommu.c |    2 +-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff -puN mm/Kconfig~nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable mm/Kconfig
--- a/mm/Kconfig~nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable
+++ a/mm/Kconfig
@@ -225,3 +225,31 @@ config HAVE_MLOCKED_PAGE_BIT
 
 config MMU_NOTIFIER
 	bool
+
+config NOMMU_INITIAL_TRIM_EXCESS
+	int "Turn on mmap() excess space trimming before booting"
+	depends on !MMU
+	default 1
+	help
+	  The NOMMU mmap() frequently needs to allocate large contiguous chunks
+	  of memory on which to store mappings, but it can only ask the system
+	  allocator for chunks in 2^N*PAGE_SIZE amounts - which is frequently
+	  more than it requires.  To deal with this, mmap() is able to trim off
+	  the excess and return it to the allocator.
+
+	  If trimming is enabled, the excess is trimmed off and returned to the
+	  system allocator, which can cause extra fragmentation, particularly
+	  if there are a lot of transient processes.
+
+	  If trimming is disabled, the excess is kept, but not used, which for
+	  long-term mappings means that the space is wasted.
+
+	  Trimming can be dynamically controlled through a sysctl option
+	  (/proc/sys/vm/nr_trim_pages) which specifies the minimum number of
+	  excess pages there must be before trimming should occur, or zero if
+	  no trimming is to occur.
+
+	  This option specifies the initial value of this option.  The default
+	  of 1 says that all excess pages should be trimmed.
+
+	  See Documentation/nommu-mmap.txt for more information.
diff -puN mm/nommu.c~nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable mm/nommu.c
--- a/mm/nommu.c~nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable
+++ a/mm/nommu.c
@@ -66,7 +66,7 @@ struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
-int sysctl_nr_trim_pages = 1; /* page trimming behaviour */
+int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
mm-use-roundown_pow_of_two-in-zone_batchsize.patch
nommu-clamp-zone_batchsize-to-0-under-nommu-conditions.patch
nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-remove-in-kernel-strace-code.patch
frv-implement-tif_notify_resume.patch
frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch
frv-implement-new-style-ptrace.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
mutex-subsystem-synchro-test-module.patch

