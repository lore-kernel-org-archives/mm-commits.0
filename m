Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793562523;
	b=Jt3pn5C9OKCh0Dp5wJ7CsVVm1Vo72tRYxVeu22lyZ3GbHk0cavjsm1SO5NWpKIuGeJo9
	 G3AuKNgUq1D4NymBJFxo89k3IX+mbYIKpsVXPWnLktFfrWxI0CqKnQGf6ObLjoopMY5AB
	 8c3JIn50BDtPjxFdwKM4cocJY+20IAvYj6hSXbl/2Q/GuhsAajUnQDlgZcW5qPvytrk+n
	 8HxUMxnR5Y9uP0jArVT5aQVJAOlW9wVQhBnVtMtLJIGk+Ri6eD13NsRapnb6uH7tVUoLM
	 PpUjVZSDau02Yf7gfzJi6whudVqBlyF4m+bn5ik/lCjrj2ho09AAeczNL9VqURVQ+Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562523;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=66rZVd8CJ+jfrNYYUx2TQzDqzwN7I1LLXe/ZBDbZBfs=;
	b=WK+Ppr2N3Q9lDLLu3/awSqgbTZGyL8zDCjXvkhGXih9pYcPQZcEmMkOBCQPzlv2FkNG6
	 /p5qQKXP+VP1QwxZkXvpkxOt1MM55uuBKQPVyj9VFcg89bKPdB0xuIUOJRW5rSblcfMrn
	 1s9sLh6sUZgW7c5mYPwSywVCeUgo86QnIgj4KLLahCkx6r69r7PyIDOyeNXqQaIJv7RKS
	 y+QVCc6OFa623wrCDz+hw+9qclaQS9xxpabeU40OMy/AbneCLfd4JVF5j6y3WlX1SZGDZ
	 ZbBoCGCqRBv9+2cYq9sZukJLM5ELx6RfJZVS/1vRjiQSPFq6upYux+mIKG03f5uvnAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2Q1HyxCz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08265606A324;
	Sun,  1 Nov 2026 19:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2Q1HyxCz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF261F000C1;
	Sun,  1 Nov 2026 19:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793562522;
	bh=66rZVd8CJ+jfrNYYUx2TQzDqzwN7I1LLXe/ZBDbZBfs=;
	h=Date:To:From:Subject;
	b=2Q1HyxCzqyNKeaJKITrJVO/CxJlClwkV/4rR96y/AoMoECJFMggWuGWj8nugB7V6+
	 tOuuI2YfMSAbPFNUUHaUhhG5+MoPZ5ihfPnbIuWn0Ou+kiYZSCgQWtBfRafFQxiWPb
	 sOsDwI+H3V7f8qbG2zAOnVoEx6tLznZC0C5xF010=
Date: Sun, 01 Nov 2026 11:48:42 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	wangkefeng.wang@huawei.com,sunnanyong@huawei.com,stable@vger.kernel.org,
	odys.yuan@gmail.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,
	xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-softlockup-in-do_pages_stat-with-huge-page-arrays.patch added to mm-new branch
Message-Id: <20261101194842.7DF261F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/migrate: fix softlockup in do_pages_stat() with huge page arrays
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-fix-softlockup-in-do_pages_stat-with-huge-page-arrays.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-softlockup-in-do_pages_stat-with-huge-page-arrays.patch

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
From: Qi Xi <xiqi2@huawei.com>
Subject: mm/migrate: fix softlockup in do_pages_stat() with huge page arrays
Date: Sat, 31 Oct 2026 11:33:30 +0800

do_pages_stat() walks the user page array in 16-page chunks but never
reschedules, so a huge nr_pages can hold a CPU past the watchdog threshold
on non-preemptible kernels.  Add cond_resched() to the loop so long
move_pages() node-query calls yield periodically.

With KASAN and function tracing enabled, a move_pages() node query (nodes
== NULL) over 10 million page entries (~40GB) can trigger the softlockup
on a PREEMPT_NONE kernel.

Link: https://lore.kernel.org/20261031033330.3416326-1-xiqi5703@163.com
Fixes: 80bba1290ab5 ("mm: no get_user/put_user while holding mmap_sem in do_pages_stat?")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: <stable@vger.kernel.org>
---

 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/migrate.c~mm-migrate-fix-softlockup-in-do_pages_stat-with-huge-page-arrays
+++ a/mm/migrate.c
@@ -2555,6 +2555,7 @@ static int do_pages_stat(struct mm_struc
 
 		chunk_offset += chunk_nr;
 		nr_pages -= chunk_nr;
+		cond_resched();
 	}
 	return nr_pages ? -EFAULT : 0;
 }
_

Patches currently in -mm which might be from xiqi2@huawei.com are

mm-migrate-fix-softlockup-in-do_pages_stat-with-huge-page-arrays.patch

