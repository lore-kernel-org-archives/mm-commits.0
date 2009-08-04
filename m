From: akpm@linux-foundation.org
Subject: + ksm-add-some-documentation.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:01:23 -0700
Message-ID: <200908042201.n74M1OEm014019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933304AbZHDWCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mtk.manpages@googlemail.com, randy.dunlap@oracle.com


The patch titled
     ksm: add some documentation
has been added to the -mm tree.  Its filename is
     ksm-add-some-documentation.patch

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
Subject: ksm: add some documentation
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Add Documentation/vm/ksm.txt: how to use the Kernel Samepage Merging feature

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/00-INDEX |    2 
 Documentation/vm/ksm.txt  |   89 ++++++++++++++++++++++++++++++++++++
 mm/Kconfig                |    1 
 3 files changed, 92 insertions(+)

diff -puN Documentation/vm/00-INDEX~ksm-add-some-documentation Documentation/vm/00-INDEX
--- a/Documentation/vm/00-INDEX~ksm-add-some-documentation
+++ a/Documentation/vm/00-INDEX
@@ -6,6 +6,8 @@ balance
 	- various information on memory balancing.
 hugetlbpage.txt
 	- a brief summary of hugetlbpage support in the Linux kernel.
+ksm.txt
+	- how to use the Kernel Samepage Merging feature.
 locking
 	- info on how locking and synchronization is done in the Linux vm code.
 numa
diff -puN /dev/null Documentation/vm/ksm.txt
--- /dev/null
+++ a/Documentation/vm/ksm.txt
@@ -0,0 +1,89 @@
+How to use the Kernel Samepage Merging feature
+----------------------------------------------
+
+KSM is a memory-saving de-duplication feature, enabled by CONFIG_KSM=y,
+added to the Linux kernel in 2.6.32.  See mm/ksm.c for its implementation,
+and http://lwn.net/Articles/306704/ and http://lwn.net/Articles/330589/
+
+The KSM daemon ksmd periodically scans those areas of user memory which
+have been registered with it, looking for pages of identical content which
+can be replaced by a single write-protected page (which is automatically
+copied if a process later wants to update its content).
+
+KSM was originally developed for use with KVM (where it was known as
+Kernel Shared Memory), to fit more virtual machines into physical memory,
+by sharing the data common between them.  But it can be useful to any
+application which generates many instances of the same data.
+
+KSM only merges anonymous (private) pages, never pagecache (file) pages.
+KSM's merged pages are at present locked into kernel memory for as long
+as they are shared: so cannot be swapped out like the user pages they
+replace (but swapping KSM pages should follow soon in a later release).
+
+KSM only operates on those areas of address space which an application
+has advised to be likely candidates for merging, by using the madvise(2)
+system call: int madvise(addr, length, MADV_MERGEABLE).
+
+The app may call int madvise(addr, length, MADV_UNMERGEABLE) to cancel
+that advice and restore unshared pages: whereupon KSM unmerges whatever
+it merged in that range.  Note: this unmerging call may suddenly require
+more memory than is available - possibly failing with EAGAIN, but more
+probably arousing the Out-Of-Memory killer.
+
+If KSM is not configured into the running kernel, madvise MADV_MERGEABLE
+and MADV_UNMERGEABLE simply fail with EINVAL.  If the running kernel was
+built with CONFIG_KSM=y, those calls will normally succeed: even if the
+the KSM daemon is not currently running, MADV_MERGEABLE still registers
+the range for whenever the KSM daemon is started; even if the range
+cannot contain any pages which KSM could actually merge; even if
+MADV_UNMERGEABLE is applied to a range which was never MADV_MERGEABLE.
+
+Like other madvise calls, they are intended for use on mapped areas of
+the user address space: they will report ENOMEM if the specified range
+includes unmapped gaps (though working on the intervening mapped areas),
+and might fail with EAGAIN if not enough memory for internal structures.
+
+Applications should be considerate in their use of MADV_MERGEABLE,
+restricting its use to areas likely to benefit.  KSM's scans may use
+a lot of processing power, and its kernel-resident pages are a limited
+resource.  Some installations will disable KSM for these reasons.
+
+The KSM daemon is controlled by sysfs files in /sys/kernel/mm/ksm/,
+readable by all but writable only by root:
+
+max_kernel_pages - set to maximum number of kernel pages that KSM may use
+                   e.g. "echo 2000 > /sys/kernel/mm/ksm/max_kernel_pages"
+                   Value 0 imposes no limit on the kernel pages KSM may use;
+                   but note that any process using MADV_MERGEABLE can cause
+                   KSM to allocate these pages, unswappable until it exits.
+                   Default: 2000 (chosen for demonstration purposes)
+
+pages_to_scan    - how many present pages to scan before ksmd goes to sleep
+                   e.g. "echo 200 > /sys/kernel/mm/ksm/pages_to_scan"
+                   Default: 200 (chosen for demonstration purposes)
+
+sleep_millisecs  - how many milliseconds ksmd should sleep before next scan
+                   e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
+                   Default: 20 (chosen for demonstration purposes)
+
+run              - set 0 to stop ksmd from running but keep merged pages,
+                   set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
+                   set 2 to stop ksmd and unmerge all pages currently merged,
+                         but leave mergeable areas registered for next run
+                   Default: 1 (for immediate use by apps which register)
+
+The effectiveness of KSM and MADV_MERGEABLE is shown in /sys/kernel/mm/ksm/:
+
+pages_shared     - how many shared unswappable kernel pages KSM is using
+pages_sharing    - how many more sites are sharing them i.e. how much saved
+pages_unshared   - how many pages unique but repeatedly checked for merging
+pages_volatile   - how many pages changing too fast to be placed in a tree
+full_scans       - how many times all mergeable areas have been scanned
+
+A high ratio of pages_sharing to pages_shared indicates good sharing, but
+a high ratio of pages_unshared to pages_sharing indicates wasted effort.
+pages_volatile embraces several different kinds of activity, but a high
+proportion there would also indicate poor use of madvise MADV_MERGEABLE.
+
+Izik Eidus,
+Hugh Dickins, 30 July 2009
diff -puN mm/Kconfig~ksm-add-some-documentation mm/Kconfig
--- a/mm/Kconfig~ksm-add-some-documentation
+++ a/mm/Kconfig
@@ -224,6 +224,7 @@ config KSM
 	  the many instances by a single resident page with that content, so
 	  saving memory until one or another app needs to modify the content.
 	  Recommended for use with KVM, or with other duplicative applications.
+	  See Documentation/vm/ksm.txt for more information.
 
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

acpi-fix-null-bug-for-hid-uid-string.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

