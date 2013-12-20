From: akpm@linux-foundation.org
Subject: + makefile-fix-order-of-initrd_compress-y-assignments.patch added to -mm tree
Date: Fri, 20 Dec 2013 14:27:44 -0800
Message-ID: <52b4c460.2GRq3Nvc34Dq7k68%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab3LTW1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Dec 2013 17:27:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ppandit@redhat.com, jbeulich@suse.com, jlayton@redhat.com

Subject: + makefile-fix-order-of-initrd_compress-y-assignments.patch added to -mm tree
To: jlayton@redhat.com,jbeulich@suse.com,ppandit@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 20 Dec 2013 14:27:44 -0800


The patch titled
     Subject: Makefile: fix order of INITRD_COMPRESS-y assignments
has been added to the -mm tree.  Its filename is
     makefile-fix-order-of-initrd_compress-y-assignments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-fix-order-of-initrd_compress-y-assignments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-fix-order-of-initrd_compress-y-assignments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

makefile-fix-order-of-initrd_compress-y-assignments.patch
linux-next.patch

