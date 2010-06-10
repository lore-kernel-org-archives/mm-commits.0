From: akpm@linux-foundation.org
Subject: + kexec-fix-oops-in-crash_shrink_memory.patch added to -mm tree
Date: Thu, 10 Jun 2010 14:26:41 -0700
Message-ID: <201006102126.o5ALQftj024485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759831Ab0FJV1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 17:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavan@linux.vnet.ibm.com, horms@verge.net.au, vgoyal@redhat.com, xiyou.wangcong@gmail.com


The patch titled
     kexec: fix Oops in crash_shrink_memory()
has been added to the -mm tree.  Its filename is
     kexec-fix-oops-in-crash_shrink_memory.patch

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
Subject: kexec: fix Oops in crash_shrink_memory()
From: Pavan Naregundi <pavan@linux.vnet.ibm.com>

Signed-off-by: Pavan Naregundi <pavan@linux.vnet.ibm.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/kexec.c~kexec-fix-oops-in-crash_shrink_memory kernel/kexec.c
--- a/kernel/kexec.c~kexec-fix-oops-in-crash_shrink_memory
+++ a/kernel/kexec.c
@@ -1089,9 +1089,10 @@ void crash_kexec(struct pt_regs *regs)
 
 size_t crash_get_memory_size(void)
 {
-	size_t size;
+	size_t size = 0;
 	mutex_lock(&kexec_mutex);
-	size = crashk_res.end - crashk_res.start + 1;
+	if (crashk_res.end != crashk_res.start)
+		size = crashk_res.end - crashk_res.start + 1;
 	mutex_unlock(&kexec_mutex);
 	return size;
 }
@@ -1134,7 +1135,7 @@ int crash_shrink_memory(unsigned long ne
 
 	free_reserved_phys_range(end, crashk_res.end);
 
-	if (start == end)
+	if ((start == end) && (crashk_res.parent != NULL))
 		release_resource(&crashk_res);
 	crashk_res.end = end - 1;
 
_

Patches currently in -mm which might be from pavan@linux.vnet.ibm.com are

kexec-fix-oops-in-crash_shrink_memory.patch

