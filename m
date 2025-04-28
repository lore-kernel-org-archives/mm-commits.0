Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910D710E0
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 00:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745799021; cv=none; b=hkYNPuWajlW9RGEDK2cN4I+cZwQhmDqoMhC8tWjpkl6XiGHJlSdnXR9jg518V3yZJCtotIMf2FQzI2lqyHsp9CnrbSW+b9oVAxGGwPNqTs5xLrz1PpawXA1umLptzgiMZQZ1rznaX+z4RMPFBxrIQePLs+jPC3ThqWeXZ3e8Og8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745799021; c=relaxed/simple;
	bh=H0GbtI6mHdDa3BPC6J207JW2XopHLyuFMO9hBFIIHIA=;
	h=Date:To:From:Subject:Message-Id; b=Lfve/uC9nDQXLj5aXBbpSkoRaGnagNyjSv2ZAht9nLGlYHtP67Eik/RgIieYLlH4e3BT5kWgsmhlA9i7WkWZJYPwOu3Jl8vOpdUQKiigqmo5gKGcOCjmKm+hLfybA/sghcG4VJmayThAQR3Tw4F8ObMJvznPyFYDsGgNLx66OF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aFbbzwcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aFbbzwcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3519AC4CEE3;
	Mon, 28 Apr 2025 00:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745799021;
	bh=H0GbtI6mHdDa3BPC6J207JW2XopHLyuFMO9hBFIIHIA=;
	h=Date:To:From:Subject:From;
	b=aFbbzwcU9vkaeb9iGRGzJp3L95ZM8NR7K485yjGBr0CI+S0tU/OUomnduq7lPkg0p
	 ADZFwktfI4c2LeqhNrBEf+BU19Nnzwb9R3g3mJ5ySYAgJv4nBcHlG0P/awHUd1SPKb
	 Ukjhwwi0oynDK+2hF2mf4bGyiQyFZvDPVzdjmyUc=
Date: Sun, 27 Apr 2025 17:10:20 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,kent.overstreet@linux.dev,jack@suse.cz,djwong@kernel.org,colyli@kernel.org,cem@kernel.org,brauner@kernel.org,pchelkin@ispras.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sorth-hoist-cmp_int-into-generic-header-file.patch added to mm-nonmm-unstable branch
Message-Id: <20250428001021.3519AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sort.h: hoist cmp_int() into generic header file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sorth-hoist-cmp_int-into-generic-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sorth-hoist-cmp_int-into-generic-header-file.patch

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
From: Fedor Pchelkin <pchelkin@ispras.ru>
Subject: sort.h: hoist cmp_int() into generic header file
Date: Sun, 27 Apr 2025 23:14:49 +0300

Deduplicate the same functionality implemented in several places by
moving the cmp_int() helper macro into linux/sort.h.

The macro performs a three-way comparison of the arguments mostly useful
in different sorting strategies and algorithms.

Link: https://lkml.kernel.org/r/20250427201451.900730-1-pchelkin@ispras.ru
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Coly Li <colyli@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/btree.c |    3 +--
 fs/bcachefs/util.h        |    3 +--
 fs/pipe.c                 |    3 +--
 fs/xfs/xfs_zone_gc.c      |    2 --
 include/linux/sort.h      |   10 ++++++++++
 5 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/md/bcache/btree.c~sorth-hoist-cmp_int-into-generic-header-file
+++ a/drivers/md/bcache/btree.c
@@ -36,6 +36,7 @@
 #include <linux/sched/clock.h>
 #include <linux/rculist.h>
 #include <linux/delay.h>
+#include <linux/sort.h>
 #include <trace/events/bcache.h>
 
 /*
@@ -559,8 +560,6 @@ static void mca_data_alloc(struct btree
 	}
 }
 
-#define cmp_int(l, r)		((l > r) - (l < r))
-
 #ifdef CONFIG_PROVE_LOCKING
 static int btree_lock_cmp_fn(const struct lockdep_map *_a,
 			     const struct lockdep_map *_b)
--- a/fs/bcachefs/util.h~sorth-hoist-cmp_int-into-generic-header-file
+++ a/fs/bcachefs/util.h
@@ -16,6 +16,7 @@
 #include <linux/preempt.h>
 #include <linux/ratelimit.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 
@@ -669,8 +670,6 @@ static inline void percpu_memset(void __
 
 u64 *bch2_acc_percpu_u64s(u64 __percpu *, unsigned);
 
-#define cmp_int(l, r)		((l > r) - (l < r))
-
 static inline int u8_cmp(u8 l, u8 r)
 {
 	return cmp_int(l, r);
--- a/fs/pipe.c~sorth-hoist-cmp_int-into-generic-header-file
+++ a/fs/pipe.c
@@ -26,6 +26,7 @@
 #include <linux/memcontrol.h>
 #include <linux/watch_queue.h>
 #include <linux/sysctl.h>
+#include <linux/sort.h>
 
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
@@ -76,8 +77,6 @@ static unsigned long pipe_user_pages_sof
  * -- Manfred Spraul <manfred@colorfullife.com> 2002-05-09
  */
 
-#define cmp_int(l, r)		((l > r) - (l < r))
-
 #ifdef CONFIG_PROVE_LOCKING
 static int pipe_lock_cmp_fn(const struct lockdep_map *a,
 			    const struct lockdep_map *b)
--- a/fs/xfs/xfs_zone_gc.c~sorth-hoist-cmp_int-into-generic-header-file
+++ a/fs/xfs/xfs_zone_gc.c
@@ -284,8 +284,6 @@ xfs_zone_gc_query_cb(
 	return 0;
 }
 
-#define cmp_int(l, r)		((l > r) - (l < r))
-
 static int
 xfs_zone_gc_rmap_rec_cmp(
 	const void			*a,
--- a/include/linux/sort.h~sorth-hoist-cmp_int-into-generic-header-file
+++ a/include/linux/sort.h
@@ -4,6 +4,16 @@
 
 #include <linux/types.h>
 
+/**
+ * cmp_int - perform a three-way comparison of the arguments
+ * @l: the left argument
+ * @r: the right argument
+ *
+ * Return: 1 if the left argument is greater than the right one; 0 if the
+ * arguments are equal; -1 if the left argument is less than the right one.
+ */
+#define cmp_int(l, r) (((l) > (r)) - ((l) < (r)))
+
 void sort_r(void *base, size_t num, size_t size,
 	    cmp_r_func_t cmp_func,
 	    swap_r_func_t swap_func,
_

Patches currently in -mm which might be from pchelkin@ispras.ru are

sorth-hoist-cmp_int-into-generic-header-file.patch

