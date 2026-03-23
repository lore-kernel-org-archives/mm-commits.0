Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954A536BCF4
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 20:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774296286; cv=none; b=aXH9PoEfKCg6IvF3G2rm7OMxz2z/x5W6Daz+V5Swfv1VHGGmyIkzRiLL8YONtgRFYXARZw41pQDdtcXJW4YJranygWHNTV48M+L3b1z5KzVyh2B4riSY2cEL+VCgS+0SMK44bLTQ1fbpGgKWg0E7lg5DZ+1NNEtY4E+74xmZxoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774296286; c=relaxed/simple;
	bh=brGAppnKhoewL/5DnXL6StA6YH2P+Nk6dgkLzgOStJk=;
	h=Date:To:From:Subject:Message-Id; b=CxufWxq5/ratvdKrt2dP7aWOoAjuw7RaoRYuKyUoQ9nuNXqNIOKwF2oV5q7bQfww51wWMdYE/x4hYo2Kw+DOS41nTw/EvDGTeD5dGYytYc5qZ4gniFTRJ1h2+4WqzpBMjzlvzf23jR1SO1MmRtREkIjqDHFML5XARPnpNrf/B18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R4ndUc3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R4ndUc3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130CCC4CEF7;
	Mon, 23 Mar 2026 20:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774296286;
	bh=brGAppnKhoewL/5DnXL6StA6YH2P+Nk6dgkLzgOStJk=;
	h=Date:To:From:Subject:From;
	b=R4ndUc3QI+W7pFfYtkvojaX03I2j0Kb7bxVIANzWleRdoReUo9GaWbEk8vVyXbNRP
	 kSp+enr8oNU2PpgLUju9VgBbwzHZOaimutJZ5akeYQ59PvWrDOnlvraXCAXRvJYGCb
	 ckAH9IQHiLvU8n6F6wW2RS7hZ8M/MNvDkXEv/uXo=
Date: Mon, 23 Mar 2026 13:04:45 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch added to mm-unstable branch
Message-Id: <20260323200446.130CCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: David Carlier <devnexen@gmail.com>
Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
Date: Mon, 23 Mar 2026 06:30:06 +0000

add newline, per Qi Zheng

Link: https://lkml.kernel.org/r/20260323063007.7783-1-devnexen@gmail.com
Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
+++ a/mm/memcontrol.c
@@ -4058,6 +4058,7 @@ free_objcg:
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
+
 		if (objcg)
 			percpu_ref_kill(&objcg->refcnt);
 
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch

