Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0E62264AD
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 02:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768356108; cv=none; b=VVlSnUBPjTQKher+YVBxBYi9IIsrlLfa3FCFeN+jp4VRjh3VYEKIKJZp1XIolzg9rBUmO/yN/v5afaiuRqHZTaiiy+LRNMakWLRlAwu7MBHPrbnyAkNkeWWU1qu3zN/AraFSUkDycloUPpPXwsuYvlNDgbqGVa1Req841KYTkEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768356108; c=relaxed/simple;
	bh=G7e+QP0dQT62Mkt/0CaRzxCbJiZ3ZZ/PqVjoGs2MUPg=;
	h=Date:To:From:Subject:Message-Id; b=W3+ayUomXQpzsawd0Ww7RT4Ntllw+Sa03iVK3g6Ye7d1MlxH1LtGxQRq08uqwdb/SUxl1xAhImScimJne8ns+M0gxPJH8habpnlNB8sqIHTgm6TCIJouJG+FyEM40qClvKW5/g5ByRyASjRZE5O3qvdV69rGzZzv48KwO//j0Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qjoNmGV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qjoNmGV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5657C116C6;
	Wed, 14 Jan 2026 02:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768356107;
	bh=G7e+QP0dQT62Mkt/0CaRzxCbJiZ3ZZ/PqVjoGs2MUPg=;
	h=Date:To:From:Subject:From;
	b=qjoNmGV4UzMFzCHd5yzYv1/HSSvKmbKmfI0B5kz2D4YiJgpbDR7Uwh1XkVOu/xTzB
	 1W70vML+KbB3QR3rm9LN6RJtvlRIM3p8YnT++qRJsmVtSzDWtPow0tb+itCrVRV8zs
	 90EHDo+3BxcM5eHQ5tCxnBig1nZG7KDatzlAPeyg=
Date: Tue, 13 Jan 2026 18:01:47 -0800
To: mm-commits@vger.kernel.org,marco.crivellari@suse.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch added to mm-new branch
Message-Id: <20260114020147.D5657C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch

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
Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix
Date: Tue Jan 13 05:59:13 PM PST 2026

fix mm/slub.c

Cc: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix
+++ a/mm/slub.c
@@ -8546,6 +8546,7 @@ void __init kmem_cache_init_late(void)
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
+#endif
 }
 
 struct kmem_cache *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

