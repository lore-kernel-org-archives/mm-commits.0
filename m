Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EB8531631;
	Tue, 13 Oct 2026 22:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929032; cv=none; b=dZK9o52r9zzPHkFEjPsJh4K17l8GdF8LQ23GiAPz6025KxP6MH/2brloKifqU9MhZSe4hQ6KLu/soCeFMFbctEoatvzdAI2y55sFqNicMQEIBYtw8ob1KavzTcCmQzRuM9hKl+Eip6/b8xbCUzpHCP4MA7hGrMrrb3EGn3lpXZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929032; c=relaxed/simple;
	bh=vs20gosu5BkEagPWNjKnlIQMISf6i/Vb34TT7qhddm0=;
	h=Date:To:From:Subject:Message-Id; b=clhNxHj6DZ5FuO15F0+jy6uOTkaO8OB1Y/Ik7fjLyffhkxQvezZz+gmG7hLVqbprTmWuVWwWEa4nrFQkV1xjuSA1IzSyJGWi5i9Ytx3WiVL1t1h+7UjKNqn3xdwLTa4Pk98jFBGcEQ2MnWvMz1u/OAh2QgjxUugQPC/5Bqptp7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cuugeKDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cuugeKDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EDF1F000FF;
	Tue, 13 Oct 2026 22:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791929031;
	bh=CMEJ5TtrAxLfn2bAeNc0FmgUbaFeWvP+COI1/cz9JLc=;
	h=Date:To:From:Subject;
	b=cuugeKDxL9ny0KznpAELG1lFynj1D85iAph+cHjgbDXpelm0ZC0WkSP1UgEe3QtKj
	 IcPKLaF7qpgUAx/wJX56zrRLXeRpHXsiF9Y1O9D0PV+3hj/G+nc8uCMS8P4MGuCQ2R
	 JbzHSSqJLhC+6BM4/JirG9vNom0gTl0VRYLmMDMo=
Date: Tue, 13 Oct 2026 15:03:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,andreas@gaisler.com,stian@itx.no,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch removed from -mm tree
Message-Id: <20261013220351.59EDF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: fix lost maps entries above 2^63
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch

This patch was dropped because an updated version will be issued

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
Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
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


