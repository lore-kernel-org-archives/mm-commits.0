Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5CD38B143;
	Mon, 12 Oct 2026 02:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791771675; cv=none; b=nq8BZkR2tPVxxzj5/c8Z3FRb599gOhKo2itBK2x/BtlYX41nq9NVC9KEftSFWfrvPrhIN89ugtCZUgHlXrZ2RrDPDQGjc7h/jOtHOs1Ofr4vpggwW4xRNkmW84AxmMnvw8Z6UJa8UfmezdXuDCJ2t2yKs+CWz+Mrzk6DDh1SQ8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791771675; c=relaxed/simple;
	bh=aKgdryeWoobGJ7K/pvy9EFcfjPH2Tn/POnPqMtepJw0=;
	h=Date:To:From:Subject:Message-Id; b=u+yw7ZOUuqBnZ8/vO9GqLpo7PkafYt2ANUfb13KUUGSicYrLZANma3moSGQP1BxWvvTgb/1ajbiE3vRXoKgcnhBGJpigjMoiWWwM6GQw6oCrHa15KizfakbOL3/lDuJTUVFTqHKGel0PRQgMcnRN4+R6e5GKiVKUR/6AB7Ozi2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uZCm/loR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uZCm/loR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4238D1F0089B;
	Mon, 12 Oct 2026 02:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791771674;
	bh=IzRWNMnEtrINrufRcsgznRsyGlOmvfNuDh13CBTZz9c=;
	h=Date:To:From:Subject;
	b=uZCm/loRB+czaD3/eZZW8+b4t23TME1ohIACPiw8ArV/ZP50Achfd9RoQN3oM4hJe
	 dYNE/YNQ3EUKbS7sSOI/96YoBI85rsc1Xvdb60zPnqcEXRswlRl8y7W4KHT5UCJDKn
	 A8ZxSyjHhd0jKixLera65aJBIBbBQ88SZJDUHHC4=
Date: Sun, 11 Oct 2026 19:21:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,andreas@gaisler.com,stian@itx.no,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch added to mm-new branch
Message-Id: <20261012022114.4238D1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix lost maps entries above 2^63
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch

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
From: Stian Halseth <stian@itx.no>
Subject: fs/proc/task_mmu: fix lost maps entries above 2^63
Date: Sun, 11 Oct 2026 18:20:19 +0200

When a read of /proc/pid/{maps,smaps,numa_maps} resumes, m_start() rewinds
*ppos to priv->last_pos so that the vma which did not fit into the
previous buffer is shown again.  It only does so for last_addr > 0,
meaning to exclude the start of the file and SENTINEL_VMA_GATE, but
last_addr is a signed loff_t holding a vm_end.  sparc64 maps shared
libraries, anonymous memory and the stack above 0x8000000000000000, so the
rewind does not happen there and one entry is lost at every read()
boundary.

Reading the maps file of a process with read sizes from 64 to 8192 bytes
in steps of 64 loses lines at 126 of the 128 sizes, smaps at 123 and
numa_maps at 97, and the proc-maps-race selftest fails 4 of its 6 tests. 
Python's sys.remote_exec() reads maps with fgets() and fails
intermittently when it misses the libpython data mapping.

Test for the two values that are not a vma end instead.

Link: https://lore.kernel.org/20261011162019.922436-1-stian@itx.no
Fixes: 5631da56c9a87 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Signed-off-by: Stian Halseth <stian@itx.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://github.com/sparclinux/issues/issues/111
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: <stable@vger.kernel.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-lost-maps-entries-above-263
+++ a/fs/proc/task_mmu.c
@@ -263,7 +263,7 @@ static void *m_start(struct seq_file *m,
 	 * Reset current position if last_addr was set before
 	 * and it's not a sentinel.
 	 */
-	if (last_addr > 0)
+	if (last_addr && last_addr != SENTINEL_VMA_GATE)
 		*ppos = last_addr = priv->last_pos;
 	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
_

Patches currently in -mm which might be from stian@itx.no are

fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch

