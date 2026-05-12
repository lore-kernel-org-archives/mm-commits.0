Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A073EDE74;
	Tue, 12 May 2026 22:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626402; cv=none; b=tqM6uIWFElQ8mqr3bfDD2Me0eAX4yaAzjubj213U2BRBD8h+iM/tmW8T7G+fZgEsIS7deEYWTbaWGkFESUTMhcM7enNMULkBfjYSC+w0s/wQMXP1GLy/BaowGTXCo+6g/jdut/PHG3Te/Lsmate72tUYSvg0X7qre5jJNlbgt54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626402; c=relaxed/simple;
	bh=p441qzum9rMv3C4udHD1WD+8/w8GGMGmeBqJV6Swk4Q=;
	h=Date:To:From:Subject:Message-Id; b=FPvQGgBhYhKSn8sfFdnwb6gLmKBmsP6ew9+agAaoLgbtHXWFzHWaBADtAAtLWNUf5wYEkgQkPlBhzSPWtYma4xgZktLwKau3h5UK2PmeM3n2Aak8msxdoa7VQAEcZ6riIAc7BWaGDD/anV7RdbEnsulIJcYFNqJ930yNi1S1d88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nw2KSrM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nw2KSrM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF733C2BCB0;
	Tue, 12 May 2026 22:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778626402;
	bh=p441qzum9rMv3C4udHD1WD+8/w8GGMGmeBqJV6Swk4Q=;
	h=Date:To:From:Subject:From;
	b=Nw2KSrM7gcuvl8GtgnZli51qudh2cqiGvTI+xK65bS5HzEkQGAHsRbus7Q2CWSlfW
	 2Bby2CXvSxplmoMNYyV3jwHNCCI0nEubJXV9N5tvzfBrSTJScMCNsbAiVSRtkND6ON
	 Ud+hmYWlYu5VQUibt/NIHPynIqH7jIBqjiMiGon8=
Date: Tue, 12 May 2026 15:53:21 -0700
To: mm-commits@vger.kernel.org,yuantan098@gmail.com,yifanwucs@gmail.com,tomapufckgml@gmail.com,stable@vger.kernel.org,skinsbursky@parallels.com,n05ec@lzu.edu.cn,kees@kernel.org,dave@stgolabs.net,bird@lzu.edu.cn,linpu5433@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-limit-next_id-allocation-to-the-valid-id-range.patch added to mm-hotfixes-unstable branch
Message-Id: <20260512225321.DF733C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc: limit next_id allocation to the valid ID range
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ipc-limit-next_id-allocation-to-the-valid-id-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-limit-next_id-allocation-to-the-valid-id-range.patch

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

ipc-limit-next_id-allocation-to-the-valid-id-range.patch

