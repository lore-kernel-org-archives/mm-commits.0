From: akpm@linux-foundation.org
Subject: + kmemleak-add-documentation-on-the-memory-leak-detector.patch added to -mm tree
Date: Mon, 29 Dec 2008 16:22:50 -0800
Message-ID: <200812300022.mBU0MogB005803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbYL3AXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, randy.dunlap@oracle.com


The patch titled
     kmemleak: add documentation on the memory leak detector
has been added to the -mm tree.  Its filename is
     kmemleak-add-documentation-on-the-memory-leak-detector.patch

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
Subject: kmemleak: add documentation on the memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>

Add the Documentation/kmemleak.txt file with some information about how
kmemleak works.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 
 Documentation/kmemleak.txt          |  142 ++++++++++++++++++++++++++
 2 files changed, 146 insertions(+)

diff -puN Documentation/kernel-parameters.txt~kmemleak-add-documentation-on-the-memory-leak-detector Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kmemleak-add-documentation-on-the-memory-leak-detector
+++ a/Documentation/kernel-parameters.txt
@@ -1075,6 +1075,10 @@ and is between 256 and 4096 characters. 
 			Configure the RouterBoard 532 series on-chip
 			Ethernet adapter MAC address.
 
+	kmemleak=	[KNL] Boot-time kmemleak enable/disable
+			Valid arguments: on, off
+			Default: on
+
 	l2cr=		[PPC]
 
 	l3cr=		[PPC]
diff -puN /dev/null Documentation/kmemleak.txt
--- /dev/null
+++ a/Documentation/kmemleak.txt
@@ -0,0 +1,142 @@
+Kernel Memory Leak Detector
+===========================
+
+Introduction
+------------
+
+Kmemleak provides a way of detecting possible kernel memory leaks in a
+way similar to a tracing garbage collector
+(http://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29#Tracing_garbage_collectors),
+with the difference that the orphan objects are not freed but only
+reported via /sys/kernel/debug/kmemleak. A similar method is used by the
+Valgrind tool (memcheck --leak-check) to detect the memory leaks in
+user-space applications.
+
+Usage
+-----
+
+CONFIG_DEBUG_KMEMLEAK in "Kernel hacking" has to be enabled. A kernel
+thread scans the memory every 10 min (by default) and prints any new
+unreferenced objects found. To trigger an intermediate scan and display
+all the possible memory leaks:
+
+  # mount -t debugfs nodev /sys/kernel/debug/
+  # cat /sys/kernel/debug/kmemleak
+
+Note that the orphan objects are listed in the order they were allocated
+and one object at the beginning of the list may cause other subsequent
+objects to be reported as orphan.
+
+Memory scanning parameters can be modified at run-time by writing to the
+/sys/kernel/debug/kmemleak file. The following parameters are supported:
+
+  off		- disable kmemleak (irreversible)
+  stack=on	- enable the task stacks scanning
+  stack=off	- disable the tasks stacks scanning
+  scan=on	- start the automatic memory scanning thread
+  scan=off	- stop the automatic memory scanning thread
+  scan=<secs>	- set the automatic memory scanning period in seconds (0
+		  to disable it)
+
+Kmemleak can also be disabled at boot-time by passing "kmemleak=off" on
+the kernel command line.
+
+Basic Algorithm
+---------------
+
+The memory allocations via kmalloc, vmalloc, kmem_cache_alloc and
+friends are traced and the pointers, together with additional
+information like size and stack trace, are stored in a prio search tree.
+The corresponding freeing function calls are tracked and the pointers
+removed from the kmemleak data structures.
+
+An allocated block of memory is considered orphan if no pointer to its
+start address or to any location inside the block can be found by
+scanning the memory (including saved registers). This means that there
+might be no way for the kernel to pass the address of the allocated
+block to a freeing function and therefore the block is considered a
+memory leak.
+
+The scanning algorithm steps:
+
+  1. mark all objects as white (remaining white objects will later be
+     considered orphan)
+  2. scan the memory starting with the data section and stacks, checking
+     the values against the addresses stored in the prio search tree. If
+     a pointer to a white object is found, the object is added to the
+     gray list
+  3. scan the gray objects for matching addresses (some white objects
+     can become gray and added at the end of the gray list) until the
+     gray set is finished
+  4. the remaining white objects are considered orphan and reported via
+     /sys/kernel/debug/kmemleak
+
+Some allocated memory blocks have pointers stored in the kernel's
+internal data structures and they cannot be detected as orphans. To
+avoid this, kmemleak can also store the number of values pointing to an
+address inside the block address range that need to be found so that the
+block is not considered a leak. One example is __vmalloc().
+
+Kmemleak API
+------------
+
+See the include/linux/kmemleak.h header for the functions prototype.
+
+kmemleak_init		 - initialize kmemleak
+kmemleak_alloc		 - notify of a memory block allocation
+kmemleak_free		 - notify of a memory block freeing
+kmemleak_not_leak	 - mark an object as not a leak
+kmemleak_ignore		 - do not scan or report an object as leak
+kmemleak_scan_area	 - add scan areas inside a memory block
+kmemleak_no_scan	 - do not scan a memory block
+kmemleak_erase		 - erase an old value in a pointer variable
+kmemleak_alloc_recursive - as kmemleak_alloc but checks the recursiveness
+kmemleak_free_recursive	 - as kmemleak_free but checks the recursiveness
+
+Dealing with false positives/negatives
+--------------------------------------
+
+The false negatives are real memory leaks (orphan objects) but not
+reported by kmemleak because values found during the memory scanning
+point to such objects. To reduce the number of false negatives, kmemleak
+provides the kmemleak_ignore, kmemleak_scan_area, kmemleak_no_scan and
+kmemleak_erase functions (see above). The task stacks also increase the
+amount of false negatives and their scanning is not enabled by default.
+
+The false positives are objects wrongly reported as being memory leaks
+(orphan). For objects known not to be leaks, kmemleak provides the
+kmemleak_not_leak function. The kmemleak_ignore could also be used if
+the memory block is known not to contain other pointers and it will no
+longer be scanned.
+
+Some of the reported leaks are only transient, especially on SMP
+systems, because of pointers temporarily stored in CPU registers or
+stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
+the minimum age of an object to be reported as a memory leak.
+
+Limitations and Drawbacks
+-------------------------
+
+The main drawback is the reduced performance of memory allocation and
+freeing. To avoid other penalties, the memory scanning is only performed
+when the /sys/kernel/debug/kmemleak file is read. Anyway, this tool is
+intended for debugging purposes where the performance might not be the
+most important requirement.
+
+To keep the algorithm simple, kmemleak scans for values pointing to any
+address inside a block's address range. This may lead to an increased
+number of false negatives. However, it is likely that a real memory leak
+will eventually become visible.
+
+Another source of false negatives is the data stored in non-pointer
+values. In a future version, kmemleak could only scan the pointer
+members in the allocated structures. This feature would solve many of
+the false negative cases described above.
+
+The tool can report false positives. These are cases where an allocated
+block doesn't need to be freed (some cases in the init_call functions),
+the pointer is calculated by other methods than the usual container_of
+macro or the pointer is stored in a location not scanned by kmemleak.
+
+Page allocations and ioremap are not tracked. Only the ARM and x86
+architectures are currently supported.
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch
kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch
kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

