Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE0923393F;
	Fri, 22 May 2026 02:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415618; cv=none; b=hJHXWDn1YLEXJzGHDpUzm9OrEBRsn6RUem6tSna/mRM372RkSKk//79JUYVkevsz62sSu87aDGsNZkbeU1gtReuLYOAuiWrOeWQ+stnYuxNxo8JN2q24ChScucle9dhxNSTxayh7ykhXBS4wLxXErFbzwaOv538B9zmVVgfN9K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415618; c=relaxed/simple;
	bh=Ftlccx9eONhCFVOlqGOgn1Ak+3/zP3qqQ9nrLWlqW0c=;
	h=Date:To:From:Subject:Message-Id; b=bEjtYlnJWmd7lcqFEQ6K6iY24mM6oz8NwAQNqdf5gEqj7+HE5AuCsl+L3Mh0H0IcfLSltZsAfW2pg9hg1SJZARhe1rDl3xLD6Nc/xBssDCsDLk5cQm5cMPtOOqD8yDhASgramBenYUpbsQKuX5tQwahnBoXjIUOB+2snivH3Clw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v3dqirDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v3dqirDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C5D1F00A3E;
	Fri, 22 May 2026 02:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415615;
	bh=+ltYtF9SegxkmvIHO2XbqMpDZTG6jqJQNL0TTzf36Sw=;
	h=Date:To:From:Subject;
	b=v3dqirDfXN35chZGVO08CNZGS6VmjleR5lkf6ZdTaGQn11IvoJq82On6ScgGDK6Cm
	 Wu1vKX9yCoqQZ+0iNlJ5+KI8w9NnxH4r8IljQNfVxZKuji4CvKRTdfTrbriy5j/8oK
	 CXc2cUEi3AMiMkxRG6jF8gj+zPHJQy75BjyOVEFg=
Date: Thu, 21 May 2026 19:06:55 -0700
To: mm-commits@vger.kernel.org,yuantan098@gmail.com,yifanwucs@gmail.com,tomapufckgml@gmail.com,stable@vger.kernel.org,skinsbursky@parallels.com,n05ec@lzu.edu.cn,kees@kernel.org,dave@stgolabs.net,bird@lzu.edu.cn,linpu5433@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ipc-limit-next_id-allocation-to-the-valid-id-range.patch removed from -mm tree
Message-Id: <20260522020655.B3C5D1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc: limit next_id allocation to the valid ID range
has been removed from the -mm tree.  Its filename was
     ipc-limit-next_id-allocation-to-the-valid-id-range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linpu Yu <linpu5433@gmail.com>
Subject: ipc: limit next_id allocation to the valid ID range
Date: Sun, 10 May 2026 13:43:30 +0800

The checkpoint/restore sysctl path can request the next SysV IPC id
through ids->next_id.  ipc_idr_alloc() currently forwards that request to
idr_alloc() with an open-ended upper bound.

If the valid tail of the SysV IPC id space is full, the allocation can
spill beyond ipc_mni.  The returned SysV IPC id still uses the normal
index encoding, so later lookup and removal can target the wrong slot. 
This leaves the real IDR entry behind and breaks the IDR state for the
object.

The bug is in ipc_idr_alloc() in the checkpoint/restore path.

1. ids->next_id is passed to:

       idr_alloc(&ids->ipcs_idr, new, ipcid_to_idx(next_id), 0, ...)

2. The zero upper bound makes the allocation effectively open-ended.
   Once the valid SysV IPC tail is occupied, idr_alloc() can spill past
   ipc_mni and allocate an entry beyond the valid IPC id range.

3. The new object id is still encoded with the narrower SysV IPC index
   width:

       new->id = (new->seq << ipcmni_seq_shift()) + idx

4. Later removal goes through ipc_rmid(), which uses:

       ipcid_to_idx(ipcp->id)

   That truncates the real IDR index. An object actually stored at a
   high index can then be removed as if it lived at a low in-range
   index.

5. For shared memory, shm_destroy() frees the current object anyway, but
   the real high IDR slot is left behind as a dangling pointer.

6. A subsequent walk of /proc/sysvipc/shm reaches the stale IDR entry
   and dereferences freed memory.

Prevent this by bounding the requested allocation to ipc_mni so the
checkpoint/restore path fails once the valid range is exhausted.

Link: https://lore.kernel.org/cover.1778336914.git.linpu5433@gmail.com
Link: https://lore.kernel.org/2eebe949bfa7d1f6e13b5be6a92c64c850ce9d45.1778336914.git.linpu5433@gmail.com
Fixes: 03f595668017 ("ipc: add sysctl to specify desired next object id")
Signed-off-by: Linpu Yu <linpu5433@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Cc: Kees Cook <kees@kernel.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/util.c~ipc-limit-next_id-allocation-to-the-valid-id-range
+++ a/ipc/util.c
@@ -253,7 +253,7 @@ static inline int ipc_idr_alloc(struct i
 	} else {
 		new->seq = ipcid_to_seqx(next_id);
 		idx = idr_alloc(&ids->ipcs_idr, new, ipcid_to_idx(next_id),
-				0, GFP_NOWAIT);
+				ipc_mni, GFP_NOWAIT);
 	}
 	if (idx >= 0)
 		new->id = (new->seq << ipcmni_seq_shift()) + idx;
_

Patches currently in -mm which might be from linpu5433@gmail.com are


