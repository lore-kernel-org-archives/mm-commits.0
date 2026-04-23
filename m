Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB91E1E7C12
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776964650; cv=none; b=bvwxJ7vx5/HcjCaBjv1e3IfEG6D+zprZvKcNGLVim1Kvkn/M3gUQTJbMPV/CwrgRsosLcDRw0tbKDAXUwmD4Tiyg8INgj+yHfswCSS7hVwRYT879MYu0NUR/qQ6wkNY7v1P9cj3IwzanClXcbAkEnUKyx8T9rKW/Gbd8GFzGZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776964650; c=relaxed/simple;
	bh=ysRfLpqXZ85txR/AGL2XYJPoQJF5uCo69pWqOsEr/Jc=;
	h=Date:To:From:Subject:Message-Id; b=H0hCqRoTsDsa2YMhMPcCpA9sgm1Z+rTYPjWobBZwYDCh3bc+PEG3+ALFHLz5FUCLOOJ/GO6Za/OjrDhqvrZl57W6/HS9UXY0ScK7CSrUpm/N0tH6hrNQ8NQMqCSoktAx2m1IAEzLnxhLvEX+WS0qagLtKh09llKOoq+yFVIBIWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n7RjcwSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n7RjcwSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E4C2BCAF;
	Thu, 23 Apr 2026 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776964650;
	bh=ysRfLpqXZ85txR/AGL2XYJPoQJF5uCo69pWqOsEr/Jc=;
	h=Date:To:From:Subject:From;
	b=n7RjcwSv5vfCh9pJa8/tl2oCkbUJmtIw+ZJQp33MkawtDHUn0lweuScDx2uJ9ycIE
	 g9C2gdBxjjaFIbr9VcxfxMHdKqz3bH5Z3zSS2Dx0FhxK2QhjZXeuUNkhz6Np0t1fmf
	 7T0eKCGXs8/HPqbboeFdzTQyPTMerzNim5Gyk6Bo=
Date: Thu, 23 Apr 2026 10:17:30 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rafael@kernel.org,peterz@infradead.org,mingo@kernel.org,memxor@gmail.com,mark.rutland@arm.com,konradybcio@kernel.org,harisokn@amazon.com,gary@garyguo.net,davidgow@google.com,daniel.lezcano@linaro.org,cl@linux.com,catalin.marinas@arm.com,boqun@kernel.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andersson@kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + atomic-add-atomic_cond_read__timeout.patch added to mm-new branch
Message-Id: <20260423171730.B46E4C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: atomic: add atomic_cond_read_*_timeout()
has been added to the -mm mm-new branch.  Its filename is
     atomic-add-atomic_cond_read__timeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/atomic-add-atomic_cond_read__timeout.patch

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
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: atomic: add atomic_cond_read_*_timeout()
Date: Wed, 8 Apr 2026 17:55:31 +0530

Add atomic load wrappers, atomic_cond_read_*_timeout() and
atomic64_cond_read_*_timeout() for the cond-load timeout interfaces.

Also add a short description for the atomic_cond_read_{relaxed,acquire}(),
and the atomic_cond_read_{relaxed,acquire}_timeout() interfaces.

Link: https://lore.kernel.org/20260408122538.3610871-8-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: David Gow <davidgow@google.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Haris Okanovic <harisokn@amazon.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_t.txt |   14 +++++++++-----
 include/linux/atomic.h     |   10 ++++++++++
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/Documentation/atomic_t.txt~atomic-add-atomic_cond_read__timeout
+++ a/Documentation/atomic_t.txt
@@ -16,6 +16,10 @@ Non-RMW ops:
   atomic_read(), atomic_set()
   atomic_read_acquire(), atomic_set_release()
 
+Non-RMW, non-atomic_t ops:
+
+  atomic_cond_read_{relaxed,acquire}()
+  atomic_cond_read_{relaxed,acquire}_timeout()
 
 RMW atomic operations:
 
@@ -79,11 +83,11 @@ SEMANTICS
 
 Non-RMW ops:
 
-The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
-implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
-smp_store_release() respectively. Therefore, if you find yourself only using
-the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
-and are doing it wrong.
+The non-RMW ops are (typically) regular, or conditional LOADs and STOREs and
+are canonically implemented using READ_ONCE(), WRITE_ONCE(),
+smp_load_acquire() and smp_store_release() respectively. Therefore, if you
+find yourself only using the Non-RMW operations of atomic_t, you do not in
+fact need atomic_t at all and are doing it wrong.
 
 A note for the implementation of atomic_set{}() is that it must not break the
 atomicity of the RMW ops. That is:
--- a/include/linux/atomic.h~atomic-add-atomic_cond_read__timeout
+++ a/include/linux/atomic.h
@@ -31,6 +31,16 @@
 #define atomic64_cond_read_acquire(v, c) smp_cond_load_acquire(&(v)->counter, (c))
 #define atomic64_cond_read_relaxed(v, c) smp_cond_load_relaxed(&(v)->counter, (c))
 
+#define atomic_cond_read_acquire_timeout(v, c, e, t) \
+	smp_cond_load_acquire_timeout(&(v)->counter, (c), (e), (t))
+#define atomic_cond_read_relaxed_timeout(v, c, e, t) \
+	smp_cond_load_relaxed_timeout(&(v)->counter, (c), (e), (t))
+
+#define atomic64_cond_read_acquire_timeout(v, c, e, t) \
+	smp_cond_load_acquire_timeout(&(v)->counter, (c), (e), (t))
+#define atomic64_cond_read_relaxed_timeout(v, c, e, t) \
+	smp_cond_load_relaxed_timeout(&(v)->counter, (c), (e), (t))
+
 /*
  * The idea here is to build acquire/release variants by adding explicit
  * barriers on top of the relaxed variant. In the case where the relaxed
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

asm-generic-barrier-add-smp_cond_load_relaxed_timeout.patch
arm64-barrier-support-smp_cond_load_relaxed_timeout.patch
arm64-delay-move-some-constants-out-to-a-separate-header.patch
arm64-support-wfet-in-smp_cond_load_relaxed_timeout.patch
arm64-rqspinlock-remove-private-copy-of-smp_cond_load_acquire_timewait.patch
asm-generic-barrier-add-smp_cond_load_acquire_timeout.patch
atomic-add-atomic_cond_read__timeout.patch
locking-atomic-scripts-build-atomic_long_cond_read__timeout.patch
bpf-rqspinlock-switch-check_timeout-to-a-clock-interface.patch
bpf-rqspinlock-use-smp_cond_load_acquire_timeout.patch
sched-add-need-resched-timed-wait-interface.patch
cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch
kunit-enable-testing-smp_cond_load_relaxed_timeout.patch
kunit-add-tests-for-smp_cond_load_relaxed_timeout.patch

