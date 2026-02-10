Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA05A1FB1;
	Tue, 10 Feb 2026 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770751979; cv=none; b=r97shVnQxNenmx0c+RbCg/TmJR7YqPzGUkmPM7qwFbeTUXN4i9DVSlVsJtM8q5wJRprhgKWg3Fq3O3CYaxhcMkbsfpcSBAVnDRMpsz7WDWBuvtFnhMtgr93V3wMwV63fC0q+oxuO3+PQsG7u4M2p14WRsjp4SfHBt17J2nVYsok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770751979; c=relaxed/simple;
	bh=aJaQgc9RiUGvmnXKSPrxC6bbowcWSn8ILZ5/EO+IxxA=;
	h=Date:To:From:Subject:Message-Id; b=I97HES7nOVGUkRVKeZn8z0p7vhGx5YfhKEQOpzB0DFsAyrpBjmsH217eJfNUN5lvNkASKpeL2lRrCguPSj69IbiZQk/rmwD2r7SlNqHGvBoN5vf5DASgYx346r/c1OMuEPGNAYURQTjaU44FA+ymXOK87AvlHmk2D/P7bsZZu9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uF0QGUH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uF0QGUH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FA8C116C6;
	Tue, 10 Feb 2026 19:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770751979;
	bh=aJaQgc9RiUGvmnXKSPrxC6bbowcWSn8ILZ5/EO+IxxA=;
	h=Date:To:From:Subject:From;
	b=uF0QGUH8wQE4C0Tsq06ArI+by5hwYizp0SXHSd/AiwFpR26eu5suIMzkbT6sZ8WCs
	 dT15mmul4E4/OQ/5ptMz5Dq9RioaS0Sd0vIRbV/x2VxybZWoT9my18tzHpzhHMdGHs
	 XflUjPNxnEnpxH0eUe2sgdQoW2u+BLgHLUya5VmE=
Date: Tue, 10 Feb 2026 11:32:58 -0800
To: mm-commits@vger.kernel.org,tglx@kernel.org,stable@vger.kernel.org,ruikai@pwno.io,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + procfs-fix-possible-double-mmput-in-do_procmap_query.patch added to mm-hotfixes-unstable branch
Message-Id: <20260210193259.40FA8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: procfs: fix possible double mmput() in do_procmap_query()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     procfs-fix-possible-double-mmput-in-do_procmap_query.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/procfs-fix-possible-double-mmput-in-do_procmap_query.patch

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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: procfs: fix possible double mmput() in do_procmap_query()
Date: Tue, 10 Feb 2026 11:27:38 -0800

When user provides incorrectly sized buffer for build ID for PROCMAP_QUERY
we return with -ENAMETOOLONG error.  After recent changes this condition
happens later, after we unlocked mmap_lock/per-VMA lock and did mmput(),
so original goto out is now wrong and will double-mmput() mm_struct.  Fix
by jumping further to clean up only vm_file and name_buf.

Link: https://lkml.kernel.org/r/20260210192738.3041609-1-andrii@kernel.org
Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA lock")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reported-by: Ruikai Peng <ruikai@pwno.io>
Reported-by: Thomas Gleixner <tglx@kernel.org>
Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Cc: Ruikai Peng <ruikai@pwno.io>
CLoses: https://lkml.kernel.org/r/CAFD3drOJANTZPuyiqMdqpiRwOKnHwv5QgMNZghCDr-WxdiHvMg@mail.gmail.com
Closes: https://lore.kernel.org/all/698aaf3c.050a0220.3b3015.0088.GAE@google.com/T/#u
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~procfs-fix-possible-double-mmput-in-do_procmap_query
+++ a/fs/proc/task_mmu.c
@@ -780,7 +780,7 @@ static int do_procmap_query(struct mm_st
 		} else {
 			if (karg.build_id_size < build_id_sz) {
 				err = -ENAMETOOLONG;
-				goto out;
+				goto out_file;
 			}
 			karg.build_id_size = build_id_sz;
 		}
@@ -808,6 +808,7 @@ static int do_procmap_query(struct mm_st
 out:
 	query_vma_teardown(&lock_ctx);
 	mmput(mm);
+out_file:
 	if (vm_file)
 		fput(vm_file);
 	kfree(name_buf);
_

Patches currently in -mm which might be from andrii@kernel.org are

procfs-fix-possible-double-mmput-in-do_procmap_query.patch

