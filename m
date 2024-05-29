Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78757181CE2
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009146; cv=none; b=HHWJNkXG6tZwPdI8JVdnYDTat1gx+X02ZyNsZ+Y2HW9iGxRupI3n4RZnqeRlZAdZNQUfwX2ao5sxStdzUYL1GsBeRzLU0Hcka9aygNHsTLs/Ttyd9B2MV08DYDgypyCbDF239eDe72gK48waYYzUY+75WpB+0fosPeFtmBx6T6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009146; c=relaxed/simple;
	bh=32ErW/eNn26rvy6W3X9IS9qufsJslsMOlzov8dezsQA=;
	h=Date:To:From:Subject:Message-Id; b=M7ajTTskdGtEIkHr8TNVjBpVzAs3WC6arxKg4CbOkrfDccE48OHFu28D30ZutnyKBqlUm8ptE/NHXFJRmmHrTtrhY9/tKL4kWMw5ut1cILP4mk0A2Y8h5rSp/BoiaFuzlvpx+c6qvnKCyTt15LKi1AMupPb5Z3IOHQGAIpp0UKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QUob0mmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QUob0mmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECABFC113CC;
	Wed, 29 May 2024 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009146;
	bh=32ErW/eNn26rvy6W3X9IS9qufsJslsMOlzov8dezsQA=;
	h=Date:To:From:Subject:From;
	b=QUob0mmbijUYj2m+wyQ14CGqMA1StphX+Ly7jYlcpaCf86WiF4ZyGPAUHvM4mlUWH
	 bqx3G9QtmxEsFWLARwoUky8xRaT7X10TmM9Z777nl2U5mte5zR4f15fhqmNABKvK5V
	 1wCRVdPOm6ZUe9v13cgqEWWz+h/u6a1GvkRDYVDo=
Date: Wed, 29 May 2024 11:59:04 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-restore-incremental-cgroup-iteration-fix.patch added to mm-unstable branch
Message-Id: <20240529185905.ECABFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: reset sc->priority on retry
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-restore-incremental-cgroup-iteration-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-restore-incremental-cgroup-iteration-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: vmscan: reset sc->priority on retry
Date: Wed, 29 May 2024 08:49:11 -0700

The commit 6be5e186fd65 ("mm: vmscan: restore incremental cgroup
iteration") added a retry reclaim heuristic to iterate all the cgroups
before returning an unsuccessful reclaim but missed to reset the
sc->priority.  Let's fix it.

Link: https://lkml.kernel.org/r/20240529154911.3008025-1-shakeel.butt@linux.dev
Fixes: 6be5e186fd65 ("mm: vmscan: restore incremental cgroup iteration")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+17416257cb95200cba44@syzkaller.appspotmail.com
Tested-by: syzbot+17416257cb95200cba44@syzkaller.appspotmail.com
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmscan.c~mm-vmscan-restore-incremental-cgroup-iteration-fix
+++ a/mm/vmscan.c
@@ -6304,6 +6304,7 @@ retry:
 	 * meaningful forward progress. Avoid false OOMs in this case.
 	 */
 	if (!sc->memcg_full_walk) {
+		sc->priority = initial_priority;
 		sc->memcg_full_walk = 1;
 		goto retry;
 	}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-vmscan-restore-incremental-cgroup-iteration-fix.patch

