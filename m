Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AA123717F
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967401; cv=none; b=uyOkKEq52+BPFyBNapxA8cUASimrPUgDaQVvOMasSFB38SHolQUQhWnGwHOG9ksaN3guQidvl5qquyjEbpwzihawefd5/PDbxohI40h8rdDUSeu/VbpR5M1qet+bjpCyZy7tplPyVv4zqReguXoMxaN1gwQtjAeA0M+FGYTAN/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967401; c=relaxed/simple;
	bh=5TbWSKnBWt1WUDRmc205qKoB8LSEkSaxzK55vmH/SoI=;
	h=Date:To:From:Subject:Message-Id; b=G002ZkCAxd9s4jtWnmzowTZBdnDmuwHCYWF9WCl3zeJQabrcDBX0GdONPZ16D3KoMzRu9aiX0nT5GI5YoijX37KukltmH2C/kuoGqB6mvf/qkK3P/NJhE21WdtB7CQumA66RAAiAwOlFObIGu9p8DrNPd2rvEIR7m0uM2qkK8zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ecji4Hcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ecji4Hcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69202C16AAE;
	Wed, 21 Jan 2026 03:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967399;
	bh=5TbWSKnBWt1WUDRmc205qKoB8LSEkSaxzK55vmH/SoI=;
	h=Date:To:From:Subject:From;
	b=Ecji4Hcv3wY8FKOdUiH/kJnfB66ThFd6Vb+8IIKvgcSUOC1x/BC8VRGmCpYX4N9tw
	 Z98wOXZHGpVdEx95XLat/KX55iiqSbDXPX9hlTKE+9yV0xaIFlRNdTcFclxW5ds2KZ
	 5s7am3M9pR5lPAQq647VlE13EseTL+02I9vm+rK0=
Date: Tue, 20 Jan 2026 19:49:58 -0800
To: mm-commits@vger.kernel.org,tmgross@umich.edu,shankari.ak0208@gmail.com,pfoliadis@posteo.net,oleg@redhat.com,ojeda@kernel.org,lossin@kernel.org,gary@garyguo.net,fujita.tomonori@gmail.com,dakr@kernel.org,brauner@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rust-task-restrict-task-group_leader-to-current.patch removed from -mm tree
Message-Id: <20260121034959.69202C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: task: restrict Task::group_leader() to current
has been removed from the -mm tree.  Its filename was
     rust-task-restrict-task-group_leader-to-current.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: rust: task: restrict Task::group_leader() to current
Date: Wed, 07 Jan 2026 08:28:46 +0000

The Task::group_leader() method currently allows you to access the
group_leader() of any task, for example one you hold a refcount to.  But
this is not safe in general since the group leader could change when a
task exits.  See for example commit a15f37a40145c ("kernel/sys.c: fix the
racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths").

All existing users of Task::group_leader() call this method on current,
which is guaranteed running, so there's not an actual issue in Rust code
today.  But to prevent code in the future from making this mistake,
restrict Task::group_leader() so that it can only be called on current.

There are some other cases where accessing task->group_leader is okay. 
For example it can be safe if you hold tasklist_lock or rcu_read_lock(). 
However, only supporting current->group_leader is sufficient for all
in-tree Rust users of group_leader right now.  Safe Rust functionality for
accessing it under rcu or while holding tasklist_lock may be added in the
future if required by any future Rust module.

This patch is a bugfix in that it prevents users of this API from writing
incorrect code.  It doesn't change behavior of correct code.

Link: https://lkml.kernel.org/r/20260107-task-group-leader-v2-1-8fbf816f2a2f@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Fixes: 313c4281bc9d ("rust: add basic `Task`")
Reported-by: Oleg Nesterov <oleg@redhat.com>
Closes: https://lore.kernel.org/all/aTLnV-5jlgfk1aRK@redhat.com/
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Benno Lossin <lossin@kernel.org>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Panagiotis Foliadis <pfoliadis@posteo.net>
Cc: Shankari Anand <shankari.ak0208@gmail.com>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/task.rs |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/rust/kernel/task.rs~rust-task-restrict-task-group_leader-to-current
+++ a/rust/kernel/task.rs
@@ -204,18 +204,6 @@ impl Task {
         self.0.get()
     }
 
-    /// Returns the group leader of the given task.
-    pub fn group_leader(&self) -> &Task {
-        // SAFETY: The group leader of a task never changes after initialization, so reading this
-        // field is not a data race.
-        let ptr = unsafe { *ptr::addr_of!((*self.as_ptr()).group_leader) };
-
-        // SAFETY: The lifetime of the returned task reference is tied to the lifetime of `self`,
-        // and given that a task has a reference to its group leader, we know it must be valid for
-        // the lifetime of the returned task reference.
-        unsafe { &*ptr.cast() }
-    }
-
     /// Returns the PID of the given task.
     pub fn pid(&self) -> Pid {
         // SAFETY: The pid of a task never changes after initialization, so reading this field is
@@ -345,6 +333,18 @@ impl CurrentTask {
         // `release_task()` call.
         Some(unsafe { PidNamespace::from_ptr(active_ns) })
     }
+
+    /// Returns the group leader of the current task.
+    pub fn group_leader(&self) -> &Task {
+        // SAFETY: The group leader of a task never changes while the task is running, and `self`
+        // is the current task, which is guaranteed running.
+        let ptr = unsafe { (*self.as_ptr()).group_leader };
+
+        // SAFETY: `current->group_leader` stays valid for at least the duration in which `current`
+        // is running, and the signature of this function ensures that the returned `&Task` can
+        // only be used while `current` is still valid, thus still running.
+        unsafe { &*ptr.cast() }
+    }
 }
 
 // SAFETY: The type invariants guarantee that `Task` is always refcounted.
_

Patches currently in -mm which might be from aliceryhl@google.com are

vmalloc-export-vrealloc_node_align_noprof.patch
maple_tree-update-mas_next-docs.patch

