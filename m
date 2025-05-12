Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233FB1A9B40
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011379; cv=none; b=gxSKK7MoYMVQ8AYtNp5+Xl6TJCIdKlU3saAMNg4lIfWfo6ZvvEzHPZdc13NBCHikgWaqoaoN8TLEr0xRBA4cjnrpN1qrm5Bb89OIGc2/WZg87hh/xzrnNy3foj6rswVCKeXtyTTeFE/jn5P+OtFbdUtelMhf7Svl8juTwEhdhUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011379; c=relaxed/simple;
	bh=uJd6J6cPUUY7/HyXWZ2wQQG75EVYpdaazTPWAgV7j6I=;
	h=Date:To:From:Subject:Message-Id; b=kvd00+W7PwJyOB9jsyezmCLcciu9SGvmlW1RweQDvYgj4bAIKBHX1Mm5J1zpPKk3DDOZ0TiZrREJZJV2MBagDrOrQzhoOx7NL8IvV9IiZQWRaBOH4E493IqM8XCbNNGp6/svNLamlHy5zGrUiwAPcvg8ILWib1ePUzIpfNLr25s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tw0mhJ4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tw0mhJ4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB095C4CEED;
	Mon, 12 May 2025 00:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011379;
	bh=uJd6J6cPUUY7/HyXWZ2wQQG75EVYpdaazTPWAgV7j6I=;
	h=Date:To:From:Subject:From;
	b=tw0mhJ4KODfHjAlmi2J8NGAqZw9UCTdCOGvDksZR4DrWfV8PlxogS33+y8ySiijER
	 5TKqgq4tYYxXSeHY7Owy0G9HE9PvZqDxn8EGXuJyPTLBMXtz8zAc5e9IcB6mvdk8vC
	 x2Xyqxg9FPsmkNzJC96igMXBDfO2S1uWLnTuJnVg=
Date: Sun, 11 May 2025 17:56:18 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,kent.overstreet@linux.dev,jack@suse.cz,djwong@kernel.org,colyli@kernel.org,cem@kernel.org,brauner@kernel.org,pchelkin@ispras.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sorth-hoist-cmp_int-into-generic-header-file.patch removed from -mm tree
Message-Id: <20250512005618.EB095C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sort.h: hoist cmp_int() into generic header file
has been removed from the -mm tree.  Its filename was
     sorth-hoist-cmp_int-into-generic-header-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Coly Li <colyli@kernel.org>
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
@@ -290,8 +290,6 @@ xfs_zone_gc_query_cb(
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


