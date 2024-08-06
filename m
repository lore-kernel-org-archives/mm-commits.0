Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDA418D62B;
	Tue,  6 Aug 2024 19:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722971081; cv=none; b=jTt5LFkaDkW44cqsOz5z5hVIbO1pyYH4UiZ38qHt2gjAsv8ab0qAYA7NlHCtVqhpRMqd7R8H83YyaI18pveZbZFXbKZJH3D/R8kcqIrU4vg7wPu6wSx+iPtQIxgyi20aubnDk7/lZgUi2fFbG5WkM3sML8VVQqC8KQq/nDjeueA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722971081; c=relaxed/simple;
	bh=WyWUmoDKvpQ2s7/mULwN8NHIX9zdfA251G4RCegwbCU=;
	h=Date:To:From:Subject:Message-Id; b=tC4kTKIARzVeWx+HexrH/eA98+yBQsxaTGWzaLO830AlK3ejO8mEVXWdZkgylc3o5FJ9epCUyTJKNNmdtx7yFHTLJvS7TwRvoLopT5NUFSIsL6p/VRTgkikl/DFNR/3w5FBuoq3/8KLSKiRy4lBOekg2iu9mP2d37po09Nc3Ds0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JxISWKs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JxISWKs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83986C32786;
	Tue,  6 Aug 2024 19:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722971080;
	bh=WyWUmoDKvpQ2s7/mULwN8NHIX9zdfA251G4RCegwbCU=;
	h=Date:To:From:Subject:From;
	b=JxISWKs1G96IGUNZ0yQi94cemkryUu+E2a05Tk+8AP5zeBd/2WdFERDembhgX7kLU
	 vczNuPeHEKjmrq7rUuxSvpA5NgWfnYowPOU7wfbABQruuovqzTfbGyjbqiSvSlHvgZ
	 tCi5qZFdDpUOGF/tuY2xfr1WnUTrYhtqlQfyk1Jg=
Date: Tue, 06 Aug 2024 12:04:39 -0700
To: mm-commits@vger.kernel.org,steffen.klassert@secunet.com,stable@vger.kernel.org,daniel.m.jordan@oracle.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + padata-fix-possible-divide-by-0-panic-in-padata_mt_helper.patch added to mm-hotfixes-unstable branch
Message-Id: <20240806190440.83986C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: padata: Fix possible divide-by-0 panic in padata_mt_helper()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     padata-fix-possible-divide-by-0-panic-in-padata_mt_helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/padata-fix-possible-divide-by-0-panic-in-padata_mt_helper.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

padata-fix-possible-divide-by-0-panic-in-padata_mt_helper.patch
watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

