From: akpm@linux-foundation.org
Subject: [merged] uml-use-simple_write_to_buffer.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:46 -0800
Message-ID: <201101132006.p0DK6RtE029748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782Ab1AMUHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: use simple_write_to_buffer()
has been removed from the -mm tree.  Its filename was
     uml-use-simple_write_to_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: use simple_write_to_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Simplify write file operation for mmapper by using
simple_write_to_buffer().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mmapper_kern.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/um/drivers/mmapper_kern.c~uml-use-simple_write_to_buffer arch/um/drivers/mmapper_kern.c
--- a/arch/um/drivers/mmapper_kern.c~uml-use-simple_write_to_buffer
+++ a/arch/um/drivers/mmapper_kern.c
@@ -37,13 +37,7 @@ static ssize_t mmapper_write(struct file
 	if (*ppos > mmapper_size)
 		return -EINVAL;
 
-	if (count > mmapper_size - *ppos)
-		count = mmapper_size - *ppos;
-
-	if (copy_from_user(&v_buf[*ppos], buf, count))
-		return -EFAULT;
