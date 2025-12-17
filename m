Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531F621638D;
	Wed, 17 Dec 2025 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995007; cv=none; b=gzv0rRU6KDCMJMGMb74dnm29/ZHnBFqaXaldlqqtYeS3hyZ1Mvfgnd11lbGKZim9F2ALX0jZrHtux0a7sZZlyhJi9Iylt5UtorVQYIprlNDwwff4/8D6a4fUzq9/KxDlg4dfy9oQrrOAinaPdKgCYu83Rm9h8/bWSBVf1ag34Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995007; c=relaxed/simple;
	bh=c8rvZSn/nI3KxpL11TTZyv9AqKi6Bvf23nKpOhq8CiU=;
	h=Date:To:From:Subject:Message-Id; b=J/zehl9MzSSJAKZFLcvAJlAuRSTKjK2IwaWrWB1N9ht7QVdLtOtBZLuPXZZEqc61KtzxeWYSAWJiSnGs6U/NUPRWHICaZnRee21cYDcOUcTQmIXkDjRLfCWCx06f2WuV3hxFq0/sNVzBCLWl0FASyIgl9sBM+y/zrvxvOcr9ubI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTGi7caI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTGi7caI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF39FC4CEF5;
	Wed, 17 Dec 2025 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765995004;
	bh=c8rvZSn/nI3KxpL11TTZyv9AqKi6Bvf23nKpOhq8CiU=;
	h=Date:To:From:Subject:From;
	b=JTGi7caIGFVlDCKtbnLcC2jcUk+CdqL5Y5RbOABwuByxRABqWulZjbSFgAIrSxOQl
	 kkB7YoPAipYk83X6yISR9fW7mLDSYSwXWQY9TPtmOaOfZVvTyy6nQ73lRtCO2dTzMS
	 66+E3YRW3itzxmwOdyUWx/Ofxqr59duALeJg8eQE=
Date: Wed, 17 Dec 2025 10:10:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tmgross@umich.edu,stable@vger.kernel.org,ojeda@kernel.org,liam.howlett@oracle.com,gary@garyguo.net,daniel.almeida@collabora.com,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,andrewjballance@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-maple_tree-rcu_read_lock-in-destructor-to-silence-lockdep.patch added to mm-hotfixes-unstable branch
Message-Id: <20251217181004.AF39FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: maple_tree: rcu_read_lock() in destructor to silence lockdep
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     rust-maple_tree-rcu_read_lock-in-destructor-to-silence-lockdep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-maple_tree-rcu_read_lock-in-destructor-to-silence-lockdep.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alice Ryhl <aliceryhl@google.com>
Subject: rust: maple_tree: rcu_read_lock() in destructor to silence lockdep
Date: Wed, 17 Dec 2025 13:10:37 +0000

When running the Rust maple tree kunit tests with lockdep, you may trigger
a warning that looks like this:

	lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!

	other info that might help us debug this:

	rcu_scheduler_active = 2, debug_locks = 1
	no locks held by kunit_try_catch/344.

	stack backtrace:
	CPU: 3 UID: 0 PID: 344 Comm: kunit_try_catch Tainted: G                 N  6.19.0-rc1+ #2 NONE
	Tainted: [N]=TEST
	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
	Call Trace:
	 <TASK>
	 dump_stack_lvl+0x71/0x90
	 lockdep_rcu_suspicious+0x150/0x190
	 mas_start+0x104/0x150
	 mas_find+0x179/0x240
	 _RINvNtCs5QSdWC790r4_4core3ptr13drop_in_placeINtNtCs1cdwasc6FUb_6kernel10maple_tree9MapleTreeINtNtNtBL_5alloc4kbox3BoxlNtNtB1x_9allocator7KmallocEEECsgxAQYCfdR72_25doctests_kernel_generated+0xaf/0x130
	 rust_doctest_kernel_maple_tree_rs_0+0x600/0x6b0
	 ? lock_release+0xeb/0x2a0
	 ? kunit_try_catch_run+0x210/0x210
	 kunit_try_run_case+0x74/0x160
	 ? kunit_try_catch_run+0x210/0x210
	 kunit_generic_run_threadfn_adapter+0x12/0x30
	 kthread+0x21c/0x230
	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
	 ret_from_fork+0x16c/0x270
	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
	 ret_from_fork_asm+0x11/0x20
	 </TASK>

This is because the destructor of maple tree calls mas_find() without
taking rcu_read_lock() or the spinlock.  Doing that is actually ok in this
case since the destructor has exclusive access to the entire maple tree,
but it triggers a lockdep warning.  To fix that, take the rcu read lock.

In the future, it's possible that memory reclaim could gain a feature
where it reallocates entries in maple trees even if no user-code is
touching it.  If that feature is added, then this use of rcu read lock
would become load-bearing, so I did not make it conditional on lockdep.

We have to repeatedly take and release rcu because the destructor of T
might perform operations that sleep.

Link: https://lkml.kernel.org/r/20251217-maple-drop-rcu-v1-1-702af063573f@google.com
Fixes: da939ef4c494 ("rust: maple_tree: add MapleTree")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reported-by: Andreas Hindborg <a.hindborg@kernel.org>
Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/x/topic/x/near/564215108
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/maple_tree.rs |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/rust/kernel/maple_tree.rs~rust-maple_tree-rcu_read_lock-in-destructor-to-silence-lockdep
+++ a/rust/kernel/maple_tree.rs
@@ -265,7 +265,16 @@ impl<T: ForeignOwnable> MapleTree<T> {
         loop {
             // This uses the raw accessor because we're destroying pointers without removing them
             // from the maple tree, which is only valid because this is the destructor.
-            let ptr = ma_state.mas_find_raw(usize::MAX);
+            //
+            // Take the rcu lock because mas_find_raw() requires that you hold either the spinlock
+            // or the rcu read lock. This is only really required if memory reclaim might
+            // reallocate entries in the tree, as we otherwise have exclusive access. That feature
+            // doesn't exist yet, so for now, taking the rcu lock only serves the purpose of
+            // silencing lockdep.
+            let ptr = {
+                let _rcu = kernel::sync::rcu::Guard::new();
+                ma_state.mas_find_raw(usize::MAX)
+            };
             if ptr.is_null() {
                 break;
             }
_

Patches currently in -mm which might be from aliceryhl@google.com are

rust-maple_tree-rcu_read_lock-in-destructor-to-silence-lockdep.patch

