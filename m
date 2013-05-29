From: akpm@linux-foundation.org
Subject: + minix-bug-widening-a-binary-not-operation.patch added to -mm
 tree
Date: Wed, 29 May 2013 15:28:31 -0700
Message-ID: <51a6810f.UCp/bltPKelI0+0M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935390Ab3E2W2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 18:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, dan.carpenter@oracle.com

Subject: + minix-bug-widening-a-binary-not-operation.patch added to -mm tree
To: dan.carpenter@oracle.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 15:28:31 -0700


The patch titled
     Subject: minix: bug widening a binary "not" operation
has been added to the -mm tree.  Its filename is
     minix-bug-widening-a-binary-not-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: minix: bug widening a binary "not" operation

"chunk_size" is an unsigned int and "pos" is an unsigned long.  The
"& ~(chunk_size-1)" operation clears the high 32 bits unintentionally.

The ALIGN() macro does the correct thing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/dir.c~minix-bug-widening-a-binary-not-operation fs/minix/dir.c
--- a/fs/minix/dir.c~minix-bug-widening-a-binary-not-operation
+++ a/fs/minix/dir.c
@@ -95,7 +95,7 @@ static int minix_readdir(struct file * f
 	char *name;
 	__u32 inumber;
 
-	pos = (pos + chunk_size-1) & ~(chunk_size-1);
+	pos = ALIGN(pos, chunk_size);
 	if (pos >= inode->i_size)
 		goto done;
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
configfs-use-capped-length-for-store_attribute.patch
errh-is_err-can-accept-__user-pointers.patch
rbtree-remove-unneeded-include.patch
rbtree-remove-unneeded-include-fix.patch
minix-bug-widening-a-binary-not-operation.patch
documentation-codingstyle-allow-multiple-return-statements-per-function.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

