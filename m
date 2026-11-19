Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795067697;
	b=kcqwaXUcG0n654iDeIIi4w0TtRHydZd5cZDN9z/40u/14Y9KMqVm8V/8297RvqWzMQLj
	 AvHcphQbK0CVhfcwnuDSIcxD44GssR81jj+ANJnP/8F3chEGAFWMAiQ/hQk6FyMzi0XLN
	 PSulJknjUkT4edP3bciW6/xJsleDzanQ3siGJztkvZgg+yE+XtBW/5ihbrEiHeDgb50U8
	 d6+X+F5xKd+tLszD7oNPojzamUwE8IboUAdkGv9C3Pnm3xLrJZLN+R1MVFREeIPexBXwL
	 DCj8hxH+UqMsOZAJOjQBX24USa203M5/av7VKhtiPgkrEHeLkV92e6sbBSd5DgIhG/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795067697;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=cQA+RdxhVaQg2wcsA1jTurGlIukrWJe77QMg4sxsFbM=;
	b=pZ7mrJVTobfJJCvEp8dhyPpVh8PXK11RwOi+5hreTRT/w9lmVPE0oXH+WnZxuSyWZJsV
	 63ai8CSKz5F3jRzRzb7RF/iSs7kQcA9d9yCDVpohf05boeyTyMU/4K/u87oiafB+QLAVH
	 /x378Q3hbp1YeLL/OnIKWsZmR9ftdet3f8rTg1EoCz4sIsZgJDzsRxStvJB1ZnTfISLzX
	 MPPkITIbpcIIso90uIfhS2q8lt64wkaYrxgrghP3vnAuUifyLEWFSw6uf5T2d0GHR+ujD
	 9glqlEORUPenT0ZBtUKxIsK4lj9km3N8TgQepA4pjei+2OcMC9lrWrObnAFv+ErfzXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BJxCRKjf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB6260A2603;
	Thu, 19 Nov 2026 05:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BJxCRKjf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F941F000C7;
	Thu, 19 Nov 2026 05:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795067696;
	bh=cQA+RdxhVaQg2wcsA1jTurGlIukrWJe77QMg4sxsFbM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=BJxCRKjfwLKB5GP/LWiCdz4vOlLMTpyMyldIG5PdWJIEvJFTYc7DyOzC0cL8DyCoh
	 BrdCoc49KRgQNXjLhsBOQKrqte5Efw7MB+wDuHRq84s8vIDM4sfK9aL2gM3ETbnPtx
	 iBcY1g2dAM5VnKXUPOl1MFFjxh+bhAcLnJEWYXqA=
Date: Wed, 18 Nov 2026 21:54:56 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,
	jannh@google.com,ahuang12@lenovo.com,adrianhuang0701@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261118103421.776-1-adrianhuang0701@gmail.com>
References: <20261118103421.776-1-adrianhuang0701@gmail.com>
Subject: + fs-proc-task_mmu-avoid-spurious-seq_file-warning-on-interrupted-vma-lookup.patch added to mm-new branch
Message-Id: <20261119055456.83F941F000C7@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fs/proc/task_mmu: avoid spurious seq_file warning on interrupted VMA lookup
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-avoid-spurious-seq_file-warning-on-interrupted-vma-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-avoid-spurious-seq_file-warning-on-interrupted-vma-lookup.patch

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
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: fs/proc/task_mmu: avoid spurious seq_file warning on interrupted VMA lookup
Date: Wed, 18 Nov 2026 18:34:21 +0800

Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma
lock") introduced the possibility of returning -EINTR from proc_get_vma()
when a fatal signal interrupts mmap_read_lock_killable().

The issue can be reproduced using stress-ng's VMA stressor, which reads
/proc/self/maps while concurrently modifying VMAs and periodically
terminates child processes with SIGKILL.  The reproduced command is:

  # stress-ng --vma 0 -t 60

When the VMA lookup is interrupted, proc_get_vma() returns an error
pointer without advancing the position index.  Consequently,
seq_read_iter() emits the following rate-limited informational message:

  seq_file: buggy .next function m_next did not update position index

Save the current position in priv->last_pos before checking the VMA lookup
result, allowing it to be reused by both successful and error paths. 
Advance the position index when returning an error to avoid the spurious
warning, while preserving the original error handling.

Link: https://patch.msgid.link/20261118103421.776-1-adrianhuang0701@gmail.com
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Adrian Huang <ahuang12@lenovo.com>
Cc: <stable@vger.kernel.org>

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-avoid-spurious-seq_file-warning-on-interrupted-vma-lookup
+++ a/fs/proc/task_mmu.c
@@ -216,16 +216,17 @@ static struct vm_area_struct *proc_get_v
 
 retry:
 	vma = get_next_vma(priv, *ppos);
-	/* EINTR of EAGAIN is possible */
+	/* Store previous position to be able to restart if needed */
+	priv->last_pos = *ppos;
 	if (IS_ERR(vma)) {
 		if (PTR_ERR(vma) == -EAGAIN && fallback_to_mmap_lock(priv, *ppos))
 			goto retry;
 
+		/* Advance to avoid spurious buggy seq warning in dmesg */
+		(*ppos)++;
 		return vma;
 	}
 
-	/* Store previous position to be able to restart if needed */
-	priv->last_pos = *ppos;
 	if (vma) {
 		/*
 		 * Track the end of the reported vma to ensure position changes
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch
docs-admin-guide-mm-damon-fix-various-typos.patch
docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch
docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch
fs-proc-task_mmu-avoid-spurious-seq_file-warning-on-interrupted-vma-lookup.patch

