From: akpm@linux-foundation.org
Subject: + lib-rename-test_module-to-test_lkm.patch added to -mm tree
Date: Tue, 23 Sep 2014 15:28:45 -0700
Message-ID: <5421f41d.XSiu9sQPJFLkUgEo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaIWW2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 18:28:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valentinrothberg@gmail.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: rename TEST_MODULE to TEST_LKM
has been added to the -mm tree.  Its filename is
     lib-rename-test_module-to-test_lkm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-rename-test_module-to-test_lkm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-rename-test_module-to-test_lkm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: lib: rename TEST_MODULE to TEST_LKM

The "_MODULE" suffix is reserved for tristates compiled as loadable kernel
modules (LKM).  The "TEST_MODULE" feature thereby violates this
convention.  The feature is used to compile the lib/test_module.c kernel
module.

Sadly this convention is not made explicit, but the Kconfig code documents
it.  The following code (./scripts/kconfig/confdata.c) is used to generate
the autoconf.h header file during the build process.  When a feature is
selected as a kernel module ('m'), it is suffixed with "_MODULE" to
indicate it.  

	switch (*value) {
	case 'n':
		break;
	case 'm':
		suffix = "_MODULE";
		/* fall through */

This causes problems for static code analysis, which assumes a consistent
use of the "_MODULE" suffix.  

This patch renames the feature and its reference in a Makefile to
"TEST_LKM", which still expresses the test of a LKM.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 lib/Makefile      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~lib-rename-test_module-to-test_lkm lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-rename-test_module-to-test_lkm
+++ a/lib/Kconfig.debug
@@ -1636,7 +1636,7 @@ config DMA_API_DEBUG
 
 	  If unsure, say N.
 
-config TEST_MODULE
+config TEST_LKM
 	tristate "Test module loading with 'hello world' module"
 	default n
 	depends on m
diff -puN lib/Makefile~lib-rename-test_module-to-test_lkm lib/Makefile
--- a/lib/Makefile~lib-rename-test_module-to-test_lkm
+++ a/lib/Makefile
@@ -31,7 +31,7 @@ obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
-obj-$(CONFIG_TEST_MODULE) += test_module.o
+obj-$(CONFIG_TEST_LKM) += test_module.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
_

Patches currently in -mm which might be from valentinrothberg@gmail.com are

lib-rename-test_module-to-test_lkm.patch

