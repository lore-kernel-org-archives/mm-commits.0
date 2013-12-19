From: akpm@linux-foundation.org
Subject: [merged] fix-build-with-make-380.patch removed from -mm tree
Date: Thu, 19 Dec 2013 11:54:07 -0800
Message-ID: <52b34edf.+mASIm+9Z3NBCOvY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab3LSTyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:54:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ppandit@redhat.com, jbeulich@suse.com, JBeulich@suse.com

Subject: [merged] fix-build-with-make-380.patch removed from -mm tree
To: JBeulich@suse.com,jbeulich@suse.com,ppandit@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:54:07 -0800


The patch titled
     Subject: fix build with make 3.80
has been removed from the -mm tree.  Its filename was
     fix-build-with-make-380.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: fix build with make 3.80

According to Documentation/Changes, make 3.80 is still being supported for
building the kernel, hence make files must not make (unconditional) use of
features introduced only in newer versions.  Commit 1bf49dd4 ("./Makefile:
export initial ramdisk compression config option") however introduced
"else ifeq" constructs which make 3.80 doesn't understand.  Replace the
logic there with more conventional (in the kernel build infrastructure)
list constructs (except that the list here is intentionally limited to
exactly one element).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: P J P <ppandit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN Makefile~fix-build-with-make-380 Makefile
--- a/Makefile~fix-build-with-make-380
+++ a/Makefile
@@ -732,19 +732,13 @@ export mod_strip_cmd
 # Select initial ramdisk compression format, default is gzip(1).
 # This shall be used by the dracut(8) tool while creating an initramfs image.
 #
-INITRD_COMPRESS=gzip
-ifeq ($(CONFIG_RD_BZIP2), y)
-        INITRD_COMPRESS=bzip2
-else ifeq ($(CONFIG_RD_LZMA), y)
-        INITRD_COMPRESS=lzma
-else ifeq ($(CONFIG_RD_XZ), y)
-        INITRD_COMPRESS=xz
-else ifeq ($(CONFIG_RD_LZO), y)
-        INITRD_COMPRESS=lzo
-else ifeq ($(CONFIG_RD_LZ4), y)
-        INITRD_COMPRESS=lz4
-endif
-export INITRD_COMPRESS
+INITRD_COMPRESS-y                  := gzip
+INITRD_COMPRESS-$(CONFIG_RD_BZIP2) := bzip2
+INITRD_COMPRESS-$(CONFIG_RD_LZMA)  := lzma
+INITRD_COMPRESS-$(CONFIG_RD_XZ)    := xz
+INITRD_COMPRESS-$(CONFIG_RD_LZO)   := lzo
+INITRD_COMPRESS-$(CONFIG_RD_LZ4)   := lz4
+export INITRD_COMPRESS := $(INITRD_COMPRESS-y)
 
 ifdef CONFIG_MODULE_SIG_ALL
 MODSECKEY = ./signing_key.priv
_

Patches currently in -mm which might be from JBeulich@suse.com are

origin.patch
lib-decompress_unlz4c-always-set-an-error-return-code-on-failures.patch
linux-next.patch

