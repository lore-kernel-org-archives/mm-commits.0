Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560652;
	b=jJ2qIM1rA18dY7HCipeiSXiIejKlQCMamO5zaVtJvztyIhxABqSXHwY0P8Cz2FiYIt2p
	 fVO0V1tfNOnpbg9ZSfpJC5v5sDVtg3qe7JfLYlHLnXVV11WEVj8F4hb2JOPtZ2wxB9VIt
	 5cQG85ZdSqaBfdwe9SgG0poDxJKhvEVUZZs7GvUNrGzJge1PNmTuOCZAzPc2N6fz1bsjy
	 LNvGt2L0kOqlS5/zv6iH2IRrQfPTO+9oSg1mmuQjtOaYh2WG4tvJgP27Ql+xCbGnvsD3R
	 /C08AUCa+MolDHzxOsIowQ45O20H1rUqOZABSvCnfDi74nFu+9OSSyMQqZKZtwY3osg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560652;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YZNjB5VGFo4iZL68bmrUnIPbFrjDvBKs3bcK2oVRkDU=;
	b=QxoatcWecOcr4dMVsJCq21aSke3N01wYfPXWf9nZOvyNh/P3tD4ZnBLYenGSleGnufbU
	 cxl3pQk+NCC9V6Svyy/bG3eUV6/DZMN1kKy3FtQSNmlmwlilaanHAu2uFB5K2kkQgtjf0
	 8QSaZm2/g2Jr2sbKsuJsxedVVnLlkCfdOI9oY7K3rIUzUYfOUYOFw0d0gWuGicwMpTKJJ
	 vC/xARqAGCk1MijxfP8ZZZ6O6QCbCcXBkQJb01yJu2wrAi86za5jekSlSYDSppqhQYNt/
	 8FT7QBD6yZd9A0m8FpKXGTVSsTnBcUSqln/wgWlBpVG8OwzI89p+SzWzqvzDuEn6Gnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QcH1D7kV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE88B606A31E;
	Wed, 21 Oct 2026 05:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QcH1D7kV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F38F1F000C9;
	Wed, 21 Oct 2026 05:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560651;
	bh=YZNjB5VGFo4iZL68bmrUnIPbFrjDvBKs3bcK2oVRkDU=;
	h=Date:To:From:Subject;
	b=QcH1D7kVU5YwWUnBQCqYwUYVLJHe1jJVrY2eSqzm4aA8UH+7VcfdVQfU3w/xGxaWr
	 OjHQa+VPXOwuc6PcPYAquPW6pIRhSKzo+9M5CMumff+gkrlFXwXKlm+C4H/NPFLykS
	 IBrpotz60G/xwCXPgwdEvUyDC8uLwAx3py1M0yE4=
Date: Tue, 20 Oct 2026 22:30:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-dlm-hold-the-lookup-reference-across-convert-ast-enqueue.patch removed from -mm tree
Message-Id: <20261021053051.4F38F1F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2/dlm: hold the lookup reference across convert AST enqueue
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-hold-the-lookup-reference-across-convert-ast-enqueue.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2/dlm: hold the lookup reference across convert AST enqueue
Date: Wed, 14 Oct 2026 19:23:21 +0800

dlm_convert_lock_handler() drops the reference it took when it found the
lock on res->granted at its leave label, one statement before it calls
dlm_queue_ast().  dlm_free_dead_locks() takes res->spinlock and drops the
list and base references, so a peer death landing in that gap leaves the
handler's own put as the one that frees the lock, and __dlm_queue_ast()
then reads lock->lockres from freed memory.

The handler is registered next to dlm_create_lock_handler(), so a convert
message buffered on a dying peer's socket arrives on the same o2net
receive work that o2net_disconnect_node() does not wait for.  The two can
interleave as follows, with the reference counts as they are before this
fix:

  Socket data-ready       Node-down thread      Receive worker
  -----------------       ----------------      --------------
  o2net_data_ready()
    select sc under
    callback read lock
                          o2net_disconnect_node()
                            queue shutdown
                            begin flush; new color
    queue sc_rx_work
    in the new color
    release callback lock
                            shutdown socket
                            flush returns
                                                read buffered convert_lock
                                                dlm_convert_lock_handler()
                                                  find lock on res->granted
                                                  dlm_lock_get()  refs = 3
                                                  lock res->spinlock
                                                  __dlmconvert_master()
                                                    call_ast = 1
                                                  unlock res->spinlock
                          DLM node-down cleanup
                            lock res->spinlock
                            dlm_free_dead_locks()
                              unlink lock
                              put list ref  refs = 2
                              put base ref  refs = 1
                            unlock res->spinlock
                                                dlm_lock_put()  refs = 0
                                                  free lock
                                                dlm_queue_ast()
                                                  __dlm_queue_ast()
                                                  read lock->lockres
                                                  (use-after-free)

__dlmconvert_master() only moves the lock between lists, so the count
entering the gap is base, list and lookup.  Drop the lookup reference
after the AST is queued instead of before it and the race ends with the
one __dlm_queue_ast() took, which dlm_flush_asts() releases later with
ast_pending cleared and ast_list unlinked.  No extra get is needed, and
the normal case ends with the same count as before.

dlmconvert_master() has the same shape but is only reached from dlmlock()
for a lock this node owns, which dlm_free_dead_locks() never matches.

Link: https://lore.kernel.org/20261014112321.2955584-1-joseph.qi@linux.alibaba.com
Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/dlm/dlmconvert.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-hold-the-lookup-reference-across-convert-ast-enqueue
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -534,15 +534,19 @@ int dlm_convert_lock_handler(struct o2ne
 	}
 
 leave:
-	if (lock)
-		dlm_lock_put(lock);
-
 	/* either queue the ast or release it, if reserved */
 	if (call_ast)
 		dlm_queue_ast(dlm, lock);
 	else if (ast_reserved)
 		dlm_lockres_release_ast(dlm, res);
 
+	/*
+	 * Keep the lock alive through AST enqueue: a concurrent
+	 * dlm_free_dead_locks() drops the list and base references.
+	 */
+	if (lock)
+		dlm_lock_put(lock);
+
 	if (kick_thread)
 		dlm_kick_thread(dlm, res);
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


