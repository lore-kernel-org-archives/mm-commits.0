From: akpm@linux-foundation.org
Subject: - kconfig-update-swsusp-description.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:01 -0800
Message-ID: <200703070422.l274M15L018957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47096 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211AbXCGEWI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     kconfig: Update swsusp description
has been removed from the -mm tree.  Its filename was
     kconfig-update-swsusp-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kconfig: Update swsusp description
From: Rafael J. Wysocki <rjw@sisk.pl>

Update the outdated and inaccurate description of the software suspend in
Kconfig.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/Kconfig |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff -puN kernel/power/Kconfig~kconfig-update-swsusp-description kernel/power/Kconfig
--- a/kernel/power/Kconfig~kconfig-update-swsusp-description
+++ a/kernel/power/Kconfig
@@ -81,30 +81,35 @@ config SOFTWARE_SUSPEND
 	bool "Software Suspend"
 	depends on PM && SWAP && ((X86 && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
 	---help---
-	  Enable the possibility of suspending the machine.
-	  It doesn't need ACPI or APM.
-	  You may suspend your machine by 'swsusp' or 'shutdown -z <time>' 
-	  (patch for sysvinit needed). 
+	  Enable the suspend to disk (STD) functionality.
 
-	  It creates an image which is saved in your active swap. Upon next
+	  You can suspend your machine with 'echo disk > /sys/power/state'.
+	  Alternatively, you can use the additional userland tools available
+	  from <http://suspend.sf.net>.
+
+	  In principle it does not require ACPI or APM, although for example
+	  ACPI will be used if available.
+
+	  It creates an image which is saved in your active swap. Upon the next
 	  boot, pass the 'resume=/dev/swappartition' argument to the kernel to
 	  have it detect the saved image, restore memory state from it, and
 	  continue to run as before. If you do not want the previous state to
-	  be reloaded, then use the 'noresume' kernel argument. However, note
-	  that your partitions will be fsck'd and you must re-mkswap your swap
-	  partitions. It does not work with swap files.
-
-	  Right now you may boot without resuming and then later resume but
-	  in meantime you cannot use those swap partitions/files which were
-	  involved in suspending. Also in this case there is a risk that buffers
-	  on disk won't match with saved ones.
+	  be reloaded, then use the 'noresume' kernel command line argument.
+	  Note, however, that fsck will be run on your filesystems and you will
+	  need to run mkswap against the swap partition used for the suspend.
+
+	  It also works with swap files to a limited extent (for details see
+	  <file:Documentation/power/swsusp-and-swap-files.txt>).
+
+	  Right now you may boot without resuming and resume later but in the
+	  meantime you cannot use the swap partition(s)/file(s) involved in
+	  suspending.  Also in this case you must not use the filesystems
+	  that were mounted before the suspend.  In particular, you MUST NOT
+	  MOUNT any journaled filesystems mounted before the suspend or they
+	  will get corrupted in a nasty way.
 
 	  For more information take a look at <file:Documentation/power/swsusp.txt>.
 
-	  (For now, swsusp is incompatible with PAE aka HIGHMEM_64G on i386.
-	  we need identity mapping for resume to work, and that is trivial
-	  to get with 4MB pages, but less than trivial on PAE).
-
 config PM_STD_PARTITION
 	string "Default resume partition"
 	depends on SOFTWARE_SUSPEND
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
make-xfs-workqueues-nonfreezable.patch
fix-refrigerator-vs-thaw_process-race.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
