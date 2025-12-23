Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4BE28C5AA;
	Tue, 23 Dec 2025 19:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517863; cv=none; b=XDEoQzMJhDuo0Kzt0NVPoKlIJgcx3NuqXWdT6WwMd0Wn8oQ6bgFmNtgANZdyvByXoX7bt/raYxQyYlt5T620h2Bg/L/V/aLe4C211nbDHcgw8ypf4lYGOs1PuJy1+wCoyRkGQ8c00Fh01uaDVSxcuTcOaO/hh60L/P7v8rHPLdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517863; c=relaxed/simple;
	bh=L8REVJ2gtNeCkJh53/51pPnydUZUrhvwC1XfdNcInQs=;
	h=Date:To:From:Subject:Message-Id; b=qlpXVbIiwinD/W7sCogS7H5jK8fpsxJgF193pReF+jgRCQkYAglgCFIZi2o2pq4VqCUjkO5DbBDdIY5g+LCOZnW3Egdw8h/yUeHOpU1Klv/GworfjLXnIK7IL0KjkmKbmR90Yp4efZu+IimecGj/df1LAKGKdge4sY8HVMoFs2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cpzBnPo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cpzBnPo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FA3C113D0;
	Tue, 23 Dec 2025 19:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517862;
	bh=L8REVJ2gtNeCkJh53/51pPnydUZUrhvwC1XfdNcInQs=;
	h=Date:To:From:Subject:From;
	b=cpzBnPo1MXFF7RZdrVEsovKp6dDlMLrzptgVL+x9ij9z7sbvqQb91eIEKJ4nPga4/
	 jl/Vaid7UaenkS0y2a7ARuU3TCxGnW6xuhV0FzdZkw5H4TYF48ylBDcXGGGj3vpuaZ
	 WWARUXarwXU5kd1JyC8YCA3SzqlPdBrwh//jjOCk=
Date: Tue, 23 Dec 2025 11:24:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tmgross@umich.edu,stable@vger.kernel.org,ojeda@kernel.org,liam.howlett@oracle.com,gary@garyguo.net,daniel.almeida@collabora.com,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,andrewjballance@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] rust-maple_tree-rcu_read_lock-in-destructor-to-silence-lockdep.patch removed from -mm tree
Message-Id: <20251223192421.E0FA3C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: maple_tree: rcu_read_lock() in destructor to silence lockdep
has been removed from the -mm tree.  Its filename was
     rust-maple_tree-rcu_read_lock-in-destructor-to-silence-lockdep.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


