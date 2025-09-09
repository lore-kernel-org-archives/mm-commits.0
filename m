Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2249A2B9B9;
	Tue,  9 Sep 2025 23:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757460830; cv=none; b=YuURIfE7geK/nFUrlEPq8wT+29MjHLSzAOYYcV3VA1f++z6FyAKKh2sviS5vcyCMqF99M3Qwtbzmn6vdq5rwuNXfb3pCgeIUd5zLnrY+K5YNnldcGhyNjqQvSbeKltjCeXSY78bVyt4aGJNfsM709EgGgsklJuNvbgN39Zh/fRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757460830; c=relaxed/simple;
	bh=AxtQAct7EO/T+fTTMJ0larcBPKpKVcBsnKR0WxsF2ts=;
	h=Date:To:From:Subject:Message-Id; b=HAwRst/BxNfOxGZ/kLAYbGHT3GP/D5o6Hm8Hr+VqMdSi4XP8UuzqdOgy6LZLETo9ntr7V2aK35wciX9HSs6s55MChcZXHbPnM7GU4DujfzjSmqzqDPZzhx9A8IiJWf9EXHb2BTfkNeUWZ0zmQOA0015zRpPnzbs0kF2cXOOG2y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jK8/N6Me; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jK8/N6Me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FC9C4CEF4;
	Tue,  9 Sep 2025 23:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757460829;
	bh=AxtQAct7EO/T+fTTMJ0larcBPKpKVcBsnKR0WxsF2ts=;
	h=Date:To:From:Subject:From;
	b=jK8/N6Me5ebsYx563hYWAs1eV2ZljpBzsf1+ZwQxKFalRn3o2AJW1AIBliEw6mb7A
	 aqFwre1nW4g9QPS6qsnhjXTYg5VKNKncB3DwhBlWQIvVPKZdnBIZqRNxwQctVlcdv5
	 /3p1a0/DS1EpExnw4RowfWL1BI6t3F/++W4+CEkY=
Date: Tue, 09 Sep 2025 16:33:49 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,stable@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,peterz@infradead.org,oak@helsinkinet.fi,mingzhe.yang@ly.com,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jstultz@google.com,joel.granados@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,fthain@linux-m68k.org,boqun.feng@gmail.com,anna.schumaker@oracle.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch added to mm-hotfixes-unstable branch
Message-Id: <20250909233349.D2FC9C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: fix warnings caused by unaligned lock pointers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lance Yang <lance.yang@linux.dev>
Subject: hung_task: fix warnings caused by unaligned lock pointers
Date: Tue, 9 Sep 2025 22:52:43 +0800


The blocker tracking mechanism assumes that lock pointers are at least
4-byte aligned to use their lower bits for type encoding.

However, as reported by Eero Tamminen, some architectures like m68k
only guarantee 2-byte alignment of 32-bit values. This breaks the
assumption and causes two related WARN_ON_ONCE checks to trigger.

To fix this, the runtime checks are adjusted to silently ignore any lock
that is not 4-byte aligned, effectively disabling the feature in such
cases and avoiding the related warnings.

Thanks to Geert Uytterhoeven for bisecting!

Link: https://lkml.kernel.org/r/20250909145243.17119-1-lance.yang@linux.dev
Fixes: e711faaafbe5 ("hung_task: replace blocker_mutex with encoded blocker")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: Eero Tamminen <oak@helsinkinet.fi>
Closes: https://lore.kernel.org/lkml/CAMuHMdW7Ab13DdGs2acMQcix5ObJK0O2dG_Fxzr8_g58Rc1_0g@mail.gmail.com
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Finn Thain <fthain@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yongliang Gao <leonylgao@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hung_task.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/include/linux/hung_task.h~hung_task-fix-warnings-caused-by-unaligned-lock-pointers
+++ a/include/linux/hung_task.h
@@ -20,6 +20,10 @@
  * always zero. So we can use these bits to encode the specific blocking
  * type.
  *
+ * Note that on architectures where this is not guaranteed, or for any
+ * unaligned lock, this tracking mechanism is silently skipped for that
+ * lock.
+ *
  * Type encoding:
  * 00 - Blocked on mutex			(BLOCKER_TYPE_MUTEX)
  * 01 - Blocked on semaphore			(BLOCKER_TYPE_SEM)
@@ -45,7 +49,7 @@ static inline void hung_task_set_blocker
 	 * If the lock pointer matches the BLOCKER_TYPE_MASK, return
 	 * without writing anything.
 	 */
-	if (WARN_ON_ONCE(lock_ptr & BLOCKER_TYPE_MASK))
+	if (lock_ptr & BLOCKER_TYPE_MASK)
 		return;
 
 	WRITE_ONCE(current->blocker, lock_ptr | type);
@@ -53,8 +57,6 @@ static inline void hung_task_set_blocker
 
 static inline void hung_task_clear_blocker(void)
 {
-	WARN_ON_ONCE(!READ_ONCE(current->blocker));
-
 	WRITE_ONCE(current->blocker, 0UL);
 }
 
_

Patches currently in -mm which might be from lance.yang@linux.dev are

maintainers-add-lance-yang-as-a-thp-reviewer.patch
hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch

