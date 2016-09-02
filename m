From: akpm@linux-foundation.org
Subject: [merged]
 kconfig-tinyconfig-provide-whole-choice-blocks-to-avoid-warnings.patch
 removed from -mm tree
Date: Fri, 02 Sep 2016 12:00:52 -0700
Message-ID: <57c9cc64.ke2IysPvLOa8JBVA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32975 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753900AbcIBTAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2016 15:00:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, josh@joshtriplett.org, mingo@kernel.org, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig: tinyconfig: provide whole choice blocks to avoid warnings
has been removed from the -mm tree.  Its filename was
     kconfig-tinyconfig-provide-whole-choice-blocks-to-avoid-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kconfig: tinyconfig: provide whole choice blocks to avoid warnings

Using "make tinyconfig" produces a couple of annoying warnings that show up
for build test machines all the time:

    .config:966:warning: override: NOHIGHMEM changes choice state
    .config:965:warning: override: SLOB changes choice state
    .config:963:warning: override: KERNEL_XZ changes choice state
    .config:962:warning: override: CC_OPTIMIZE_FOR_SIZE changes choice state
    .config:933:warning: override: SLOB changes choice state
    .config:930:warning: override: CC_OPTIMIZE_FOR_SIZE changes choice state
    .config:870:warning: override: SLOB changes choice state
    .config:868:warning: override: KERNEL_XZ changes choice state
    .config:867:warning: override: CC_OPTIMIZE_FOR_SIZE changes choice state

I've made a previous attempt at fixing them and we discussed a number of
alternatives.

I tried changing the Makefile to use "merge_config.sh -n $(fragment-list)"
but couldn't get that to work properly.

This is yet another approach, based on the observation that we do want
to see a warning for conflicting 'choice' options, and that we can simply
make them non-conflicting by listing all other options as disabled.
This is a trivial patch that we can apply independent of plans for other
changes.

Link: http://lkml.kernel.org/r/20160829214952.1334674-2-arnd@arndb.de
Link: https://storage.kernelci.org/mainline/v4.7-rc6/x86-tinyconfig/build.log
https://patchwork.kernel.org/patch/9212749/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/configs/tiny.config |    2 ++
 kernel/configs/tiny.config   |    8 ++++++++
 2 files changed, 10 insertions(+)

diff -puN arch/x86/configs/tiny.config~kconfig-tinyconfig-provide-whole-choice-blocks-to-avoid-warnings arch/x86/configs/tiny.config
--- a/arch/x86/configs/tiny.config~kconfig-tinyconfig-provide-whole-choice-blocks-to-avoid-warnings
+++ a/arch/x86/configs/tiny.config
@@ -1 +1,3 @@
 CONFIG_NOHIGHMEM=y
+# CONFIG_HIGHMEM4G is not set
+# CONFIG_HIGHMEM64G is not set
diff -puN kernel/configs/tiny.config~kconfig-tinyconfig-provide-whole-choice-blocks-to-avoid-warnings kernel/configs/tiny.config
--- a/kernel/configs/tiny.config~kconfig-tinyconfig-provide-whole-choice-blocks-to-avoid-warnings
+++ a/kernel/configs/tiny.config
@@ -1,4 +1,12 @@
+# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+# CONFIG_KERNEL_GZIP is not set
+# CONFIG_KERNEL_BZIP2 is not set
+# CONFIG_KERNEL_LZMA is not set
 CONFIG_KERNEL_XZ=y
+# CONFIG_KERNEL_LZO is not set
+# CONFIG_KERNEL_LZ4 is not set
 CONFIG_OPTIMIZE_INLINING=y
+# CONFIG_SLAB is not set
+# CONFIG_SLUB is not set
 CONFIG_SLOB=y
_

Patches currently in -mm which might be from arnd@arndb.de are

compat-remove-compat_printk.patch

