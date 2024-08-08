Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59092BA2E;
	Thu,  8 Aug 2024 01:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081333; cv=none; b=sAPPsOQbbEgXnCza3O5f4CHIrK9TOgL07Vwaq8AVSERJ5V9q4PPeI78q3tyykw+toUCRiOgtJd35FmjMzqHg8BO7s7rfQMOO78hmyNYRO5g/cLL5fO+gn/0FE5+/4eaKaObBq3fP2ZAT1IbMBpwnFf0AHfeYV5KyRU32m4Wk2nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081333; c=relaxed/simple;
	bh=xWmLpKp0Ac8XPeQqEx4a8rmkmrPo/todtY2+bEuVtQg=;
	h=Date:To:From:Subject:Message-Id; b=mXUz0fLSVjyQCXBqExCCtZBpT4Hsb/jinhpHnAMdc4Yj13Zkct1wylDJYF2PlBVB1BhrhV3mCRtdwtE5AVxkTBLyhd/G+vIqPTufHGxPCpyCiOmk0Gg5JIjadbblZQaN/MWhKwgSuCbXubHlSG7t+LWTwa3sR6SaOJse5eAZhbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZwLuu6tH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZwLuu6tH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EADAC32781;
	Thu,  8 Aug 2024 01:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723081333;
	bh=xWmLpKp0Ac8XPeQqEx4a8rmkmrPo/todtY2+bEuVtQg=;
	h=Date:To:From:Subject:From;
	b=ZwLuu6tHahoJbEzfYHGjOP7G6KKSIgWAMQwfp19GdTgjnzQOtDZwO1hH1ZVivJAXO
	 RbeHTt6C3Bixy8agTqh3K3+SA/wOX61J4FZCdxuHvdLKH9WRs+jXKOje6/hzXj4Sc5
	 ZYdrPxQ+b912CZ0kpfeTDjYvgOqDHVNtX3rqGsGk=
Date: Wed, 07 Aug 2024 18:42:12 -0700
To: mm-commits@vger.kernel.org,steffen.klassert@secunet.com,stable@vger.kernel.org,daniel.m.jordan@oracle.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] padata-fix-possible-divide-by-0-panic-in-padata_mt_helper.patch removed from -mm tree
Message-Id: <20240808014213.1EADAC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: padata: fix possible divide-by-0 panic in padata_mt_helper()
has been removed from the -mm tree.  Its filename was
     padata-fix-possible-divide-by-0-panic-in-padata_mt_helper.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: padata: Fix possible divide-by-0 panic in padata_mt_helper()
Date: Tue, 6 Aug 2024 13:46:47 -0400

We are hit with a not easily reproducible divide-by-0 panic in padata.c at
bootup time.

  [   10.017908] Oops: divide error: 0000 1 PREEMPT SMP NOPTI
  [   10.017908] CPU: 26 PID: 2627 Comm: kworker/u1666:1 Not tainted 6.10.0-15.el10.x86_64 #1
  [   10.017908] Hardware name: Lenovo ThinkSystem SR950 [7X12CTO1WW]/[7X12CTO1WW], BIOS [PSE140J-2.30] 07/20/2021
  [   10.017908] Workqueue: events_unbound padata_mt_helper
  [   10.017908] RIP: 0010:padata_mt_helper+0x39/0xb0
    :
  [   10.017963] Call Trace:
  [   10.017968]  <TASK>
  [   10.018004]  ? padata_mt_helper+0x39/0xb0
  [   10.018084]  process_one_work+0x174/0x330
  [   10.018093]  worker_thread+0x266/0x3a0
  [   10.018111]  kthread+0xcf/0x100
  [   10.018124]  ret_from_fork+0x31/0x50
  [   10.018138]  ret_from_fork_asm+0x1a/0x30
  [   10.018147]  </TASK>

Looking at the padata_mt_helper() function, the only way a divide-by-0
panic can happen is when ps->chunk_size is 0.  The way that chunk_size is
initialized in padata_do_multithreaded(), chunk_size can be 0 when the
min_chunk in the passed-in padata_mt_job structure is 0.

Fix this divide-by-0 panic by making sure that chunk_size will be at least
1 no matter what the input parameters are.

Link: https://lkml.kernel.org/r/20240806174647.1050398-1-longman@redhat.com
Fixes: 004ed42638f4 ("padata: add basic support for multithreaded jobs")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Waiman Long <longman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/padata.c~padata-fix-possible-divide-by-0-panic-in-padata_mt_helper
+++ a/kernel/padata.c
@@ -517,6 +517,13 @@ void __init padata_do_multithreaded(stru
 	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
+	/*
+	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
+	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
+	 */
+	if (!ps.chunk_size)
+		ps.chunk_size = 1U;
+
 	list_for_each_entry(pw, &works, pw_list)
 		if (job->numa_aware) {
 			int old_node = atomic_read(&last_used_nid);
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu.patch
mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3.patch
lib-stackdepot-double-depot_pools_cap-if-kasan-is-enabled.patch
watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

