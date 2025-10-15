Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FE22C15B1;
	Wed, 15 Oct 2025 20:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559907; cv=none; b=bZ1NlDOrOf2ogPfnQ5luCcKx6yh3cH2pYxCuG+TmZnbxtWKpH87r79Bc6GBiCBm+fWCX2gPbC3M0GAh7KCw1Z4HEWMjqYrthCmE9OMKtpXau+LY/uB0ETo9h5Ozjh3LMreNUhXALFz+tVLfDyB1E4KiwMeov/GflSudfZNEmTQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559907; c=relaxed/simple;
	bh=PKAv49n+WcUUieRNL+L4WibrntjUcKL2ldjZYmqCbGw=;
	h=Date:To:From:Subject:Message-Id; b=Aq4AZPnepyDvrujk4Kvin95yqBuOv5xb7Ee8ew7dfjlqBXaALfveaalNUMSJn4xN4aYSwvLdwJw/df2uhed/Scs3fv6lj0c22YQpF8FIN2FS/cy8CSoRm1wU8SEPruqZUWsVQ6pXcp682eZmPx0u5sbudDiOdACaFPatqgxEgcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F/m2bfL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F/m2bfL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ECCC4CEF8;
	Wed, 15 Oct 2025 20:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760559904;
	bh=PKAv49n+WcUUieRNL+L4WibrntjUcKL2ldjZYmqCbGw=;
	h=Date:To:From:Subject:From;
	b=F/m2bfL9Kg3SHGZklHCmrWzmoSPbkkYEMS7JY/8+z8ByZumU8ZnqDbeY2RMJT9spn
	 1fu9MYNN+SGtUbILWfNa89SoiWY+yAPGbX9sK1TWpyFlfoW/hytgozUBUGl4vgnB8R
	 Jg3MjMWJvyK6PtSKLBt01bhlpUkqztTp/6bgwsjw=
Date: Wed, 15 Oct 2025 13:25:04 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,stable@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,peterz@infradead.org,oak@helsinkinet.fi,mingzhe.yang@ly.com,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jstultz@google.com,joel.granados@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,fthain@linux-m68k.org,boqun.feng@gmail.com,anna.schumaker@oracle.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch removed from -mm tree
Message-Id: <20251015202504.80ECCC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: fix warnings caused by unaligned lock pointers
has been removed from the -mm tree.  Its filename was
     hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: hung_task: fix warnings caused by unaligned lock pointers
Date: Tue, 9 Sep 2025 22:52:43 +0800

From: Lance Yang <lance.yang@linux.dev>

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


