From: akpm@osdl.org
Subject: - allow-null-pointers-in-percpu_free.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:20 -0800
Message-ID: <200612072257.kB7MvKAm029274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163661AbWLGW7c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     Allow NULL pointers in percpu_free
has been removed from the -mm tree.  Its filename was
     allow-null-pointers-in-percpu_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow NULL pointers in percpu_free
From: Alan Stern <stern@rowland.harvard.edu>

The patch (as824b) makes percpu_free() ignore NULL arguments, as one would
expect for a deallocation routine.  (Note that free_percpu is #defined as
percpu_free in include/linux/percpu.h.) A few callers are updated to remove
now-unneeded tests for NULL.  A few other callers already seem to assume
that passing a NULL pointer to percpu_free() is okay!

The patch also removes an unnecessary NULL check in percpu_depopulate().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/acpi/cstate.c |    6 ++----
 block/blktrace.c               |    3 +--
 mm/allocpercpu.c               |    9 +++++----
 net/ipv6/af_inet6.c            |    6 ++----
 4 files changed, 10 insertions(+), 14 deletions(-)

diff -puN arch/i386/kernel/acpi/cstate.c~allow-null-pointers-in-percpu_free arch/i386/kernel/acpi/cstate.c
--- a/arch/i386/kernel/acpi/cstate.c~allow-null-pointers-in-percpu_free
+++ a/arch/i386/kernel/acpi/cstate.c
@@ -156,10 +156,8 @@ static int __init ffh_cstate_init(void)
 
 static void __exit ffh_cstate_exit(void)
 {
-	if (cpu_cstate_entry) {
-		free_percpu(cpu_cstate_entry);
-		cpu_cstate_entry = NULL;
-	}
+	free_percpu(cpu_cstate_entry);
+	cpu_cstate_entry = NULL;
 }
 
 arch_initcall(ffh_cstate_init);
diff -puN block/blktrace.c~allow-null-pointers-in-percpu_free block/blktrace.c
--- a/block/blktrace.c~allow-null-pointers-in-percpu_free
+++ a/block/blktrace.c
@@ -394,8 +394,7 @@ err:
 	if (bt) {
 		if (bt->dropped_file)
 			debugfs_remove(bt->dropped_file);
-		if (bt->sequence)
-			free_percpu(bt->sequence);
+		free_percpu(bt->sequence);
 		if (bt->rchan)
 			relay_close(bt->rchan);
 		kfree(bt);
diff -puN mm/allocpercpu.c~allow-null-pointers-in-percpu_free mm/allocpercpu.c
--- a/mm/allocpercpu.c~allow-null-pointers-in-percpu_free
+++ a/mm/allocpercpu.c
@@ -17,10 +17,9 @@
 void percpu_depopulate(void *__pdata, int cpu)
 {
 	struct percpu_data *pdata = __percpu_disguise(__pdata);
-	if (pdata->ptrs[cpu]) {
-		kfree(pdata->ptrs[cpu]);
-		pdata->ptrs[cpu] = NULL;
-	}
+
+	kfree(pdata->ptrs[cpu]);
+	pdata->ptrs[cpu] = NULL;
 }
 EXPORT_SYMBOL_GPL(percpu_depopulate);
 
@@ -123,6 +122,8 @@ EXPORT_SYMBOL_GPL(__percpu_alloc_mask);
  */
 void percpu_free(void *__pdata)
 {
+	if (unlikely(!__pdata))
+		return;
 	__percpu_depopulate_mask(__pdata, &cpu_possible_map);
 	kfree(__percpu_disguise(__pdata));
 }
diff -puN net/ipv6/af_inet6.c~allow-null-pointers-in-percpu_free net/ipv6/af_inet6.c
--- a/net/ipv6/af_inet6.c~allow-null-pointers-in-percpu_free
+++ a/net/ipv6/af_inet6.c
@@ -720,10 +720,8 @@ snmp6_mib_free(void *ptr[2])
 {
 	if (ptr == NULL)
 		return;
-	if (ptr[0])
-		free_percpu(ptr[0]);
-	if (ptr[1])
-		free_percpu(ptr[1]);
+	free_percpu(ptr[0]);
+	free_percpu(ptr[1]);
 	ptr[0] = ptr[1] = NULL;
 }
 
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch

