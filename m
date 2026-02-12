Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5478E3EBF1B;
	Thu, 12 Feb 2026 23:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939650; cv=none; b=uzxZ3VEeNFCJwUo27IAPpkjjVtnvvRM2Q/MBkGliASIbIr6DX6eQ1D0tOTs57FvWrI+Twj3nMMl3Q0LBhOasGL2PbFkm0siNPNrN50RgqpYyYowna4wjV6Uj3Ur7GIT7jYQoqEcmY27qYV19aYSTPMRmlWmFzJAsCFcGEGy9zS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939650; c=relaxed/simple;
	bh=+xknwzrJqwMB0PrfLpeEnB4TpPBFZ7/nhgwA87neMQY=;
	h=Date:To:From:Subject:Message-Id; b=WAa64KX2K37Cm+6imioNnz5oDFlHYl9oHjnxyoI49TbyVqPgzcmWstXgF3rZlgdT0YdY14jJACVi7rpeMiwPAG0/C1XySsHyf9sMn/vBv8Vu613MFn2gpFJu22lE0glzHfKSibFMJ0Pk7ht4SAD8T15W/PwZko1J4qq5vodv78I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dmng3AE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dmng3AE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FC6C19421;
	Thu, 12 Feb 2026 23:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939650;
	bh=+xknwzrJqwMB0PrfLpeEnB4TpPBFZ7/nhgwA87neMQY=;
	h=Date:To:From:Subject:From;
	b=Dmng3AE8wTiE6Ie+GNKpXH+WhViArvDYEFvjG23I5OC10Mt1ebZ50wqBY6LuDZyG1
	 BoFN9TmaxwbS9STRy3OsYvg0dcvy5l5VoWxRQxVoVcIK3mYK1zw2W58tA6Tb3WYk0A
	 e8XGaec2oqHGHk8I9k277K+iQEQSeZb6ybwsqHs4=
Date: Thu, 12 Feb 2026 15:40:49 -0800
To: mm-commits@vger.kernel.org,tglx@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,ruikai@pwno.io,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] procfs-fix-possible-double-mmput-in-do_procmap_query.patch removed from -mm tree
Message-Id: <20260212234050.03FC6C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: procfs: fix possible double mmput() in do_procmap_query()
has been removed from the -mm tree.  Its filename was
     procfs-fix-possible-double-mmput-in-do_procmap_query.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Cc: Ruikai Peng <ruikai@pwno.io>
Closes: https://lkml.kernel.org/r/CAFD3drOJANTZPuyiqMdqpiRwOKnHwv5QgMNZghCDr-WxdiHvMg@mail.gmail.com
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


