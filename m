From: akpm@linux-foundation.org
Subject: [folded] stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:49:20 -0700
Message-ID: <201110312349.p9VNnKBo028131@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1JaXt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.fitzhardinge@citrix.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.
has been removed from the -mm tree.  Its filename was
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.patch

This patch was dropped because it was folded into stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3 kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3
+++ a/kernel/stop_machine.c
@@ -490,8 +490,9 @@ int __stop_machine(int (*fn)(void *), vo
 
 	if (!stop_machine_initialized) {
 		/*
-		 * Handle the case where stop_machine() is called early in boot
-		 * before SMP startup.
+		 * Handle the case where stop_machine() is called
+		 * early in boot before stop_machine() has been
+		 * initialized.
 		 */
  		unsigned long flags;
 		int ret;
_

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

origin.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

