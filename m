From: akpm@linux-foundation.org
Subject: + init-kconfig-add-option-to-disable-kernel-compression.patch
 added to -mm tree
Date: Tue, 08 Oct 2013 12:30:25 -0700
Message-ID: <52545d51.qlrN3yqplnd/wpxE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3JHTa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Oct 2013 15:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, christian.ruppert@abilis.com

Subject: + init-kconfig-add-option-to-disable-kernel-compression.patch added to -mm tree
To: christian.ruppert@abilis.com
From: akpm@linux-foundation.org
Date: Tue, 08 Oct 2013 12:30:25 -0700


The patch titled
     Subject: init/Kconfig: add option to disable kernel compression
has been added to the -mm tree.  Its filename is
     init-kconfig-add-option-to-disable-kernel-compression.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-kconfig-add-option-to-disable-kernel-compression.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-kconfig-add-option-to-disable-kernel-compression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christian Ruppert <christian.ruppert@abilis.com>
Subject: init/Kconfig: add option to disable kernel compression

Until now, kernel compression can only be disabled by deselecting
HAVE_<compression> in the architecture Kconfig. However, some
users/platforms within the same architecture might want to use
compression while others might want to disable it.
This patch is a solution to the dilemma.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~init-kconfig-add-option-to-disable-kernel-compression init/Kconfig
--- a/init/Kconfig~init-kconfig-add-option-to-disable-kernel-compression
+++ a/init/Kconfig
@@ -118,7 +118,6 @@ config HAVE_KERNEL_LZ4
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -137,6 +136,13 @@ choice
 
 	  If in doubt, select 'gzip'
 
+config KERNEL_UNCOMPRESSED
+	bool "No compression"
+	help
+	  No compression at all. The kernel is huge but the compression and
+	  decompression times are zero.
+	  This is usually not what you want.
+
 config KERNEL_GZIP
 	bool "Gzip"
 	depends on HAVE_KERNEL_GZIP
_

Patches currently in -mm which might be from christian.ruppert@abilis.com are

init-kconfig-add-option-to-disable-kernel-compression.patch

