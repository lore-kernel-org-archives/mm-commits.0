Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2E924468C
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 20:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768510093; cv=none; b=C+eBodfkpAujv53nRomKlliZOgb6a5cuN/rIVIn0s0Eh3NwCv+K9+VKU7HIILHJyDok7hhjA4eOvyIUv430Wtq9NYEmsSIeVaKzuEPrrTPA3vn9nUm8HtvUWuDz0mUrV8wuf5rWF/Tk9F6gXHInVhcPqhjKhFK4tqYBkuUg+fdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768510093; c=relaxed/simple;
	bh=ZT4Mpx73mN9B8N6F97Ycobg7SlFbZSK6WWGW+yJYzf0=;
	h=Date:To:From:Subject:Message-Id; b=XRhVWdtINFaOyFG3umgmX6zSxgO1OqdYEmlHEJYITVhnySc/5sxfch4y6GV1jUrHoLa2RG9D7tylYJtYA8dgNzlqbliN+IcF3CGo7cEK2Vsfp/nl84Y5aCvztECZbkLEc/TUQJEkCjo1vZn1XnHCsWyYb03gkrkYh8LzslMEJCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=noH7Xk7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="noH7Xk7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A769C116D0;
	Thu, 15 Jan 2026 20:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768510092;
	bh=ZT4Mpx73mN9B8N6F97Ycobg7SlFbZSK6WWGW+yJYzf0=;
	h=Date:To:From:Subject:From;
	b=noH7Xk7ZKIO1tPsgmg1qJ0EVHvdmll3A6fdRkAmsXhQ97Fqcre5nqFu/1y1qkHsHV
	 dljFWEjW2EmPK2Pv9N9zhR7qmShCY62Hfuktc7PUOt60BRrsABJ/xcjTIirWdxXMCW
	 1a6+tn9iSTdHxRPmGzozW+4rpEtBjaJ6Xg4u/Mt4=
Date: Thu, 15 Jan 2026 12:48:11 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,songmuchun@bytedance.com,lkp@intel.com,kartikey406@gmail.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch added to mm-new branch
Message-Id: <20260115204812.7A769C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch

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
Subject: mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix
Date: Thu Jan 15 12:37:55 PM PST 2026

add missed rcu_unlock(), needed by "mm/swap_cgroup: fix kernel BUG in
swap_cgroup_record".

Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix
+++ a/mm/memcontrol-v1.c
@@ -639,8 +639,10 @@ void memcg1_swapout(struct folio *folio,
 	 * in swapcache, reusing the same swap entries.
 	 */
 	oldid = lookup_swap_cgroup_id(entry);
-	if (oldid == mem_cgroup_id(memcg))
+	if (oldid == mem_cgroup_id(memcg)) {
+		rcu_read_unlock();
 		return;
+	}
 	VM_WARN_ON_ONCE(oldid != 0);
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-hugetlb-enforce-brace-style-checkpatch-fixes.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

