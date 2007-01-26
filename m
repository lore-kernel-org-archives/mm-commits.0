From: akpm@osdl.org
Subject: + extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch added to -mm tree
Date: Fri, 26 Jan 2007 13:56:15 -0800
Message-ID: <200701262156.l0QLuF00027498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbXAZV4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 16:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com


The patch titled
     
has been added to the -mm tree.  Its filename is
     extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

kernel/sys.c:359: error: conflicting types for '__blocking_notifier_call_chain'
include/linux/notifier.h:140: error: previous declaration of '__blocking_notifier_call_chain' was here
kernel/sys.c:375: error: conflicting types for '__blocking_notifier_call_chain'
include/linux/notifier.h:140: error: previous declaration of '__blocking_notifier_call_chain' was here

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sys.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~extend-notifier_call_chain-to-count-nr_calls-made-fixes-3 kernel/sys.c
--- a/kernel/sys.c~extend-notifier_call_chain-to-count-nr_calls-made-fixes-3
+++ a/kernel/sys.c
@@ -354,7 +354,7 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai
  
 int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 				   unsigned long val, void *v,
-				   int nr_to_call, unsigned int *nr_calls)
+				   int nr_to_call, int *nr_calls)
 {
 	int ret = NOTIFY_DONE;
 
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

drivers-scsi-pcmcia-nsp_csh-removal-of-old.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
touchkit-ps-2-touchscreen-driver.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
