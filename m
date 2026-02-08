Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3A03019B2
	for <mm-commits@vger.kernel.org>; Sun,  8 Feb 2026 08:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770538460; cv=none; b=ZD5l0SwdI+yZy/HseAiJiazvRNo6TuU+tyE1394b5vyx3dDWUKnfzKlCYzWKWYUNzHzFx+bzADZQcm5tkTMMqW555eOpCRFNbpQf4uoRCTzo2PkLQ/8VeH8UkYDKtuxCWzTOaB2LiGp4GBBrZBtWT4qdvOEppknOQ8opcMfiyNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770538460; c=relaxed/simple;
	bh=NQooE8qHPYOhOnuI/+a1fUFw9jKBIZ7ZpNpoeByUqh4=;
	h=Date:To:From:Subject:Message-Id; b=g29vr+F3oC16f5lDrLzuFw58Vlhr8OOQCM9x4syjyQWiCugkvhMl/GkoWImYG7p2OdKBl+RQ9IKYrwqMErH9WyJX7ataAahUOV2d519Q1JcJduaMcnVbRnu157t5Zdg7XzE94rDrYTacOm4CvxEB7yzHQ7b2poreJ/oRWGFyFjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VcaslV2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VcaslV2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DBAC4CEF7;
	Sun,  8 Feb 2026 08:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770538460;
	bh=NQooE8qHPYOhOnuI/+a1fUFw9jKBIZ7ZpNpoeByUqh4=;
	h=Date:To:From:Subject:From;
	b=VcaslV2NiuNWc/ff92HrNY+28P+MK6+jbc9tGzAV6RZ109VWb/vyRISsXklD/SCjX
	 NLlZloCJ+7qT3XX5j81TOphU0ONjkSxicneho1vdFMzfN7DqQTH4vCVLkzLVAFiNqy
	 0eOeARLceCXYBiDTul95tkDDU4WImnjPQIrcBmtU=
Date: Sun, 08 Feb 2026 00:14:19 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,ruippan@tencent.com,oleg@redhat.com,mjguzik@gmail.com,mingo@kernel.org,lorenzo.stoakes@oracle.com,david@kernel.org,alexjlzheng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] procfs-fix-missing-rcu-protection-when-reading-real_parent-in-do_task_stat.patch removed from -mm tree
Message-Id: <20260208081420.64DBAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: procfs: fix missing RCU protection when reading real_parent in do_task_stat()
has been removed from the -mm tree.  Its filename was
     procfs-fix-missing-rcu-protection-when-reading-real_parent-in-do_task_stat.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinliang Zheng <alexjlzheng@tencent.com>
Subject: procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Wed, 28 Jan 2026 16:30:07 +0800

When reading /proc/[pid]/stat, do_task_stat() accesses task->real_parent
without proper RCU protection, which leads to:

  cpu 0                               cpu 1
  -----                               -----
  do_task_stat
    var = task->real_parent
                                      release_task
                                        call_rcu(delayed_put_task_struct)
    task_tgid_nr_ns(var)
      rcu_read_lock   <--- Too late to protect task->real_parent!
      task_pid_ptr    <--- UAF!
      rcu_read_unlock

This patch uses task_ppid_nr_ns() instead of task_tgid_nr_ns() to add
proper RCU protection for accessing task->real_parent.

Link: https://lkml.kernel.org/r/20260128083007.3173016-1-alexjlzheng@tencent.com
Fixes: 06fffb1267c9 ("do_task_stat: don't take rcu_read_lock()")
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: ruippan <ruippan@tencent.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c~procfs-fix-missing-rcu-protection-when-reading-real_parent-in-do_task_stat
+++ a/fs/proc/array.c
@@ -529,7 +529,7 @@ static int do_task_stat(struct seq_file
 		}
 
 		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		ppid = task_ppid_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
_

Patches currently in -mm which might be from alexjlzheng@tencent.com are


