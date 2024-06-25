Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CB24596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291535; cv=none; b=LUx87mhMAUxgI/1zOXHFSJ4korbRk5EQooQExUHG7z1cMPWc7eAJLbaahk9DXgDvKdScuLDc0yT/nxJ2VpJ4Y5d9+9jgocBCMQ1uuuWZvQYH/1WAj2KcCEwzb33yfYorcxodDWvZXFZchmc5LHtl2iDR5cnLfvcIr/h67Zllo5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291535; c=relaxed/simple;
	bh=lFKEhkyEzgugDdIENmV3m50DTeSct1Q7OJnokXvMiOU=;
	h=Date:To:From:Subject:Message-Id; b=YjI/iFoRd7qUrWtlp6kBynXPj9jThyjqbQkPxKIXX9y9o7j6922931G7BmpJs5fBOs29BXEF4ZtJGDL+OIWfkE3Ogj8QVbUmSJWGyQSchm2AWZMTsQOe5wSE1dkUAVvuYqk/w6gft6/OYh9zWMaxC3vE0Ut1PLnqhxqrb82lI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gn9r2kXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gn9r2kXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C67C32782;
	Tue, 25 Jun 2024 04:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291535;
	bh=lFKEhkyEzgugDdIENmV3m50DTeSct1Q7OJnokXvMiOU=;
	h=Date:To:From:Subject:From;
	b=gn9r2kXgSq/VCD/82cO+Um4rpdN7JHmhNBOb8x/HCELxATApLnUNmK/AMR09h9wI/
	 WyErjfaslQ0XLpYZw/b/Mr3FbVTEbYGlYa/xtEUGquxAEHPGusTHQUbQ9lf5oPRsRY
	 hkCJS6LhCCnSIaCcIwLTzUJidABl4+k1BKCR6VzI=
Date: Mon, 24 Jun 2024 21:58:54 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-restore-incremental-cgroup-iteration-fix.patch removed from -mm tree
Message-Id: <20240625045855.43C67C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: reset sc->priority on retry
has been removed from the -mm tree.  Its filename was
     mm-vmscan-restore-incremental-cgroup-iteration-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


