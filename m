Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8663033CA
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 16:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768928094; cv=none; b=AvaffMCc3dlXjcc0BJ0JNNDEMOe6T93aiKHl0BFivVdVS9XguIm5P6ciPq+gnYa4fDpkc1m2GxS7rWLZjLrppFsIOgoKLFWrVW9hymO0nGc72Vh/ZcF8YKXXRf97tfsAg0/1pg31UuLFmLJwRkIr2MIP2W2ppbCt8N8MoXTxUi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768928094; c=relaxed/simple;
	bh=sovaZ48IOZAfYjxOID5xV1C/yBbp5Ty+qBnZK7TJRc4=;
	h=Date:To:From:Subject:Message-Id; b=dpPPZlgzus1DsHPF/pNM4ryChx9XGWTwniTKK3Jj0yqFXZSDXCmxV66uNBTwOmlpUuXmyjsYGnxzi3TDNpN6W7dnG/PlZKHhwezTrUk73sv90QELvcrndgS8Lh2dgrgdZgJQkaZYZGzQ//fpJdZhFF8Bebqh3vGx51MigNYYu7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2g/zdBdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2g/zdBdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA8EC16AAE;
	Tue, 20 Jan 2026 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768928094;
	bh=sovaZ48IOZAfYjxOID5xV1C/yBbp5Ty+qBnZK7TJRc4=;
	h=Date:To:From:Subject:From;
	b=2g/zdBdrvHSEsgZhjSfGRqa1ZpvxUOy9TVZSEPA3Wbgc9su9AJmZXfeny/So/SyOV
	 h84jqQOyX/zX/Nj5QNumFFW2h8A/MwvBeAvnYUd32yhqCWU9Q/cGGrBPV4wxh66onC
	 m1ACEXi0xU9DAZhh5CycdYtOomm/4caZZVpede2I=
Date: Tue, 20 Jan 2026 08:54:53 -0800
To: mm-commits@vger.kernel.org,zenghongling@kylinos.cn,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-use-min-to-simplify-the-code-fix.patch added to mm-new branch
Message-Id: <20260120165454.1EA8EC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-pagewalk-use-min-to-simplify-the-code-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-pagewalk-use-min-to-simplify-the-code-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-use-min-to-simplify-the-code-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-pagewalk-use-min-to-simplify-the-code-fix
Date: Tue Jan 20 08:54:09 AM PST 2026

add newline, per Lorenzo

Cc: David Hildenbrand <david@kernel.org>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/pagewalk.c~mm-pagewalk-use-min-to-simplify-the-code-fix
+++ a/mm/pagewalk.c
@@ -313,6 +313,7 @@ static unsigned long hugetlb_entry_end(s
 				       unsigned long end)
 {
 	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
+
 	return min(boundary, end);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
zram-fixup-read_block_state-fix.patch
zram-fixup-read_block_state-fix-2.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

