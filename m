From: akpm@linux-foundation.org
Subject: - proc-remove-dummy-vmcore_open.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:14:14 -0700
Message-ID: <200810152114.m9FLEE0B005725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbYJOVOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: remove dummy vmcore_open()
has been removed from the -mm tree.  Its filename was
     proc-remove-dummy-vmcore_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove dummy vmcore_open()
From: Alexey Dobriyan <adobriyan@gmail.com>

Empty ->open is equvivalent to always succeeding ->open.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/proc/vmcore.c~proc-remove-dummy-vmcore_open fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~proc-remove-dummy-vmcore_open
+++ a/fs/proc/vmcore.c
@@ -162,14 +162,8 @@ static ssize_t read_vmcore(struct file *
 	return acc;
 }
 
-static int open_vmcore(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
