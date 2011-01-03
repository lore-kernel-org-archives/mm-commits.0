From: akpm@linux-foundation.org
Subject: + uml-use-simple_write_to_buffer.patch added to -mm tree
Date: Mon, 03 Jan 2011 13:10:33 -0800
Message-ID: <201101032110.p03LAXMF028672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155Ab1ACVKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 16:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, jdike@addtoit.com


The patch titled
     uml: use simple_write_to_buffer()
has been added to the -mm tree.  Its filename is
     uml-use-simple_write_to_buffer.patch

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
-
-	return count;
+	return simple_write_to_buffer(v_buf, mmapper_size, ppos, buf, count);
 }
 
 static long mmapper_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

uml-use-simple_write_to_buffer.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
bitops-introduce-config_generic_find_le_bit.patch
m68knommu-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops-build-fix.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
rds-stop-including-asm-generic-bitops-leh.patch
kvm-stop-including-asm-generic-bitops-leh.patch
asm-generic-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch

