Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329338;
	b=l98AMLer9usMosUAHkw5VekCxr1Ver4uneuqMA/GBKq4vTqqvL9+tDBOVODc8m4Wnv+J
	 8MzaXWFEbBt1RuLtabB9ayDgo9JYhCe9DHDiMC/sVx+Vo+MBml8cuwP8t81W1x+KFxX+J
	 OYFTnQ7V4AeI+qKVfv+v3dJn7pN2jRLP57xXHcqBrImVRc1D8QQSWXCjbeKXpNqw6IQwD
	 KXKu3VhOcMv/pAj6ApI5kMxnMUvQFZgNfjfFk4pRROH5S+vsZmO+VAktmyti1PNZTkkOr
	 48ctHupZasfLFVZVjvo+67kLdDFSw+PNYjlto0BtXCZybtqeHJmPkZr7ReZXafGeOVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329338;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/UR/v28r6PPgN6dxv17Ri9IsnnsZKT00pQ2XG6XV5TM=;
	b=k+srV46pIUtf4TuWgrrAsPDxoccONCF9EiEkdFXvuVwp21M+2PORl+0vytfbRN/TxShy
	 4NytaW+hmkcYiXyD4thf8kEX8iNJIsf6QvFJH7Rmz2HZlbRle93kWDIKfHQrhZgWADhvv
	 djjfzuaAtl5F/4UoKJT8djitwRvXrlkngowjZqELjJ6W289z7xGLgvnHKXTmv98OWtA6M
	 2wDjRVQ/BDK6wl2oSdIaKLufSsq2dY1UVmhdr2pexfH6JUHq8W5ffeK7njjylQCiLzc3P
	 dA1V3n7GNnB0b8MHZWXHLUlgUnDh/4xL3UHRrqCCVlWjPv72DY0L/BDYOh5QP5hIlZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Pg+YV5KL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800E606A320
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Pg+YV5KL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C26C1F0093A;
	Fri, 30 Oct 2026 03:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329337;
	bh=/UR/v28r6PPgN6dxv17Ri9IsnnsZKT00pQ2XG6XV5TM=;
	h=Date:To:From:Subject;
	b=Pg+YV5KLWULoS6Xvjib57KIaGai+8S9YI3ndkRdubGQxLV90wiilCpaZdEm8xpat8
	 4tTvvREmGekE23GLKjGtkEcfvHEpjSn81CvUrsGhCnNNu++/byZl89AE9juzeUUFsi
	 VINHa0zWhN8u0vnTM2/pbDqk7VtPgio0KCXszkzU=
Date: Thu, 29 Oct 2026 20:02:17 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-prefix-backends-printk-s.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030217.7C26C1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: prefix backends printk-s
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-prefix-backends-printk-s.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-prefix-backends-printk-s.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: prefix backends printk-s
Date: Sun, 25 Oct 2026 11:18:17 +0900

Patch series "zram: redesign zcomp and rework backends", v7.

The series has a number of memory usage optimisations and fixes
that result in savings from double digits KB to triple digits
KB per-context/per-CPU, depending on backend and its configuration.
More details are in the corresponding commit messages.

The zcomp redesign and backend rework happen in the final five
patches.  zcomp part, basically, attempts to address the priority
inversion problem, that is seen on some setups.  In zcomp, we have
always kept Read and Write contexts together in per-CPU streams.
With preemptible zram this becomes a bit of a problem, as a higher
priority Reader can preempt a Writer, which may hold a stream
lock, but since the compression stream is locked by the preempted
Writer, the Reader gets blocked on the very same stream lock.
However, we don't have any reasons to have Read and Write contexts
share and compete for the stream, because Read (decompression) and
Write (compression) paths are completely independent, they never
touch each other's buffers.  Thus, we can split compression streams
into per-CPU Read streams and per-CPU Write streams (Barry Song),
so that Readers and Writers don't block each other anymore.
Decoupling Reads and Writes results in noticeable performance
improvements on synthetic tests.  The Reader vs Reader priority
inversion is still possible.  To attack this problem we introduce
shared decompression stream (Brian Geffon) which can be used when
decompression is stateless.  There, however, stateful backends (zstd,
deflate) that cannot have shared decompression contexts.  For those
backends, we introduce a remote CPU borrowing of idle exclusive
decompression contexts, if an exclusive Reader get preempted on
current CPU.  We also now allocate a per-request (Read) bounce
buffer for linearisation of spanning zsmalloc objects, so stateless
decompression contexts do not block each other.

Reader vs Reader priority inversion tests (fg reader, average of
3 runs):

  exclusive zstd
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        391k               1,064k        (+2.7x)
  Read clat max    3,208,867 us       5,881 us      (-546x)

  shared lz4
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        972k               1,466k        (+50.9%)
  Read clat max    2,204,467 us       6,442 us      (-342x)

Writer vs Reader priority inversion tests (fg reader, average of
3 runs):

  lz4
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        642k               1,472k        (+2.3x)
  Read clat max    2,393,767 us       5,711 us      (-419x)

Proxy execution was brought up during v6 review, so I re-ran the
tests with CONFIG_SCHED_PROXY_EXEC=y in both kernels, 21 runs per
configuration (lz4, zstd level 3, zstd level 12).  Per-patch commit
messages have the full tables.  In short: with proxy execution base
catches up with patched on IOPS in Reader vs Reader tests, and is
still 26-28% behind in zstd Writer vs Reader tests.  What proxy
execution does not fix is the worst case: out of 126 base runs (R-vs-R
and W-vs-R combined), 108 had a read stalled for over 100 ms and 47
for over 1 s.  Patched never exceeded 8.4 ms in 126 runs.  One thing
to notice, Proxy execution is EXPERT-only option; this series doesn't
depend on it.

The final patch builds atop of decoupled Read and Write streams and
reworks the way secondary streams are handled.  Secondary compression
streams are only used from recompression, which is serialized by
device lock, IOW it's single-threaded.  However, we still allocated
secondary streams per-CPU (we needed to permit concurrent Reads
of recompressed objects).  Because we now have dedicated R/W
streams, we can allocate a singleton compression context (for
recompression) yet still have per-CPU decompression contexts.
This saves a notable amount of memory with some backends and
configurations (e.g. zstd, deflate).


This patch (of 15):

Currently, zram backends prefix printk-s with their names, which may
look a little confusing, e.g. "zstd: alloc size 408128".  Prefix
backend names with "zram:" so it's clear that the message is coming
from a zram backend.

Link: https://lore.kernel.org/20261025021839.1542805-1-senozhatsky@chromium.org
Link: https://lore.kernel.org/20261025021839.1542805-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Bo Zhang <zhangbo0325@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hillf Danton <hdanton@sina.com>
---

 drivers/block/zram/backend_842.c     |    2 +-
 drivers/block/zram/backend_deflate.c |    2 +-
 drivers/block/zram/backend_lz4.c     |    2 +-
 drivers/block/zram/backend_lz4hc.c   |    2 +-
 drivers/block/zram/backend_lzo.c     |    2 +-
 drivers/block/zram/backend_lzorle.c  |    2 +-
 drivers/block/zram/backend_zstd.c    |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/backend_842.c~zram-prefix-backends-printk-s
+++ a/drivers/block/zram/backend_842.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "842: " fmt
+#define pr_fmt(fmt) "zram: 842: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/block/zram/backend_deflate.c~zram-prefix-backends-printk-s
+++ a/drivers/block/zram/backend_deflate.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "deflate: " fmt
+#define pr_fmt(fmt) "zram: deflate: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/block/zram/backend_lz4.c~zram-prefix-backends-printk-s
+++ a/drivers/block/zram/backend_lz4.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "lz4: " fmt
+#define pr_fmt(fmt) "zram: lz4: " fmt
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
--- a/drivers/block/zram/backend_lz4hc.c~zram-prefix-backends-printk-s
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "lz4hc: " fmt
+#define pr_fmt(fmt) "zram: lz4hc: " fmt
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
--- a/drivers/block/zram/backend_lzo.c~zram-prefix-backends-printk-s
+++ a/drivers/block/zram/backend_lzo.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "lzo: " fmt
+#define pr_fmt(fmt) "zram: lzo: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/block/zram/backend_lzorle.c~zram-prefix-backends-printk-s
+++ a/drivers/block/zram/backend_lzorle.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "lzo-rle: " fmt
+#define pr_fmt(fmt) "zram: lzo-rle: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/block/zram/backend_zstd.c~zram-prefix-backends-printk-s
+++ a/drivers/block/zram/backend_zstd.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "zstd: " fmt
+#define pr_fmt(fmt) "zram: zstd: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch

