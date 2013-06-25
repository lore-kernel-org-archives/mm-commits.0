From: akpm@linux-foundation.org
Subject: [alternative-merged]
 minix-bug-widening-a-binary-not-operation.patch removed from -mm tree
Date: Tue, 25 Jun 2013 12:19:38 -0700
Message-ID: <51c9ed4a.Upa04A6TEYlEI67m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3FYTTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:19:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, dan.carpenter@oracle.com

Subject: [alternative-merged] minix-bug-widening-a-binary-not-operation.patch removed from -mm tree
To: dan.carpenter@oracle.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:19:37 -0700


The patch titled
     Subject: minix: bug widening a binary "not" operation
has been removed from the -mm tree.  Its filename was
     minix-bug-widening-a-binary-not-operation.patch

This patch was dropped because an alternative patch was merged

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
fanotify-info-leak-in-copy_event_to_user.patch
configfs-use-capped-length-for-store_attribute.patch
drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch
mm-vmallocc-unbreak-__vunmap.patch
errh-is_err-can-accept-__user-pointers.patch
drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch
rbtree-remove-unneeded-include.patch
rbtree-remove-unneeded-include-fix.patch
documentation-codingstyle-allow-multiple-return-statements-per-function.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

