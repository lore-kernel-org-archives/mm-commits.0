From: akpm@linux-foundation.org
Subject: + pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch added to -mm tree
Date: Wed, 25 Jul 2007 22:10:59 -0700
Message-ID: <200707260510.l6Q5AxFG015287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588AbXGZFLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 01:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, bunk@stusta.de


The patch titled
     Use is_global_init() in arch/m32r/mm/fault.c
has been added to the -mm tree.  Its filename is
     pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use is_global_init() in arch/m32r/mm/fault.c
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Use is_global_init() in arch/m32r/mm/fault.c.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m32r/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix arch/m32r/mm/fault.c
--- a/arch/m32r/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix
+++ a/arch/m32r/mm/fault.c
@@ -271,7 +271,7 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(tsk)) {
+	if (is_global_init(tsk)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
