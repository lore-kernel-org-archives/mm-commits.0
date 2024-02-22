Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028DAA93D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560105; cv=none; b=cIdarKmF71IGP3FRmW/8xT9ag1pc2nvcsqddmhUCS8+nUfcXFECYtEbcB3dCjOspFlAsrMuLX6mFev3Myjl7XTs+VaDD4RQRJcKNyH3g77e1ddn3HXxbfLywwgLWx2X9w4/Wufc5k7wGM0dKhhz9zB+7Snro/Phu3sA4Y0qvHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560105; c=relaxed/simple;
	bh=+LjhxVOOgps5TgzP3FqK4ewttgBb63na4g7iMduVkmg=;
	h=Date:To:From:Subject:Message-Id; b=Oo4Y8tDpVicId1EV6iq6PNOlJjSYvX6tnSxZdIkRFAttvsgVLchnSqiAeBvX9uU6RoIdZv3+4f161e/TDP1LbLl+mieTa7z/uKHmuHeYdp2ICog7a8ORQZ7y/S6ySAZ3cBpbA6XPY2akujpOIbiaC8ZXRBhE4yCsIJ1Y6B2riCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pb7T+3y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pb7T+3y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CAFC43390;
	Thu, 22 Feb 2024 00:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560104;
	bh=+LjhxVOOgps5TgzP3FqK4ewttgBb63na4g7iMduVkmg=;
	h=Date:To:From:Subject:From;
	b=Pb7T+3y/DDSQNtZz+2hFyw+B39K2aXoMHZXhC1J/dsQs55wkL12fre3YrW29Kcjyj
	 ETJBWTA2lMbqbM7KVi2J5BIpR13VUTDt5dEfpEtJmlGadP3r3pAnf8nCo4A6WjVM/W
	 1HZUO0uMKaH2uCMa3oLKe2Wv3uvIQAVJfviGAWWw=
Date: Wed, 21 Feb 2024 16:01:44 -0800
To: mm-commits@vger.kernel.org,nicholas@linux.ibm.com,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmsan-remove-runtime-checks-from-kmsan_unpoison_memory.patch removed from -mm tree
Message-Id: <20240222000144.C8CAFC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmsan: remove runtime checks from kmsan_unpoison_memory()
has been removed from the -mm tree.  Its filename was
     mm-kmsan-remove-runtime-checks-from-kmsan_unpoison_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: remove runtime checks from kmsan_unpoison_memory()
Date: Wed, 24 Jan 2024 18:31:34 +0100

Similarly to what's been done in commit 85716a80c16d ("kmsan: allow using
__msan_instrument_asm_store() inside runtime"), it should be safe to call
kmsan_unpoison_memory() from within the runtime, as it does not allocate
memory or take locks.  Remove the redundant runtime checks.

This should fix false positives seen with CONFIG_DEBUG_LIST=y when
the non-instrumented lib/stackdepot.c failed to unpoison the memory
chunks later checked by the instrumented lib/list_debug.c

Also replace the implementation of kmsan_unpoison_entry_regs() with
a call to kmsan_unpoison_memory().

Link: https://lkml.kernel.org/r/20240124173134.1165747-1-glider@google.com
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Signed-off-by: Alexander Potapenko <glider@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/mm/kmsan/hooks.c~mm-kmsan-remove-runtime-checks-from-kmsan_unpoison_memory
+++ a/mm/kmsan/hooks.c
@@ -359,6 +359,12 @@ void kmsan_handle_dma_sg(struct scatterl
 }
 
 /* Functions from kmsan-checks.h follow. */
+
+/*
+ * To create an origin, kmsan_poison_memory() unwinds the stacks and stores it
+ * into the stack depot. This may cause deadlocks if done from within KMSAN
+ * runtime, therefore we bail out if kmsan_in_runtime().
+ */
 void kmsan_poison_memory(const void *address, size_t size, gfp_t flags)
 {
 	if (!kmsan_enabled || kmsan_in_runtime())
@@ -371,47 +377,31 @@ void kmsan_poison_memory(const void *add
 }
 EXPORT_SYMBOL(kmsan_poison_memory);
 
+/*
+ * Unlike kmsan_poison_memory(), this function can be used from within KMSAN
+ * runtime, because it does not trigger allocations or call instrumented code.
+ */
 void kmsan_unpoison_memory(const void *address, size_t size)
 {
 	unsigned long ua_flags;
 
-	if (!kmsan_enabled || kmsan_in_runtime())
+	if (!kmsan_enabled)
 		return;
 
 	ua_flags = user_access_save();
-	kmsan_enter_runtime();
 	/* The users may want to poison/unpoison random memory. */
 	kmsan_internal_unpoison_memory((void *)address, size,
 				       KMSAN_POISON_NOCHECK);
-	kmsan_leave_runtime();
 	user_access_restore(ua_flags);
 }
 EXPORT_SYMBOL(kmsan_unpoison_memory);
 
 /*
- * Version of kmsan_unpoison_memory() that can be called from within the KMSAN
- * runtime.
- *
- * Non-instrumented IRQ entry functions receive struct pt_regs from assembly
- * code. Those regs need to be unpoisoned, otherwise using them will result in
- * false positives.
- * Using kmsan_unpoison_memory() is not an option in entry code, because the
- * return value of in_task() is inconsistent - as a result, certain calls to
- * kmsan_unpoison_memory() are ignored. kmsan_unpoison_entry_regs() ensures that
- * the registers are unpoisoned even if kmsan_in_runtime() is true in the early
- * entry code.
+ * Version of kmsan_unpoison_memory() called from IRQ entry functions.
  */
 void kmsan_unpoison_entry_regs(const struct pt_regs *regs)
 {
-	unsigned long ua_flags;
-
-	if (!kmsan_enabled)
-		return;
-
-	ua_flags = user_access_save();
-	kmsan_internal_unpoison_memory((void *)regs, sizeof(*regs),
-				       KMSAN_POISON_NOCHECK);
-	user_access_restore(ua_flags);
+	kmsan_unpoison_memory((void *)regs, sizeof(*regs));
 }
 
 void kmsan_check_memory(const void *addr, size_t size)
_

Patches currently in -mm which might be from glider@google.com are


