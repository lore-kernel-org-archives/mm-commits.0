From: akpm@google.com
Subject: + stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.patch added to -mm tree
Date: Tue, 04 Oct 2011 15:09:45 -0700
Message-ID: <201110042209.p94M9jNO007340@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:56551 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDWJy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 18:09:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, tj@kernel.org


The patch titled
     Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.
has been added to the -mm tree.  Its filename is
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.patch

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
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

origin.patch
linux-next.patch
x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.patch

