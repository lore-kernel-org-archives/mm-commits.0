Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD6C2FC
	for <mm-commits@vger.kernel.org>; Wed, 19 Jun 2024 23:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718838609; cv=none; b=pwjvnSftFdPnLyYUhAwSRcbLbXoOAvmULPaTM/g2QbIxVCY/EHtUGjk1/DXYAR/NLrAPcOyI/py3BTjWYSXl0GKclIkyZQYIy5QCDX/O0ozNDd8smarr8gQitj6qdgMvGDTpVMtgSQA51Za0RmeoxaixmcG7p+F0ZmBiMxEP1fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718838609; c=relaxed/simple;
	bh=05C7BlEYWH2eSjD5u3IVfOmCPwcBmOIcuZeXrltCVtw=;
	h=Date:To:From:Subject:Message-Id; b=qSoMpg/m+/vfTmDayNSzCuutrsMZ2tzvmOkc04D0PCrZBx8lr2de7DrV2kE/ZKG4ah6RM3dHSgOFhyNoGoKUVvZRlcS21yJe65YNt0nx8i6wwE82VuhjnVtJgsdafbHTJQIGcVAT8l1vYutS9dSnJcIrDwcktnlETWHf2nNduEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jvr4HhDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jvr4HhDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F83CC2BBFC;
	Wed, 19 Jun 2024 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718838608;
	bh=05C7BlEYWH2eSjD5u3IVfOmCPwcBmOIcuZeXrltCVtw=;
	h=Date:To:From:Subject:From;
	b=Jvr4HhDA0DTlTXHQwWMXqAj6hw4GhDni8ikIlE02eyTwdDQ9MdaXTYrd3OMYTjxBj
	 2qHcDpggwuuVqb8j5xR3N/GCeNpyFUEx3zDH2sBYUz0ssxtSUprDIqhy4+gVhoZwhb
	 kRpsvANQSBwHMRCi3xYbzyeNsG5Tu5FaZXaGSILY=
Date: Wed, 19 Jun 2024 16:10:07 -0700
To: mm-commits@vger.kernel.org,naveen.n.rao@linux.ibm.com,mhiramat@kernel.org,kees@kernel.org,davem@davemloft.net,anil.s.keshavamurthy@intel.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-add-missing-module_description-macros-for-lib-test_ko.patch added to mm-nonmm-unstable branch
Message-Id: <20240619231008.5F83CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KUnit: add missing MODULE_DESCRIPTION() macros for lib/test_*.ko
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-add-missing-module_description-macros-for-lib-test_ko.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-add-missing-module_description-macros-for-lib-test_ko.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: KUnit: add missing MODULE_DESCRIPTION() macros for lib/test_*.ko
Date: Wed, 19 Jun 2024 13:59:15 -0700

make allmodconfig && make W=1 C=1 reports for lib/test_*.ko:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_hexdump.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_dhry.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_firmware.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_sysctl.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_hash.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_ida.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_list_sort.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_min_heap.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_module.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_sort.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_static_keys.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_static_key_base.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_memcat_p.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_blackhole_dev.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_meminit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_free_pages.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_kprobes.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_ref_tracker.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_bits.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240619-md-lib-test-v2-1-301e30eeba1e@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dhry_run.c             |    1 +
 lib/test-kstrtox.c         |    1 +
 lib/test_bits.c            |    1 +
 lib/test_blackhole_dev.c   |    1 +
 lib/test_firmware.c        |    1 +
 lib/test_free_pages.c      |    1 +
 lib/test_hash.c            |    1 +
 lib/test_hexdump.c         |    1 +
 lib/test_ida.c             |    1 +
 lib/test_kprobes.c         |    3 ++-
 lib/test_list_sort.c       |    1 +
 lib/test_memcat_p.c        |    1 +
 lib/test_meminit.c         |    1 +
 lib/test_min_heap.c        |    1 +
 lib/test_module.c          |    1 +
 lib/test_ref_tracker.c     |    3 ++-
 lib/test_sort.c            |    1 +
 lib/test_static_key_base.c |    1 +
 lib/test_static_keys.c     |    1 +
 lib/test_sysctl.c          |    1 +
 20 files changed, 22 insertions(+), 2 deletions(-)

