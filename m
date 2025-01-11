Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFA11114;
	Sat, 11 Jan 2025 00:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555220; cv=none; b=Orl0vfNPLWnSADDedN4LKdJJnMBalCpsPgkIRQuSC2HJ1jnigZlSt5aepwKADnSs5lJU7nQi3Vp+zF2v2DVIgsK9Qkic/YyKF7zPsMnpbg2HwPZMVAvFzJhvsOf/lUFx4rUdMtusogLWaoXTltH82sgSspI6NC58i+C2nNg+ovM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555220; c=relaxed/simple;
	bh=KNFl3RxXXwuBNnJZ1sLmmZNKfV1R5wxmFVtgs9X+e20=;
	h=Date:To:From:Subject:Message-Id; b=JvqX5ii/sSSxBYccS//m6jTnDcqz265eNTSnXKQZGBi7srHorrysCQ+0msj8L+xD7nQ6/WcTFauIDW9gsG4e5ws1Dlx5xZicRhM/D8q9YT18E1l7ajxNbaxjrBE3u5fA/y/xd4WhSpY2nfwgHtXXMtISj9XiARqdwNabG2qKptQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fmDfXqq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fmDfXqq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A13C4CED6;
	Sat, 11 Jan 2025 00:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736555220;
	bh=KNFl3RxXXwuBNnJZ1sLmmZNKfV1R5wxmFVtgs9X+e20=;
	h=Date:To:From:Subject:From;
	b=fmDfXqq4iPQIbmOe+KVS9b7NH9CzBTOPndcHF3tNhJJGg9mfN93QOT20dALEabT7V
	 hBCYL+v9zd1QKb/YeHpvVfi+tO4MsxvutlZefBviMFXDmHcJogAk7CCk5xswjipy2s
	 5sVjNBgk46ua1ySgcB2S3l6VERMYnehDzDZZ5YNA=
Date: Fri, 10 Jan 2025 16:26:59 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kaiyang2@cs.cmu.edu,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20250111002659.E2A13C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix pgdemote_* accounting with lru_gen_enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled.patch

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
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/vmscan: fix pgdemote_* accounting with lru_gen_enabled
Date: Fri, 10 Jan 2025 20:21:33 +0800

Commit f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA
balancing operations") moved the accounting of PGDEMOTE_* statistics to
shrink_inactive_list().  However, shrink_inactive_list() is not called
when lrugen_enabled is true, leading to incorrect demotion statistics
despite actual demotion events occurring.

Add the PGDEMOTE_* accounting in evict_folios(), ensuring that demotion
statistics are correctly updated regardless of the lru_gen_enabled state. 
This fix is crucial for systems that rely on accurate NUMA balancing
metrics for performance tuning and resource management.

Link: https://lkml.kernel.org/r/20250110122133.423481-2-lizhijian@fujitsu.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled
+++ a/mm/vmscan.c
@@ -4649,6 +4649,8 @@ retry:
 	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
 					stat.nr_demoted);
 
+	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
+			   stat.nr_demoted);
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, reclaimed);
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch
mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled.patch
selftests-mm-add-a-few-missing-gitignore-files.patch

