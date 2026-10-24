Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828038;
	b=JWbW95LjxnULJAtSK/vng9Masphc12GtSBojIftb4NWgxKKGgl/25gP+dNOTTUnHjtCn
	 kE1r6TxcnIqHuumswn9VInDvhe3mvI2vH233OkiOAio96Y9+bq1M3EgQFHeL2iKj/4tev
	 fVSI9uxMudUWzDTq92I6vCKGOmqTrS8O2VHhNQtEnFTpIfae/gv7tQrbrko9Kkbx+HSUT
	 fJ1WH0m1l3YC11P2S3wpfNyn3orRINJW4OfhlY7w/vbR7mypdnaDNRFKwjcm19rKy84rW
	 yBa3S/6IXGiGiITzwTFHbAn8PNxQP6uUz+v8sMJsKnYIWja8m+zU8OXW9RgwJU+biEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828038;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cHR2HDn887Me1YjpAGsw0xfR5/WRdqQoQWBY+oocWdI=;
	b=1eNcjRdNCltKZ53tceWX0r+yeBrHgyMz4apfKRt4dPUW4fwy7uKhzO0QZ7Gs0l3b0xa4
	 NFh7Ymxs/575VBR8bD3CvHzt5yEhTC+P/VzDWPq91YOeDoFvAe5JNfKZH5mry5idcnuHB
	 TUKAEW3m53uLZ22V389ZEFqLh/NDyW6UB30VeGwRKmnZHHxdojoQgWyDeZJdV/0PIW3xX
	 c/UHNG3d7ZsxsOdNxJky4ichJ7G64FvhNmOfqKWHb/VCYBVo/7zsmt+DI0nRyJV8YRNYC
	 CZW6O1nR0AudehVjNiZDHWuoLkzXbghRVBQiOv+H5IYN+ITWNfLrbC1BvxTO+LkrKng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CKREQwBo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CBC606A31F;
	Sat, 24 Oct 2026 07:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CKREQwBo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C97D1F01828;
	Sat, 24 Oct 2026 07:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828038;
	bh=cHR2HDn887Me1YjpAGsw0xfR5/WRdqQoQWBY+oocWdI=;
	h=Date:To:From:Subject;
	b=CKREQwBo5Ycf+htGIrZNXNYXLT1PIemEwkN5Uuo1aSQgGCFUKvQVhN5z6Osmc4rtQ
	 qGm+0KkcBJZpIc5guUMl4+YR9fKopBaYSgf6ezc0bGcehSSxF2qwf4NXkOLKhLcYep
	 tEYjC9QvOZ5uDUQui9hXhGljs898BdPSrZSgbEHc=
Date: Sat, 24 Oct 2026 00:47:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-dlm-drain-join-handlers-before-releasing-module-text.patch removed from -mm tree
Message-Id: <20261024074718.4C97D1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2/dlm: drain join handlers before releasing module text
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-drain-join-handlers-before-releasing-module-text.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2/dlm: drain join handlers before releasing module text
Date: Thu, 22 Oct 2026 17:09:10 +0800

The code for a registered DLM handler must remain resident until its
last invocation finishes. dlm_unregister_net_handlers() only removes
dlm_join_handlers from the o2net registry. o2net_handler_get() takes a
kref on the wrapper, but that reference does not pin ocfs2_dlm text.
o2net_process_message() calls nh_func after dropping o2net_handler_lock.

With CONFIG_OCFS2_FS_O2CB=m, ocfs2_dlm can be loaded independently of
ocfs2_stack_o2cb while nodemanager continues handling messages from a
configured, heartbeating peer. If no dependent module or module reference
prevents normal unload, the following ordering is possible:

  Receive worker                       Module unload
  --------------                       -------------
  o2net_handler_get()
    take wrapper kref
    drop handler lock
  <preempted>
                                       dlm_exit()
                                         unregister handlers
                                       release DLM module text
  call saved nh_func
    in released module text

Use o2net_unregister_and_flush_handler_list() in the shared DLM
unregister helper. It first prevents new lookups, then waits for the
ordered o2net workqueue to drain, including a concurrent destruction of
that queue. The acquired invocation therefore finishes before dlm_exit()
returns and the loader releases the callback code. The same helper
covers partial registration and dlm_init() error unwind before module
memory is released.

Skip the drain when the private join-handler list is empty. Early
dlm_init() failures can reach this helper before any handler has been
published. Partial-registration failure also reaches it a second time
after the first call has already unregistered and drained the list.
Neither case needs to take o2net_wq_mutex or drain unrelated work.
The list is changed only by serialized module init/exit paths; a
nonempty list still uses the full unregister-and-flush helper.

Oops report as below:

    Oops: int3: 0000 [#1] SMP KASAN NOPTI
    CPU: 2 UID: 0 PID: 54 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)

Hardware identification omitted.

    Workqueue: o2net o2net_rx_until_empty [ocfs2_nodemanager]
    RIP: 0010:0xffffffffc0423871
    [Instruction byte dump omitted.]

Register dump omitted.

    Call Trace:
     <TASK>
     ? o2net_rx_until_empty+0x19b1/0x3300 [ocfs2_nodemanager]
     ? __pfx_o2net_rx_until_empty+0x10/0x10 [ocfs2_nodemanager]
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     ? kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ? ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ? ret_from_fork_asm+0x1a/0x30
     </TASK>
    Modules linked in: ocfs2_nodemanager [last unloaded: ocfs2_dlm]
    ---[ end trace 0000000000000000 ]---

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0076-v6-12de5f4628f57fba3be3@gmail.com
Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-drain-join-handlers-before-releasing-module-text
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -2215,7 +2215,8 @@ static LIST_HEAD(dlm_join_handlers);
 
 static void dlm_unregister_net_handlers(void)
 {
-	o2net_unregister_handler_list(&dlm_join_handlers);
+	if (!list_empty(&dlm_join_handlers))
+		o2net_unregister_and_flush_handler_list(&dlm_join_handlers);
 }
 
 static int dlm_register_net_handlers(void)
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-snapshot-dentry-names-in-file-and-setattr-traces.patch
ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch
ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch

