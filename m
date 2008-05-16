From: akpm@linux-foundation.org
Subject: + use-generic_access_phys-for-dev-mem-mappings.patch added to -mm tree
Date: Thu, 15 May 2008 17:24:12 -0700
Message-ID: <200805160024.m4G0OCDI018127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYEPAZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, airlied@linux.ie, arnd@arndb.de, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org


The patch titled
     use generic_access_phys for /dev/mem mappings
has been added to the -mm tree.  Its filename is
     use-generic_access_phys-for-dev-mem-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use generic_access_phys for /dev/mem mappings
From: Rik van Riel <riel@redhat.com>

Use generic_access_phys as the access_process_vm access function for
/dev/mem mappings.  This makes it possible to debug the X server.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Benjamin Herrensmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/mem.c~use-generic_access_phys-for-dev-mem-mappings drivers/char/mem.c
--- a/drivers/char/mem.c~use-generic_access_phys-for-dev-mem-mappings
+++ a/drivers/char/mem.c
@@ -326,7 +326,8 @@ static void mmap_mem_close(struct vm_are
 
 static struct vm_operations_struct mmap_mem_ops = {
 	.open  = mmap_mem_open,
-	.close = mmap_mem_close
+	.close = mmap_mem_close,
+	.access = generic_access_phys
 };
 
 static int mmap_mem(struct file * file, struct vm_area_struct * vma)
_

Patches currently in -mm which might be from riel@redhat.com are

access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
make-mm-rmapc-anon_vma_cachep-static.patch

