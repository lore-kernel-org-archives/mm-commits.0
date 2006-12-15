From: akpm@osdl.org
Subject: - oprofile-add-a-special-cookie-for-the-vdso-region.patch removed from -mm tree
Date: Fri, 15 Dec 2006 14:43:16 -0800
Message-ID: <200612152243.kBFMhGRw003615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51229 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030299AbWLOWnv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:43:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amitabha.roy@gmail.com, levon@movementarian.org, phil.el@wanadoo.fr, mm-commits@vger.kernel.org


The patch titled
     oprofile: Add a special cookie for the VDSO region
has been removed from the -mm tree.  Its filename was
     oprofile-add-a-special-cookie-for-the-vdso-region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oprofile: Add a special cookie for the VDSO region
From: "Amitabha Roy" <amitabha.roy@gmail.com>

Emit a special VDSO_COOKIE for VDSO regions instead of simply marking
them as anon.

So we can debug performance problems where a lot of time is spent in the VDSO
region (as an example frequent syscall restarts due to too many signals ?).

Signed-off-by: Amitabha Roy <amitabha.roy@gmail.com>
Cc: John Levon <levon@movementarian.org>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/oprofile/buffer_sync.c  |    9 ++++++++-
 drivers/oprofile/event_buffer.h |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/oprofile/buffer_sync.c~oprofile-add-a-special-cookie-for-the-vdso-region drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~oprofile-add-a-special-cookie-for-the-vdso-region
+++ a/drivers/oprofile/buffer_sync.c
@@ -250,7 +250,14 @@ static unsigned long lookup_dcookie(stru
 				vma->vm_file->f_path.mnt);
 			*offset = (vma->vm_pgoff << PAGE_SHIFT) + addr -
 				vma->vm_start;
-		} else {
+		}
+#ifdef CONFIG_X86_32
+		else if(mm->context.vdso==vma->vm_start){
+                        cookie = VDSO_COOKIE;
+		        *offset = addr;
+		}
+#endif
+		else {
 			/* must be an anonymous map */
 			*offset = addr;
 		}
diff -puN drivers/oprofile/event_buffer.h~oprofile-add-a-special-cookie-for-the-vdso-region drivers/oprofile/event_buffer.h
--- a/drivers/oprofile/event_buffer.h~oprofile-add-a-special-cookie-for-the-vdso-region
+++ a/drivers/oprofile/event_buffer.h
@@ -35,6 +35,7 @@ void wake_up_buffer_waiter(void);
 #define TRACE_BEGIN_CODE		8
 #define TRACE_END_CODE			9
  
+#define VDSO_COOKIE ~1UL
 #define INVALID_COOKIE ~0UL
 #define NO_COOKIE 0UL
 
_

Patches currently in -mm which might be from amitabha.roy@gmail.com are

oprofile-add-a-special-cookie-for-the-vdso-region.patch

