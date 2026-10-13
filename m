Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15662E4257;
	Tue, 13 Oct 2026 22:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929086; cv=none; b=j+VwJFQKVW6GEHtRh05emhxCWrRzxwOEABkMgNaiE3oiAUeA9OhE38RmiAPmm8atddEaOOqdS/s+IlKbRV5CTLZVvblRvJYCHiD0EiQMaMfrD0hWf3/DEbU9cDq3rzGJ6VNeYkqZ0V/Cq+ShW5xpCy4cFRIwGgwsHSKrYpJ58zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929086; c=relaxed/simple;
	bh=bqViiTd77EM1kuy6eCNnJD78Z9Ge3008/seCNG0raH0=;
	h=Date:To:From:Subject:Message-Id; b=oOcJhvD8HPKSHPdxKGKmSVLzvQ/i8N+6RORqTA7yqdw+OGXctGwN1pcRxRwNnjZKr2Yuo+A4Whgeq5pLzDLJ3K4luNf0DM+IlchhWeycIAOzqUsu2i49uAD5l+wc8ukiD6eq47HUS8kNYcP9+lUYIXc7I4rFF0uomgdhcySi7hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xq4Yu54v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xq4Yu54v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EAF1F000FF;
	Tue, 13 Oct 2026 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791929084;
	bh=Yq/4uiVdOKBsWCNpdvYvAGdimjd+WTugXDl5QfjFIUE=;
	h=Date:To:From:Subject;
	b=xq4Yu54vOVHxo6C/MDYhWOW1aEyGyAi9KuVRG7UpS1Ni521D3FCspDCLWOMJZV9pv
	 alwm2jANOXvG8btD6trfEatMHKNfc0ftzwBml3PUpUqlKX2mG18AWg7y/O/c/gTbcp
	 2dyyKtApUtXWKyikkT7XqHHTMh5cgL+AFTxGZK0s=
Date: Tue, 13 Oct 2026 15:04:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,andreas@gaisler.com,stian@itx.no,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch added to mm-unstable branch
Message-Id: <20261013220444.88EAF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix lost maps entries above 2^63
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch

This patch will later appear in the mm-unstable branch at
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
From: Stian Halseth <stian@itx.no>
Subject: fs/proc/task_mmu: fix lost maps entries above 2^63
Date: Tue, 13 Oct 2026 17:21:06 +0200

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

Skip the rewind only for 0 and the two sentinels instead, with an
addr_is_sentinel() helper.

Link: https://lore.kernel.org/20261013152106.1834364-1-stian@itx.no
Fixes: 5631da56c9a87 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Signed-off-by: Stian Halseth <stian@itx.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://github.com/sparclinux/issues/issues/111
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: <stable@vger.kernel.org>
---

 fs/proc/task_mmu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-lost-maps-entries-above-263
+++ a/fs/proc/task_mmu.c
@@ -32,6 +32,11 @@
 #define SENTINEL_VMA_END	-1
 #define SENTINEL_VMA_GATE	-2
 
+static bool addr_is_sentinel(loff_t addr)
+{
+	return addr == SENTINEL_VMA_END || addr == SENTINEL_VMA_GATE;
+}
+
 #define SEQ_PUT_DEC(str, val) \
 		seq_put_decimal_ull_width(m, str, (val) << (PAGE_SHIFT-10), 8)
 void task_mem(struct seq_file *m, struct mm_struct *mm)
@@ -263,7 +268,7 @@ static void *m_start(struct seq_file *m,
 	 * Reset current position if last_addr was set before
 	 * and it's not a sentinel.
 	 */
-	if (last_addr > 0)
+	if (last_addr && !addr_is_sentinel(last_addr))
 		*ppos = last_addr = priv->last_pos;
 	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
_

Patches currently in -mm which might be from stian@itx.no are

fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch

