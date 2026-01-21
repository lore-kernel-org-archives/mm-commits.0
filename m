Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E861F192E
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967398; cv=none; b=Q0UF5ki2lt8zmbqhb++vCbNlYMpxVoLZIWCnGaWDTyptpnanDcM4soAoTisC+HQlIFVmgWXT5BPd/AJlzbSZphfobD2D2qMm2oPYpcZszb4kAaSMbyPckLQulVRM2n2wUZrUm67OMS1nEkmQlAaFE0Gq/9F6ggzHWQu4bA8JyKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967398; c=relaxed/simple;
	bh=cG88pF7CkQ21QP6WqrfPkHVCqL0JGxyC6gqagKO6Xq0=;
	h=Date:To:From:Subject:Message-Id; b=ps2lALGYBs8DRSpQIPeDWWYINLuCRb4inlXq71Q/rs/lOqft29pagiqdOdkJyhp588H4A4wvJhUylIJOL+pM8EUqQp8DrVwwV018YVhooobxl1FZgv9iOAyRshOUrCs10ZeiQrLzK+CGqt44DbbxKO0x8w90N7K0rkaGcb5bKro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0WG3bwrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0WG3bwrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F32C16AAE;
	Wed, 21 Jan 2026 03:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967398;
	bh=cG88pF7CkQ21QP6WqrfPkHVCqL0JGxyC6gqagKO6Xq0=;
	h=Date:To:From:Subject:From;
	b=0WG3bwrGWrBg8aTDHLT7n5QoGLjgQiZNJ1iK4jZ4/ICqKMQ+V6WZfOCMhFCl+yU/J
	 BUW+M2U34yn7oojNdR4wiszIWF1llcfBF5yRdfMA/Y6jfFJUvoW0lCCuqcgDJnXesl
	 3/Hi4a7ck6/85+huECLQYmwG1w7bnZ05biyZXGEA=
Date: Tue, 20 Jan 2026 19:49:57 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,jqqlijiazi@gmail.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,mingzhu.wang@transsion.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-fork-update-obsolete-use_mm-references-to-kthread_use_mm.patch removed from -mm tree
Message-Id: <20260121034958.00F32C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/fork: update obsolete use_mm references to kthread_use_mm
has been removed from the -mm tree.  Its filename was
     kernel-fork-update-obsolete-use_mm-references-to-kthread_use_mm.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: mingzhu.wang(王明珠) <mingzhu.wang@transsion.com>
Subject: kernel/fork: update obsolete use_mm references to kthread_use_mm
Date: Wed, 7 Jan 2026 08:15:32 +0000

The comment for get_task_mm() in kernel/fork.c incorrectly references the
deprecated function `use_mm()`, which has been renamed to
`kthread_use_mm()` in kernel/kthread.c.

This patch updates the documentation to reflect the current function
names, ensuring accuracy when developers refer to the kernel thread memory
context API.

No functional changes were introduced.

Link: https://lkml.kernel.org/r/KUZPR04MB8965F954108B4DD7E8FFDB2B8F84A@KUZPR04MB8965.apcprd04.prod.outlook.com
Signed-off-by: mingzhu.wang <mingzhu.wang@transsion.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiazi Li <jqqlijiazi@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-fork-update-obsolete-use_mm-references-to-kthread_use_mm
+++ a/kernel/fork.c
@@ -1356,7 +1356,7 @@ struct file *get_task_exe_file(struct ta
  * @task: The task.
  *
  * Returns %NULL if the task has no mm.  Checks PF_KTHREAD (meaning
- * this kernel workthread has transiently adopted a user mm with use_mm,
+ * this kernel workthread has transiently adopted a user mm with kthread_use_mm,
  * to do its AIO) is not set and if so returns a reference to it, after
  * bumping up the use count.  User must release the mm via mmput()
  * after use.  Typically used by /proc and ptrace.
_

Patches currently in -mm which might be from mingzhu.wang@transsion.com are