--- a/lib/dhry_run.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/dhry_run.c
@@ -83,4 +83,5 @@ static int __init dhry_init(void)
 module_init(dhry_init);
 
 MODULE_AUTHOR("Geert Uytterhoeven <geert+renesas@glider.be>");
+MODULE_DESCRIPTION("Dhrystone benchmark test module");
 MODULE_LICENSE("GPL");
--- a/lib/test_bits.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_bits.c
@@ -72,4 +72,5 @@ static struct kunit_suite bits_test_suit
 };
 kunit_test_suite(bits_test_suite);
 
+MODULE_DESCRIPTION("Test cases for functions and macros in bits.h");
 MODULE_LICENSE("GPL");
--- a/lib/test_blackhole_dev.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_blackhole_dev.c
@@ -96,4 +96,5 @@ module_init(test_blackholedev_init);
 module_exit(test_blackholedev_exit);
 
 MODULE_AUTHOR("Mahesh Bandewar <maheshb@google.com>");
+MODULE_DESCRIPTION("module test of the blackhole_dev");
 MODULE_LICENSE("GPL");
--- a/lib/test_firmware.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_firmware.c
@@ -1567,4 +1567,5 @@ static void __exit test_firmware_exit(vo
 module_exit(test_firmware_exit);
 
 MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
+MODULE_DESCRIPTION("interface to trigger and test firmware loading");
 MODULE_LICENSE("GPL");
--- a/lib/test_free_pages.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_free_pages.c
@@ -44,4 +44,5 @@ static void m_ex(void)
 module_init(m_in);
 module_exit(m_ex);
 MODULE_AUTHOR("Matthew Wilcox <willy@infradead.org>");
+MODULE_DESCRIPTION("Check that free_pages() doesn't leak memory");
 MODULE_LICENSE("GPL");
--- a/lib/test_hash.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_hash.c
@@ -235,4 +235,5 @@ static struct kunit_suite hash_test_suit
 
 kunit_test_suite(hash_test_suite);
 
+MODULE_DESCRIPTION("Test cases for <linux/hash.h> and <linux/stringhash.h>");
 MODULE_LICENSE("GPL");
--- a/lib/test_hexdump.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_hexdump.c
@@ -253,4 +253,5 @@ static void __exit test_hexdump_exit(voi
 module_exit(test_hexdump_exit);
 
 MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
+MODULE_DESCRIPTION("Test cases for lib/hexdump.c module");
 MODULE_LICENSE("Dual BSD/GPL");
--- a/lib/test_ida.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_ida.c
@@ -214,4 +214,5 @@ static void ida_exit(void)
 module_init(ida_checks);
 module_exit(ida_exit);
 MODULE_AUTHOR("Matthew Wilcox <willy@infradead.org>");
+MODULE_DESCRIPTION("Test the IDA API");
 MODULE_LICENSE("GPL");
--- a/lib/test_kprobes.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_kprobes.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * test_kprobes.c - simple sanity test for *probes
+ * test_kprobes.c - simple sanity test for k*probes
  *
  * Copyright IBM Corp. 2008
  */
@@ -400,4 +400,5 @@ static struct kunit_suite kprobes_test_s
 
 kunit_test_suites(&kprobes_test_suite);
 
+MODULE_DESCRIPTION("simple sanity test for k*probes");
 MODULE_LICENSE("GPL");
--- a/lib/test-kstrtox.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test-kstrtox.c
@@ -732,4 +732,5 @@ static int __init test_kstrtox_init(void
 	return -EINVAL;
 }
 module_init(test_kstrtox_init);
+MODULE_DESCRIPTION("Module test for kstrto*() APIs");
 MODULE_LICENSE("Dual BSD/GPL");
--- a/lib/test_list_sort.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_list_sort.c
@@ -119,4 +119,5 @@ static struct kunit_suite list_sort_suit
 
 kunit_test_suites(&list_sort_suite);
 
+MODULE_DESCRIPTION("list_sort() KUnit test suite");
 MODULE_LICENSE("GPL");
--- a/lib/test_memcat_p.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_memcat_p.c
@@ -112,4 +112,5 @@ static void __exit test_memcat_p_exit(vo
 module_init(test_memcat_p_init);
 module_exit(test_memcat_p_exit);
 
+MODULE_DESCRIPTION("Test cases for memcat_p() in lib/memcat_p.c");
 MODULE_LICENSE("GPL");
--- a/lib/test_meminit.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_meminit.c
@@ -436,4 +436,5 @@ static int __init test_meminit_init(void
 }
 module_init(test_meminit_init);
 
+MODULE_DESCRIPTION("Test cases for SL[AOU]B/page initialization at alloc/free time");
 MODULE_LICENSE("GPL");
--- a/lib/test_min_heap.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_min_heap.c
@@ -226,4 +226,5 @@ static void __exit test_min_heap_exit(vo
 }
 module_exit(test_min_heap_exit);
 
+MODULE_DESCRIPTION("Test cases for the min max heap");
 MODULE_LICENSE("GPL");
--- a/lib/test_module.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_module.c
@@ -31,4 +31,5 @@ static void __exit test_module_exit(void
 module_exit(test_module_exit);
 
 MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
+MODULE_DESCRIPTION("module loading subsystem test module");
 MODULE_LICENSE("GPL");
--- a/lib/test_ref_tracker.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_ref_tracker.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Referrence tracker self test.
+ * Reference tracker self test.
  *
  * Copyright (c) 2021 Eric Dumazet <edumazet@google.com>
  */
@@ -112,4 +112,5 @@ static void __exit test_ref_tracker_exit
 module_init(test_ref_tracker_init);
 module_exit(test_ref_tracker_exit);
 
+MODULE_DESCRIPTION("Reference tracker self test");
 MODULE_LICENSE("GPL v2");
--- a/lib/test_sort.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_sort.c
@@ -57,4 +57,5 @@ static struct kunit_suite sort_test_suit
 
 kunit_test_suites(&sort_test_suite);
 
+MODULE_DESCRIPTION("sort() KUnit test suite");
 MODULE_LICENSE("GPL");
--- a/lib/test_static_key_base.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_static_key_base.c
@@ -57,4 +57,5 @@ module_init(test_static_key_base_init);
 module_exit(test_static_key_base_exit);
 
 MODULE_AUTHOR("Jason Baron <jbaron@akamai.com>");
+MODULE_DESCRIPTION("Kernel module to support testing static keys");
 MODULE_LICENSE("GPL");
--- a/lib/test_static_keys.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_static_keys.c
@@ -236,4 +236,5 @@ module_init(test_static_key_init);
 module_exit(test_static_key_exit);
 
 MODULE_AUTHOR("Jason Baron <jbaron@akamai.com>");
+MODULE_DESCRIPTION("Kernel module for testing static keys");
 MODULE_LICENSE("GPL");
--- a/lib/test_sysctl.c~kunit-add-missing-module_description-macros-for-lib-test_ko
+++ a/lib/test_sysctl.c
@@ -280,4 +280,5 @@ static void __exit test_sysctl_exit(void
 module_exit(test_sysctl_exit);
 
 MODULE_AUTHOR("Luis R. Rodriguez <mcgrof@kernel.org>");
+MODULE_DESCRIPTION("proc sysctl test driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
test_xarray-add-missing-module_description-macro.patch
ubsan-add-missing-module_description-macro.patch
test_maple_tree-add-the-missing-module_description-macro.patch
lib-test_hmm-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-for-lib-test_ko.patch

