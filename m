From: akpm@linux-foundation.org
Subject: + uml-ldt-mutex-conversion.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:23:44 -0800
Message-ID: <200801280524.m0S5OcHi013806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbYA1FZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:25:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, jdike@linux.intel.com


The patch titled
     uml: LDT mutex conversion
has been added to the -mm tree.  Its filename is
     uml-ldt-mutex-conversion.patch

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
Subject: uml: LDT mutex conversion
From: Daniel Walker <dwalker@mvista.com>

The ldt.semaphore conforms to the new struct mutex requirments, so I converted
it to use the new API and changed the name.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/ldt.c |   14 +++++++-------
 include/asm-um/ldt.h   |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/um/sys-i386/ldt.c~uml-ldt-mutex-conversion arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-ldt-mutex-conversion
+++ a/arch/um/sys-i386/ldt.c
@@ -147,7 +147,7 @@ static int read_ldt(void __user * ptr, u
 	if (ptrace_ldt)
 		return read_ldt_from_host(ptr, bytecount);
 
-	down(&ldt->semaphore);
+	mutex_lock(&ldt->lock);
 	if (ldt->entry_count <= LDT_DIRECT_ENTRIES) {
 		size = LDT_ENTRY_SIZE*LDT_DIRECT_ENTRIES;
 		if (size > bytecount)
@@ -171,7 +171,7 @@ static int read_ldt(void __user * ptr, u
 			ptr += size;
 		}
 	}
-	up(&ldt->semaphore);
+	mutex_unlock(&ldt->lock);
 
 	if (bytecount == 0 || err == -EFAULT)
 		goto out;
@@ -229,7 +229,7 @@ static int write_ldt(void __user * ptr, 
 	}
 
 	if (!ptrace_ldt)
-		down(&ldt->semaphore);
+		mutex_lock(&ldt->lock);
 
 	err = write_ldt_entry(mm_idp, func, &ldt_info, &addr, 1);
 	if (err)
@@ -289,7 +289,7 @@ static int write_ldt(void __user * ptr, 
 	err = 0;
 
 out_unlock:
-	up(&ldt->semaphore);
+	mutex_unlock(&ldt->lock);
 out:
 	return err;
 }
@@ -396,7 +396,7 @@ long init_new_ldt(struct mm_context *new
 
 
 	if (!ptrace_ldt)
-		init_MUTEX(&new_mm->ldt.semaphore);
+		mutex_init(&new_mm->ldt.lock);
 
 	if (!from_mm) {
 		memset(&desc, 0, sizeof(desc));
@@ -456,7 +456,7 @@ long init_new_ldt(struct mm_context *new
 		 * i.e., we have to use the stub for modify_ldt, which
 		 * can't handle the big read buffer of up to 64kB.
 		 */
-		down(&from_mm->ldt.semaphore);
+		mutex_lock(&from_mm->ldt.lock);
 		if (from_mm->ldt.entry_count <= LDT_DIRECT_ENTRIES)
 			memcpy(new_mm->ldt.u.entries, from_mm->ldt.u.entries,
 			       sizeof(new_mm->ldt.u.entries));
@@ -475,7 +475,7 @@ long init_new_ldt(struct mm_context *new
 			}
 		}
 		new_mm->ldt.entry_count = from_mm->ldt.entry_count;
-		up(&from_mm->ldt.semaphore);
+		mutex_unlock(&from_mm->ldt.lock);
 	}
 
     out:
diff -puN include/asm-um/ldt.h~uml-ldt-mutex-conversion include/asm-um/ldt.h
--- a/include/asm-um/ldt.h~uml-ldt-mutex-conversion
+++ a/include/asm-um/ldt.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_LDT_H
 #define __ASM_LDT_H
 
-#include "asm/semaphore.h"
+#include <linux/mutex.h>
 #include "asm/host_ldt.h"
 
 extern void ldt_host_info(void);
@@ -27,7 +27,7 @@ struct ldt_entry {
 
 typedef struct uml_ldt {
 	int entry_count;
-	struct semaphore semaphore;
+	struct mutex lock;
 	union {
 		struct ldt_entry * pages[LDT_PAGES_MAX];
 		struct ldt_entry entries[LDT_DIRECT_ENTRIES];
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
driver-base-memory-semaphore-to-mutex.patch
git-dvb.patch
git-mips.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
prism54-remove-questionable-down_interruptible-usage.patch
git-x86.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
uml-ldt-mutex-conversion.patch
uml-mconsole-mutex-conversion.patch
uml-port-mutex-conversion.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
docs-convert-kref-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
