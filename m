From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 15:00:15 -0700
Message-ID: <55f34eef.D5QM0YJPsOnaOttM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbIKWAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:00:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7
has been removed from the -mm tree.  Its filename was
     mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7.patch

This patch was dropped because it was folded into mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN mm/mlock.c~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7 mm/mlock.c
--- a/mm/mlock.c~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7
+++ a/mm/mlock.c
@@ -578,9 +578,9 @@ static int apply_vma_lock_flags(unsigned
 		prev = vma;
 
 	for (nstart = start ; ; ) {
-		vm_flags_t newflags;
+		vm_flags_t newflags =
+			vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
 
-		newflags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
 		newflags |= flags;
 
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
@@ -678,7 +678,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
  * and translate into the appropriate modifications to mm->def_flags and/or the
  * flags for all current VMAs.
  *
- * There are a couple of sublties with this.  If mlockall() is called multiple
+ * There are a couple of subtleties with this.  If mlockall() is called multiple
  * times with different flags, the values do not necessarily stack.  If mlockall
  * is called once including the MCL_FUTURE flag and then a second time without
  * it, VM_LOCKED and VM_LOCKONFAULT will be cleared from mm->def_flags.
@@ -695,13 +695,6 @@ static int apply_mlockall_flags(int flag
 		if (flags & MCL_ONFAULT)
 			current->mm->def_flags |= VM_LOCKONFAULT;
 
-		/*
-		 * When there were only two flags, we used to early out if only
-		 * MCL_FUTURE was set.  Now that we have MCL_ONFAULT, we can
-		 * only early out if MCL_FUTURE is set, but MCL_CURRENT is not.
-		 * This is done, even though it promotes odd behavior, to
-		 * maintain behavior from older kernels
-		 */
 		if (!(flags & MCL_CURRENT))
 			goto out;
 	}
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch

