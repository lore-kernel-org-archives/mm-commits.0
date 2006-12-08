From: akpm@osdl.org
Subject: + use-activate_mm-in-fs-aiocuse_mm.patch added to -mm tree
Date: Fri, 08 Dec 2006 15:47:55 -0800
Message-ID: <200612082347.kB8NltJk009481@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53113 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947475AbWLHXr7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 18:47:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org


The patch titled
     Use activate_mm() in fs/aio.c:use_mm()
has been added to the -mm tree.  Its filename is
     use-activate_mm-in-fs-aiocuse_mm.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
convert-i386-pda-code-to-use-%fs.patch
use-activate_mm-in-fs-aiocuse_mm.patch
time-uninline-jiffiesh-fix.patch

