Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27115346A18;
	Mon, 10 Aug 2026 22:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786399564; cv=none; b=i8KvpfnjaRg45zFSdWcTQMkD/BcGZjGZId+vH3p9RSuD0Fwb1rjabfsOYN8TvlRnY4nfYJ78zV4wWodvBVAiyzqLgN2RDA1j7Kxi6GyizRvxFE9DNKMYrXG3OfeONk40Qy7qzRnprlkiPPPkIsaz6aRxajO1noGNtYXtDrTAz/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786399564; c=relaxed/simple;
	bh=IRfQG/NCdndu+z++GTOAHKK2G2aQIPs8aYONmnrHhK8=;
	h=Date:To:From:Subject:Message-Id; b=E3mBAHfDETuzjYeAiWQsNKzV76BZ8DS/Y1TeglnGjTIHrW0i9bk+wyVcqnGYZmaG4KUHqKCwkHTet84doH1ctygfPH352LfroguNM7SkkWdfELLhxz6Yzra4hBJ8yfq+AqnjPrrwSFsaKHrueQ/u/NsFkFQllyM5a/54m4TKxJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WdNHwYOg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WdNHwYOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986151F000E9;
	Mon, 10 Aug 2026 22:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786399562;
	bh=dBGsCOpElaXtC2W2TL+AOvq6qD7DiqY3V4QBcsO0H9o=;
	h=Date:To:From:Subject;
	b=WdNHwYOgt/1kwWZMFhmsTIc4NMDBXd2fml1FyNCTRlq+4/LHdwQwQ1D/v3KJGLx2a
	 d4WWa1RmN6ZttfAEa7YIkte+XjY5rl3ZBzU6kj8nGsSHYnLqCTpP9Ek9UszmnyMIFs
	 68Etx9N6TwJHmAyqjmC67FnlmuYq/NFHI4aEHXrk=
Date: Mon, 10 Aug 2026 15:06:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-slot-lock-bit-position-on-big-endian-64-bit.patch added to mm-new branch
Message-Id: <20260810220602.986151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix slot lock bit position on big-endian 64-bit
has been added to the -mm mm-new branch.  Its filename is
     zram-fix-slot-lock-bit-position-on-big-endian-64-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-slot-lock-bit-position-on-big-endian-64-bit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: David Carlier <devnexen@gmail.com>
Subject: zram: fix slot lock bit position on big-endian 64-bit
Date: Mon, 10 Aug 2026 21:22:37 +0100

The slot lock is a bit operation on the whole __lock word, which flags and
ac_time alias as two u32s.  On little-endian the lock bit lands in the
position ZRAM_ENTRY_LOCK reserves in flags, so the aliasing works out.  On
64-bit big-endian it lands in ac_time instead: with
ZRAM_TRACK_ENTRY_ACTIME enabled, storing the access time from
mark_slot_accessed() or slot_free() wipes out the held lock bit, letting
another CPU take the same slot lock; an access time value with that bit
set makes the slot look locked forever.

Shift the lock bit into the flags half of the word on big-endian 64-bit.

Link: https://lore.kernel.org/20260810202241.2436603-1-devnexen@gmail.com
Fixes: 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 drivers/block/zram/zram_drv.h |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-slot-lock-bit-position-on-big-endian-64-bit
+++ a/drivers/block/zram/zram_drv.c
@@ -74,7 +74,7 @@ static __must_check bool slot_trylock(st
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
-	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
+	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK_BIT, lock)) {
 		mutex_acquire(&zram->table_lock_map, 0, 1, _RET_IP_);
 		lock_acquired(&zram->table_lock_map, _RET_IP_);
 		return true;
@@ -88,7 +88,7 @@ static void slot_lock(struct zram *zram,
 	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_acquire(&zram->table_lock_map, 0, 0, _RET_IP_);
-	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK_BIT, TASK_UNINTERRUPTIBLE);
 	lock_acquired(&zram->table_lock_map, _RET_IP_);
 }
 
@@ -97,7 +97,7 @@ static void slot_unlock(struct zram *zra
 	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_release(&zram->table_lock_map, _RET_IP_);
-	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
+	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK_BIT, lock);
 }
 
 static inline bool init_done(struct zram *zram)
--- a/drivers/block/zram/zram_drv.h~zram-fix-slot-lock-bit-position-on-big-endian-64-bit
+++ a/drivers/block/zram/zram_drv.h
@@ -15,6 +15,7 @@
 #ifndef _ZRAM_DRV_H_
 #define _ZRAM_DRV_H_
 
+#include <asm/byteorder.h>
 #include <linux/rwsem.h>
 #include <linux/zsmalloc.h>
 
@@ -58,6 +59,19 @@ enum zram_pageflags {
 };
 
 /*
+ * The slot lock is a bit-wait lock on the whole __lock word, while
+ * flags and ac_time alias that word as two u32s.  The lock bit must
+ * land in the slot that ZRAM_ENTRY_LOCK reserves in attr.flags; on
+ * 64-bit big-endian the flags word maps to the upper half of __lock,
+ * so the bit position has to be shifted up.
+ */
+#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
+#define ZRAM_ENTRY_LOCK_BIT  (ZRAM_ENTRY_LOCK + 32)
+#else
+#define ZRAM_ENTRY_LOCK_BIT  ZRAM_ENTRY_LOCK
+#endif
+
+/*
  * Allocated for each disk page.  We use bit-lock (ZRAM_ENTRY_LOCK bit
  * of flags) to save memory.  There can be plenty of entries and standard
  * locking primitives (e.g. mutex) will significantly increase sizeof()
_

Patches currently in -mm which might be from devnexen@gmail.com are

zram-fix-slot-lock-bit-position-on-big-endian-64-bit.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

