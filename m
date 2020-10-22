Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC74C388F7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35CEB24641
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603407016;
	bh=7/7hvUSPwkucN954yRYq1YM+c+iG1xrBPgyL3vLps50=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=09hWnxK5ROYBUNrtCdyXfg1x1aMhuKjk5SotwtlomI8CIYsYo/f+4ncFCv3ukAELl
	 TOP5JCdoKC3kyzFzrA2d7wFJluwHu1cstT3lhSAH4IFM0Y3NUYWVsefFGnvhjUSq33
	 GEpfymbulW9CMW29dRNKxWc/bqenc0FuADyA4fbw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373091AbgJVWuP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 18:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S372983AbgJVWuP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 18:50:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91C88221EB;
        Thu, 22 Oct 2020 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603407012;
        bh=7/7hvUSPwkucN954yRYq1YM+c+iG1xrBPgyL3vLps50=;
        h=Date:From:To:Subject:From;
        b=m/IMKjfNCP8PKj7YeYGBRTjWLqDZ4ARWR76mZhNfu5arz5e2cn5df2Yt7+DoWLaYO
         0K0VTYQFV2Q5Hwd/WiTQM2HyV4pew691sArZ1C4ZN9C+JhSZjHkMOAPMQONVRokw0p
         ExVDKo9xQZxs/uQzlgKDnJodszQOTnh76ITyM9gY=
Date:   Thu, 22 Oct 2020 15:50:12 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [to-be-updated]
 mm-gup_benchmark-rename-to-mm-gup_test.patch removed from -mm tree
Message-ID: <20201022225012.3Hs3wSEU0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_benchmark: rename to mm/gup_test
has been removed from the -mm tree.  Its filename was
     mm-gup_benchmark-rename-to-mm-gup_test.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup_benchmark: rename to mm/gup_test

Patch series "selftests/vm: gup_test, hmm-tests, assorted improvements", v2.

This series provides two main things, and a number of smaller supporting
goodies.  The two main points are:

1) Add a new sub-test to gup_test, which in turn is a renamed version
   of gup_benchmark.  This sub-test allows nicer testing of dump_pages(),
   at least on user-space pages.

   For quite a while, I was doing a quick hack to gup_test.c whenever I
   wanted to try out changes to dump_page().  Then Matthew Wilcox asked me
   what I meant when I said "I used my dump_page() unit test", and I
   realized that it might be nice to check in a polished up version of
   that.

   Details about how it works and how to use it are in the commit
   description for patch #6.

2) Fixes a limitation of hmm-tests: these tests are incredibly useful,
   but only if people actually build and run them.  And it turns out that
   libhugetlbfs is a little too effective at throwing a wrench in the
   works, there.  So I've added a little configuration check that removes
   just two of the 21 hmm-tests, if libhugetlbfs is not available.

   Further details in the commit description of patch #8.

Other smaller things that this series does:

a) Remove code duplication by creating gup_test.h.

b) Clear up the sub-test organization, and their invocation within
   run_vmtests.sh.

c) Other minor assorted improvements.


This patch (of 8):

Rename nearly every "gup_benchmark" reference and file name to "gup_test".
The one exception is for the actual gup benchmark test itself.

The current code already does a *little* bit more than benchmarking, and
definitely covers more than get_user_pages_fast().  More importantly,
however, subsequent patches are about to add some functionality that is
non-benchmark related.

Closely related changes:

* Kconfig: in addition to renaming the options from GUP_BENCHMARK to
  GUP_TEST, update the help text to reflect that it's no longer a
  benchmark-only test.

Link: https://lkml.kernel.org/r/20200929212747.251804-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20200929212747.251804-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
CC: Jonathan Corbet <corbet@lwn.net>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst  |    6=20
 arch/s390/configs/debug_defconfig          |    2=20
 arch/s390/configs/defconfig                |    2=20
 mm/Kconfig                                 |   15 -
 mm/Makefile                                |    2=20
 mm/gup_benchmark.c                         |  210 -------------------
 mm/gup_test.c                              |  210 +++++++++++++++++++
 tools/testing/selftests/vm/.gitignore      |    2=20
 tools/testing/selftests/vm/Makefile        |    2=20
 tools/testing/selftests/vm/config          |    2=20
 tools/testing/selftests/vm/gup_benchmark.c |  143 ------------
 tools/testing/selftests/vm/gup_test.c      |  143 ++++++++++++
 tools/testing/selftests/vm/run_vmtests     |    8=20
 13 files changed, 376 insertions(+), 371 deletions(-)

--- a/arch/s390/configs/debug_defconfig~mm-gup_benchmark-rename-to-mm-gup_t=
est
+++ a/arch/s390/configs/debug_defconfig
@@ -100,7 +100,7 @@ CONFIG_ZSMALLOC_STAT=3Dy
 CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dy
 CONFIG_IDLE_PAGE_TRACKING=3Dy
 CONFIG_PERCPU_STATS=3Dy
-CONFIG_GUP_BENCHMARK=3Dy
+CONFIG_GUP_TEST=3Dy
 CONFIG_NET=3Dy
 CONFIG_PACKET=3Dy
 CONFIG_PACKET_DIAG=3Dm
--- a/arch/s390/configs/defconfig~mm-gup_benchmark-rename-to-mm-gup_test
+++ a/arch/s390/configs/defconfig
@@ -94,7 +94,7 @@ CONFIG_ZSMALLOC_STAT=3Dy
 CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dy
 CONFIG_IDLE_PAGE_TRACKING=3Dy
 CONFIG_PERCPU_STATS=3Dy
-CONFIG_GUP_BENCHMARK=3Dy
+CONFIG_GUP_TEST=3Dy
 CONFIG_NET=3Dy
 CONFIG_PACKET=3Dy
 CONFIG_PACKET_DIAG=3Dm
--- a/Documentation/core-api/pin_user_pages.rst~mm-gup_benchmark-rename-to-=
mm-gup_test
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -221,12 +221,12 @@ Unit testing
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 This file::
=20
- tools/testing/selftests/vm/gup_benchmark.c
+ tools/testing/selftests/vm/gup_test.c
=20
 has the following new calls to exercise the new pin*() wrapper functions:
=20
-* PIN_FAST_BENCHMARK (./gup_benchmark -a)
-* PIN_BENCHMARK (./gup_benchmark -b)
+* PIN_FAST_BENCHMARK (./gup_test -a)
+* PIN_BENCHMARK (./gup_test -b)
=20
 You can monitor how many total dma-pinned pages have been acquired and rel=
eased
 since the system was booted, via two new /proc/vmstat entries: ::
--- a/mm/gup_benchmark.c
+++ /dev/null
@@ -1,210 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/uaccess.h>
-#include <linux/ktime.h>
-#include <linux/debugfs.h>
-
-#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
-#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_benchmark)
-#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_benchmark)
-#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_benchmark)
-#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
-
-struct gup_benchmark {
-	__u64 get_delta_usec;
-	__u64 put_delta_usec;
-	__u64 addr;
-	__u64 size;
-	__u32 nr_pages_per_call;
-	__u32 flags;
-	__u64 expansion[10];	/* For future use */
-};
-
-static void put_back_pages(unsigned int cmd, struct page **pages,
-			   unsigned long nr_pages)
-{
-	unsigned long i;
-
-	switch (cmd) {
-	case GUP_FAST_BENCHMARK:
-	case GUP_BENCHMARK:
-		for (i =3D 0; i < nr_pages; i++)
-			put_page(pages[i]);
-		break;
-
-	case PIN_FAST_BENCHMARK:
-	case PIN_BENCHMARK:
-	case PIN_LONGTERM_BENCHMARK:
-		unpin_user_pages(pages, nr_pages);
-		break;
-	}
-}
-
-static void verify_dma_pinned(unsigned int cmd, struct page **pages,
-			      unsigned long nr_pages)
-{
-	unsigned long i;
-	struct page *page;
-
-	switch (cmd) {
-	case PIN_FAST_BENCHMARK:
-	case PIN_BENCHMARK:
-	case PIN_LONGTERM_BENCHMARK:
-		for (i =3D 0; i < nr_pages; i++) {
-			page =3D pages[i];
-			if (WARN(!page_maybe_dma_pinned(page),
-				 "pages[%lu] is NOT dma-pinned\n", i)) {
-
-				dump_page(page, "gup_benchmark failure");
-				break;
-			}
-		}
-		break;
-	}
-}
-
-static int __gup_benchmark_ioctl(unsigned int cmd,
-		struct gup_benchmark *gup)
-{
-	ktime_t start_time, end_time;
-	unsigned long i, nr_pages, addr, next;
-	int nr;
-	struct page **pages;
-	int ret =3D 0;
-	bool needs_mmap_lock =3D
-		cmd !=3D GUP_FAST_BENCHMARK && cmd !=3D PIN_FAST_BENCHMARK;
-
-	if (gup->size > ULONG_MAX)
-		return -EINVAL;
-
-	nr_pages =3D gup->size / PAGE_SIZE;
-	pages =3D kvcalloc(nr_pages, sizeof(void *), GFP_KERNEL);
-	if (!pages)
-		return -ENOMEM;
-
-	if (needs_mmap_lock && mmap_read_lock_killable(current->mm)) {
-		ret =3D -EINTR;
-		goto free_pages;
-	}
-
-	i =3D 0;
-	nr =3D gup->nr_pages_per_call;
-	start_time =3D ktime_get();
-	for (addr =3D gup->addr; addr < gup->addr + gup->size; addr =3D next) {
-		if (nr !=3D gup->nr_pages_per_call)
-			break;
-
-		next =3D addr + nr * PAGE_SIZE;
-		if (next > gup->addr + gup->size) {
-			next =3D gup->addr + gup->size;
-			nr =3D (next - addr) / PAGE_SIZE;
-		}
-
-		/* Filter out most gup flags: only allow a tiny subset here: */
-		gup->flags &=3D FOLL_WRITE;
-
-		switch (cmd) {
-		case GUP_FAST_BENCHMARK:
-			nr =3D get_user_pages_fast(addr, nr, gup->flags,
-						 pages + i);
-			break;
-		case GUP_BENCHMARK:
-			nr =3D get_user_pages(addr, nr, gup->flags, pages + i,
-					    NULL);
-			break;
-		case PIN_FAST_BENCHMARK:
-			nr =3D pin_user_pages_fast(addr, nr, gup->flags,
-						 pages + i);
-			break;
-		case PIN_BENCHMARK:
-			nr =3D pin_user_pages(addr, nr, gup->flags, pages + i,
-					    NULL);
-			break;
-		case PIN_LONGTERM_BENCHMARK:
-			nr =3D pin_user_pages(addr, nr,
-					    gup->flags | FOLL_LONGTERM,
-					    pages + i, NULL);
-			break;
-		default:
-			ret =3D -EINVAL;
-			goto unlock;
-		}
-
-		if (nr <=3D 0)
-			break;
-		i +=3D nr;
-	}
-	end_time =3D ktime_get();
-
-	/* Shifting the meaning of nr_pages: now it is actual number pinned: */
-	nr_pages =3D i;
-
-	gup->get_delta_usec =3D ktime_us_delta(end_time, start_time);
-	gup->size =3D addr - gup->addr;
-
-	/*
-	 * Take an un-benchmark-timed moment to verify DMA pinned
-	 * state: print a warning if any non-dma-pinned pages are found:
-	 */
-	verify_dma_pinned(cmd, pages, nr_pages);
-
-	start_time =3D ktime_get();
-
-	put_back_pages(cmd, pages, nr_pages);
-
-	end_time =3D ktime_get();
-	gup->put_delta_usec =3D ktime_us_delta(end_time, start_time);
-
-unlock:
-	if (needs_mmap_lock)
-		mmap_read_unlock(current->mm);
-free_pages:
-	kvfree(pages);
-	return ret;
-}
-
-static long gup_benchmark_ioctl(struct file *filep, unsigned int cmd,
-		unsigned long arg)
-{
-	struct gup_benchmark gup;
-	int ret;
-
-	switch (cmd) {
-	case GUP_FAST_BENCHMARK:
-	case GUP_BENCHMARK:
-	case PIN_FAST_BENCHMARK:
-	case PIN_BENCHMARK:
-	case PIN_LONGTERM_BENCHMARK:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (copy_from_user(&gup, (void __user *)arg, sizeof(gup)))
-		return -EFAULT;
-
-	ret =3D __gup_benchmark_ioctl(cmd, &gup);
-	if (ret)
-		return ret;
-
-	if (copy_to_user((void __user *)arg, &gup, sizeof(gup)))
-		return -EFAULT;
-
-	return 0;
-}
-
-static const struct file_operations gup_benchmark_fops =3D {
-	.open =3D nonseekable_open,
-	.unlocked_ioctl =3D gup_benchmark_ioctl,
-};
-
-static int gup_benchmark_init(void)
-{
-	debugfs_create_file_unsafe("gup_benchmark", 0600, NULL, NULL,
-				   &gup_benchmark_fops);
-
-	return 0;
-}
-
-late_initcall(gup_benchmark_init);
--- /dev/null
+++ a/mm/gup_test.c
@@ -0,0 +1,210 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/ktime.h>
+#include <linux/debugfs.h>
+
+#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_test)
+#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_test)
+#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_test)
+#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_test)
+#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_test)
+
+struct gup_test {
+	__u64 get_delta_usec;
+	__u64 put_delta_usec;
+	__u64 addr;
+	__u64 size;
+	__u32 nr_pages_per_call;
+	__u32 flags;
+	__u64 expansion[10];	/* For future use */
+};
+
+static void put_back_pages(unsigned int cmd, struct page **pages,
+			   unsigned long nr_pages)
+{
+	unsigned long i;
+
+	switch (cmd) {
+	case GUP_FAST_BENCHMARK:
+	case GUP_BENCHMARK:
+		for (i =3D 0; i < nr_pages; i++)
+			put_page(pages[i]);
+		break;
+
+	case PIN_FAST_BENCHMARK:
+	case PIN_BENCHMARK:
+	case PIN_LONGTERM_BENCHMARK:
+		unpin_user_pages(pages, nr_pages);
+		break;
+	}
+}
+
+static void verify_dma_pinned(unsigned int cmd, struct page **pages,
+			      unsigned long nr_pages)
+{
+	unsigned long i;
+	struct page *page;
+
+	switch (cmd) {
+	case PIN_FAST_BENCHMARK:
+	case PIN_BENCHMARK:
+	case PIN_LONGTERM_BENCHMARK:
+		for (i =3D 0; i < nr_pages; i++) {
+			page =3D pages[i];
+			if (WARN(!page_maybe_dma_pinned(page),
+				 "pages[%lu] is NOT dma-pinned\n", i)) {
+
+				dump_page(page, "gup_test failure");
+				break;
+			}
+		}
+		break;
+	}
+}
+
+static int __gup_test_ioctl(unsigned int cmd,
+		struct gup_test *gup)
+{
+	ktime_t start_time, end_time;
+	unsigned long i, nr_pages, addr, next;
+	int nr;
+	struct page **pages;
+	int ret =3D 0;
+	bool needs_mmap_lock =3D
+		cmd !=3D GUP_FAST_BENCHMARK && cmd !=3D PIN_FAST_BENCHMARK;
+
+	if (gup->size > ULONG_MAX)
+		return -EINVAL;
+
+	nr_pages =3D gup->size / PAGE_SIZE;
+	pages =3D kvcalloc(nr_pages, sizeof(void *), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	if (needs_mmap_lock && mmap_read_lock_killable(current->mm)) {
+		ret =3D -EINTR;
+		goto free_pages;
+	}
+
+	i =3D 0;
+	nr =3D gup->nr_pages_per_call;
+	start_time =3D ktime_get();
+	for (addr =3D gup->addr; addr < gup->addr + gup->size; addr =3D next) {
+		if (nr !=3D gup->nr_pages_per_call)
+			break;
+
+		next =3D addr + nr * PAGE_SIZE;
+		if (next > gup->addr + gup->size) {
+			next =3D gup->addr + gup->size;
+			nr =3D (next - addr) / PAGE_SIZE;
+		}
+
+		/* Filter out most gup flags: only allow a tiny subset here: */
+		gup->flags &=3D FOLL_WRITE;
+
+		switch (cmd) {
+		case GUP_FAST_BENCHMARK:
+			nr =3D get_user_pages_fast(addr, nr, gup->flags,
+						 pages + i);
+			break;
+		case GUP_BENCHMARK:
+			nr =3D get_user_pages(addr, nr, gup->flags, pages + i,
+					    NULL);
+			break;
+		case PIN_FAST_BENCHMARK:
+			nr =3D pin_user_pages_fast(addr, nr, gup->flags,
+						 pages + i);
+			break;
+		case PIN_BENCHMARK:
+			nr =3D pin_user_pages(addr, nr, gup->flags, pages + i,
+					    NULL);
+			break;
+		case PIN_LONGTERM_BENCHMARK:
+			nr =3D pin_user_pages(addr, nr,
+					    gup->flags | FOLL_LONGTERM,
+					    pages + i, NULL);
+			break;
+		default:
+			ret =3D -EINVAL;
+			goto unlock;
+		}
+
+		if (nr <=3D 0)
+			break;
+		i +=3D nr;
+	}
+	end_time =3D ktime_get();
+
+	/* Shifting the meaning of nr_pages: now it is actual number pinned: */
+	nr_pages =3D i;
+
+	gup->get_delta_usec =3D ktime_us_delta(end_time, start_time);
+	gup->size =3D addr - gup->addr;
+
+	/*
+	 * Take an un-benchmark-timed moment to verify DMA pinned
+	 * state: print a warning if any non-dma-pinned pages are found:
+	 */
+	verify_dma_pinned(cmd, pages, nr_pages);
+
+	start_time =3D ktime_get();
+
+	put_back_pages(cmd, pages, nr_pages);
+
+	end_time =3D ktime_get();
+	gup->put_delta_usec =3D ktime_us_delta(end_time, start_time);
+
+unlock:
+	if (needs_mmap_lock)
+		mmap_read_unlock(current->mm);
+free_pages:
+	kvfree(pages);
+	return ret;
+}
+
+static long gup_test_ioctl(struct file *filep, unsigned int cmd,
+		unsigned long arg)
+{
+	struct gup_test gup;
+	int ret;
+
+	switch (cmd) {
+	case GUP_FAST_BENCHMARK:
+	case GUP_BENCHMARK:
+	case PIN_FAST_BENCHMARK:
+	case PIN_BENCHMARK:
+	case PIN_LONGTERM_BENCHMARK:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (copy_from_user(&gup, (void __user *)arg, sizeof(gup)))
+		return -EFAULT;
+
+	ret =3D __gup_test_ioctl(cmd, &gup);
+	if (ret)
+		return ret;
+
+	if (copy_to_user((void __user *)arg, &gup, sizeof(gup)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static const struct file_operations gup_test_fops =3D {
+	.open =3D nonseekable_open,
+	.unlocked_ioctl =3D gup_test_ioctl,
+};
+
+static int gup_test_init(void)
+{
+	debugfs_create_file_unsafe("gup_test", 0600, NULL, NULL,
+				   &gup_test_fops);
+
+	return 0;
+}
+
+late_initcall(gup_test_init);
--- a/mm/Kconfig~mm-gup_benchmark-rename-to-mm-gup_test
+++ a/mm/Kconfig
@@ -831,13 +831,18 @@ config PERCPU_STATS
 	  information includes global and per chunk statistics, which can
 	  be used to help understand percpu memory usage.
=20
-config GUP_BENCHMARK
-	bool "Enable infrastructure for get_user_pages() and related calls benchm=
arking"
+config GUP_TEST
+	bool "Enable infrastructure for get_user_pages()-related unit tests"
 	help
-	  Provides /sys/kernel/debug/gup_benchmark that helps with testing
-	  performance of get_user_pages() and related calls.
+	  Provides /sys/kernel/debug/gup_test, which in turn provides a way
+	  to make ioctl calls that can launch kernel-based unit tests for
+	  the get_user_pages*() and pin_user_pages*() family of API calls.
=20
-	  See tools/testing/selftests/vm/gup_benchmark.c
+	  These tests include benchmark testing of the _fast variants of
+	  get_user_pages*() and pin_user_pages*(), as well as smoke tests of
+	  the non-_fast variants.
+
+	  See tools/testing/selftests/vm/gup_test.c
=20
 config GUP_GET_PTE_LOW_HIGH
 	bool
--- a/mm/Makefile~mm-gup_benchmark-rename-to-mm-gup_test
+++ a/mm/Makefile
@@ -90,7 +90,7 @@ obj-$(CONFIG_PAGE_COUNTER) +=3D page_count
 obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
 obj-$(CONFIG_MEMCG_SWAP) +=3D swap_cgroup.o
 obj-$(CONFIG_CGROUP_HUGETLB) +=3D hugetlb_cgroup.o
-obj-$(CONFIG_GUP_BENCHMARK) +=3D gup_benchmark.o
+obj-$(CONFIG_GUP_TEST) +=3D gup_test.o
 obj-$(CONFIG_MEMORY_FAILURE) +=3D memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) +=3D hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) +=3D kmemleak.o
--- a/tools/testing/selftests/vm/config~mm-gup_benchmark-rename-to-mm-gup_t=
est
+++ a/tools/testing/selftests/vm/config
@@ -3,4 +3,4 @@ CONFIG_USERFAULTFD=3Dy
 CONFIG_TEST_VMALLOC=3Dm
 CONFIG_DEVICE_PRIVATE=3Dy
 CONFIG_TEST_HMM=3Dm
-CONFIG_GUP_BENCHMARK=3Dy
+CONFIG_GUP_TEST=3Dy
--- a/tools/testing/selftests/vm/.gitignore~mm-gup_benchmark-rename-to-mm-g=
up_test
+++ a/tools/testing/selftests/vm/.gitignore
@@ -15,7 +15,7 @@ userfaultfd
 mlock-intersect-test
 mlock-random-test
 virtual_address_range
-gup_benchmark
+gup_test
 va_128TBswitch
 map_fixed_noreplace
 write_to_hugetlbfs
--- a/tools/testing/selftests/vm/gup_benchmark.c
+++ /dev/null
@@ -1,143 +0,0 @@
-#include <fcntl.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-
-#include <sys/ioctl.h>
-#include <sys/mman.h>
-#include <sys/prctl.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-
-#include <linux/types.h>
-
-#define MB (1UL << 20)
-#define PAGE_SIZE sysconf(_SC_PAGESIZE)
-
-#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
-#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_benchmark)
-
-/* Similar to above, but use FOLL_PIN instead of FOLL_GET. */
-#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_benchmark)
-#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_benchmark)
-#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
-
-/* Just the flags we need, copied from mm.h: */
-#define FOLL_WRITE	0x01	/* check pte is writable */
-
-struct gup_benchmark {
-	__u64 get_delta_usec;
-	__u64 put_delta_usec;
-	__u64 addr;
-	__u64 size;
-	__u32 nr_pages_per_call;
-	__u32 flags;
-	__u64 expansion[10];	/* For future use */
-};
-
-int main(int argc, char **argv)
-{
-	struct gup_benchmark gup;
-	unsigned long size =3D 128 * MB;
-	int i, fd, filed, opt, nr_pages =3D 1, thp =3D -1, repeats =3D 1, write =
=3D 0;
-	int cmd =3D GUP_FAST_BENCHMARK, flags =3D MAP_PRIVATE;
-	char *file =3D "/dev/zero";
-	char *p;
-
-	while ((opt =3D getopt(argc, argv, "m:r:n:f:abtTLUuwSH")) !=3D -1) {
-		switch (opt) {
-		case 'a':
-			cmd =3D PIN_FAST_BENCHMARK;
-			break;
-		case 'b':
-			cmd =3D PIN_BENCHMARK;
-			break;
-		case 'L':
-			cmd =3D PIN_LONGTERM_BENCHMARK;
-			break;
-		case 'm':
-			size =3D atoi(optarg) * MB;
-			break;
-		case 'r':
-			repeats =3D atoi(optarg);
-			break;
-		case 'n':
-			nr_pages =3D atoi(optarg);
-			break;
-		case 't':
-			thp =3D 1;
-			break;
-		case 'T':
-			thp =3D 0;
-			break;
-		case 'U':
-			cmd =3D GUP_BENCHMARK;
-			break;
-		case 'u':
-			cmd =3D GUP_FAST_BENCHMARK;
-			break;
-		case 'w':
-			write =3D 1;
-			break;
-		case 'f':
-			file =3D optarg;
-			break;
-		case 'S':
-			flags &=3D ~MAP_PRIVATE;
-			flags |=3D MAP_SHARED;
-			break;
-		case 'H':
-			flags |=3D (MAP_HUGETLB | MAP_ANONYMOUS);
-			break;
-		default:
-			return -1;
-		}
-	}
-
-	filed =3D open(file, O_RDWR|O_CREAT);
-	if (filed < 0) {
-		perror("open");
-		exit(filed);
-	}
-
-	gup.nr_pages_per_call =3D nr_pages;
-	if (write)
-		gup.flags |=3D FOLL_WRITE;
-
-	fd =3D open("/sys/kernel/debug/gup_benchmark", O_RDWR);
-	if (fd =3D=3D -1) {
-		perror("open");
-		exit(1);
-	}
-
-	p =3D mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
-	if (p =3D=3D MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
-	gup.addr =3D (unsigned long)p;
-
-	if (thp =3D=3D 1)
-		madvise(p, size, MADV_HUGEPAGE);
-	else if (thp =3D=3D 0)
-		madvise(p, size, MADV_NOHUGEPAGE);
-
-	for (; (unsigned long)p < gup.addr + size; p +=3D PAGE_SIZE)
-		p[0] =3D 0;
-
-	for (i =3D 0; i < repeats; i++) {
-		gup.size =3D size;
-		if (ioctl(fd, cmd, &gup)) {
-			perror("ioctl");
-			exit(1);
-		}
-
-		printf("Time: get:%lld put:%lld us", gup.get_delta_usec,
-			gup.put_delta_usec);
-		if (gup.size !=3D size)
-			printf(", truncated (size: %lld)", gup.size);
-		printf("\n");
-	}
-
-	return 0;
-}
--- /dev/null
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -0,0 +1,143 @@
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include <linux/types.h>
+
+#define MB (1UL << 20)
+#define PAGE_SIZE sysconf(_SC_PAGESIZE)
+
+#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
+#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_benchmark)
+
+/* Similar to above, but use FOLL_PIN instead of FOLL_GET. */
+#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_benchmark)
+#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_benchmark)
+#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
+
+/* Just the flags we need, copied from mm.h: */
+#define FOLL_WRITE	0x01	/* check pte is writable */
+
+struct gup_benchmark {
+	__u64 get_delta_usec;
+	__u64 put_delta_usec;
+	__u64 addr;
+	__u64 size;
+	__u32 nr_pages_per_call;
+	__u32 flags;
+	__u64 expansion[10];	/* For future use */
+};
+
+int main(int argc, char **argv)
+{
+	struct gup_benchmark gup;
+	unsigned long size =3D 128 * MB;
+	int i, fd, filed, opt, nr_pages =3D 1, thp =3D -1, repeats =3D 1, write =
=3D 0;
+	int cmd =3D GUP_FAST_BENCHMARK, flags =3D MAP_PRIVATE;
+	char *file =3D "/dev/zero";
+	char *p;
+
+	while ((opt =3D getopt(argc, argv, "m:r:n:f:abtTLUuwSH")) !=3D -1) {
+		switch (opt) {
+		case 'a':
+			cmd =3D PIN_FAST_BENCHMARK;
+			break;
+		case 'b':
+			cmd =3D PIN_BENCHMARK;
+			break;
+		case 'L':
+			cmd =3D PIN_LONGTERM_BENCHMARK;
+			break;
+		case 'm':
+			size =3D atoi(optarg) * MB;
+			break;
+		case 'r':
+			repeats =3D atoi(optarg);
+			break;
+		case 'n':
+			nr_pages =3D atoi(optarg);
+			break;
+		case 't':
+			thp =3D 1;
+			break;
+		case 'T':
+			thp =3D 0;
+			break;
+		case 'U':
+			cmd =3D GUP_BENCHMARK;
+			break;
+		case 'u':
+			cmd =3D GUP_FAST_BENCHMARK;
+			break;
+		case 'w':
+			write =3D 1;
+			break;
+		case 'f':
+			file =3D optarg;
+			break;
+		case 'S':
+			flags &=3D ~MAP_PRIVATE;
+			flags |=3D MAP_SHARED;
+			break;
+		case 'H':
+			flags |=3D (MAP_HUGETLB | MAP_ANONYMOUS);
+			break;
+		default:
+			return -1;
+		}
+	}
+
+	filed =3D open(file, O_RDWR|O_CREAT);
+	if (filed < 0) {
+		perror("open");
+		exit(filed);
+	}
+
+	gup.nr_pages_per_call =3D nr_pages;
+	if (write)
+		gup.flags |=3D FOLL_WRITE;
+
+	fd =3D open("/sys/kernel/debug/gup_benchmark", O_RDWR);
+	if (fd =3D=3D -1) {
+		perror("open");
+		exit(1);
+	}
+
+	p =3D mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
+	if (p =3D=3D MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+	gup.addr =3D (unsigned long)p;
+
+	if (thp =3D=3D 1)
+		madvise(p, size, MADV_HUGEPAGE);
+	else if (thp =3D=3D 0)
+		madvise(p, size, MADV_NOHUGEPAGE);
+
+	for (; (unsigned long)p < gup.addr + size; p +=3D PAGE_SIZE)
+		p[0] =3D 0;
+
+	for (i =3D 0; i < repeats; i++) {
+		gup.size =3D size;
+		if (ioctl(fd, cmd, &gup)) {
+			perror("ioctl");
+			exit(1);
+		}
+
+		printf("Time: get:%lld put:%lld us", gup.get_delta_usec,
+			gup.put_delta_usec);
+		if (gup.size !=3D size)
+			printf(", truncated (size: %lld)", gup.size);
+		printf("\n");
+	}
+
+	return 0;
+}
--- a/tools/testing/selftests/vm/Makefile~mm-gup_benchmark-rename-to-mm-gup=
_test
+++ a/tools/testing/selftests/vm/Makefile
@@ -23,7 +23,7 @@ MAKEFLAGS +=3D --no-builtin-rules
 CFLAGS =3D -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 LDLIBS =3D -lrt
 TEST_GEN_FILES =3D compaction_test
-TEST_GEN_FILES +=3D gup_benchmark
+TEST_GEN_FILES +=3D gup_test
 TEST_GEN_FILES +=3D hmm-tests
 TEST_GEN_FILES +=3D hugepage-mmap
 TEST_GEN_FILES +=3D hugepage-shm
--- a/tools/testing/selftests/vm/run_vmtests~mm-gup_benchmark-rename-to-mm-=
gup_test
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -124,9 +124,9 @@ else
 fi
=20
 echo "--------------------------------------------"
-echo "running 'gup_benchmark -U' (normal/slow gup)"
+echo "running 'gup_test -U' (normal/slow gup)"
 echo "--------------------------------------------"
-./gup_benchmark -U
+./gup_test -U
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=3D1
@@ -135,9 +135,9 @@ else
 fi
=20
 echo "------------------------------------------"
-echo "running gup_benchmark -b (pin_user_pages)"
+echo "running gup_test -b (pin_user_pages)"
 echo "------------------------------------------"
-./gup_benchmark -b
+./gup_test -b
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=3D1
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


