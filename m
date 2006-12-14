From: akpm@osdl.org
Subject: - use-activate_mm-in-fs-aiocuse_mm.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:10:13 -0800
Message-ID: <200612140610.kBE6AEKJ002008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52175 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbWLNGKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Use activate_mm() in fs/aio.c:use_mm()
has been removed from the -mm tree.  Its filename was
     use-activate_mm-in-fs-aiocuse_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use activate_mm() in fs/aio.c:use_mm()
From: Jeremy Fitzhardinge <jeremy@goop.org>

activate_mm() is not the right thing to be using in use_mm().  It should be
switch_mm().

On normal x86, they're synonymous, but for the Xen patches I'm adding a
hook which assumes that activate_mm is only used the first time a new mm
is used after creation (I have another hook for dealing with dup_mm).  I
think this use of activate_mm() is the only place where it could be used
a second time on an mm.

From a quick look at the other architectures I think this is OK (most
simply implement one in terms of the other), but some are doing some
subtly different stuff between the two.

Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/aio.c~use-activate_mm-in-fs-aiocuse_mm fs/aio.c
--- a/fs/aio.c~use-activate_mm-in-fs-aiocuse_mm
+++ a/fs/aio.c
@@ -586,7 +586,7 @@ static void use_mm(struct mm_struct *mm)
 	 * Note that on UML this *requires* PF_BORROWED_MM to be set, otherwise
 	 * it won't work. Update it accordingly if you change it here
 	 */
-	activate_mm(active_mm, mm);
+	switch_mm(active_mm, mm, tsk);
 	task_unlock(tsk);
 
 	mmdrop(active_mm);
_

Patches currently in -mm which might be from jeremy@goop.org are

convert-i386-pda-code-to-use-%fs.patch
gtod-uninline-jiffiesh.patch

