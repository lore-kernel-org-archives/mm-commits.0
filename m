From: akpm@linux-foundation.org
Subject: [wrecked]
 makefile-fix-order-of-initrd_compress-y-assignments.patch removed from -mm
 tree
Date: Thu, 26 Dec 2013 13:16:45 -0800
Message-ID: <52bc9cbd.HxOPszFpqOeJgsls%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3LZVQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 16:16:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ppandit@redhat.com, jbeulich@suse.com, jlayton@redhat.com

Subject: [wrecked] makefile-fix-order-of-initrd_compress-y-assignments.patch removed from -mm tree
To: jlayton@redhat.com,jbeulich@suse.com,ppandit@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 13:16:45 -0800


The patch titled
     Subject: Makefile: fix order of INITRD_COMPRESS-y assignments
has been removed from the -mm tree.  Its filename was
     makefile-fix-order-of-initrd_compress-y-assignments.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: Makefile: fix order of INITRD_COMPRESS-y assignments

Commit 7ac181568342ec ("fix build with make 3.80") changed how the
Makefile handles the INITRD_COMPRESS-y assignment in order to make it work
properly with older versions of make.  Unfortunately, it also changes the
behavior of how that assignment works when multiple CONFIG_RD_* options
are set, such that they are now preferred in the reverse order of the way
they were before.

Reverse the order of assignments to try and preserve the earlier
precedence in this situation.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: P J P <ppandit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Makefile~makefile-fix-order-of-initrd_compress-y-assignments Makefile
--- a/Makefile~makefile-fix-order-of-initrd_compress-y-assignments
+++ a/Makefile
@@ -733,11 +733,11 @@ export mod_strip_cmd
 # This shall be used by the dracut(8) tool while creating an initramfs image.
 #
 INITRD_COMPRESS-y                  := gzip
-INITRD_COMPRESS-$(CONFIG_RD_BZIP2) := bzip2
-INITRD_COMPRESS-$(CONFIG_RD_LZMA)  := lzma
-INITRD_COMPRESS-$(CONFIG_RD_XZ)    := xz
-INITRD_COMPRESS-$(CONFIG_RD_LZO)   := lzo
 INITRD_COMPRESS-$(CONFIG_RD_LZ4)   := lz4
+INITRD_COMPRESS-$(CONFIG_RD_LZO)   := lzo
+INITRD_COMPRESS-$(CONFIG_RD_XZ)    := xz
+INITRD_COMPRESS-$(CONFIG_RD_LZMA)  := lzma
+INITRD_COMPRESS-$(CONFIG_RD_BZIP2) := bzip2
 export INITRD_COMPRESS := $(INITRD_COMPRESS-y)
 
 ifdef CONFIG_MODULE_SIG_ALL
_

Patches currently in -mm which might be from jlayton@redhat.com are

linux-next.patch

