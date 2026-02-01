Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BE43EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905039; cv=none; b=s+MzbT8mMuGlrR8SNlb6LcMZl19lz5NrzJ3aMpzjqLNtmddIxyYLvslKKvoM67OBhVOaxz0joES1pg62rUv4YsQ2Omj/awH38caPz2ihwhaeclT9Xp66PANiOnQow55Kmw5HzANwbXyo7YlHMP4700/wHj6WkjHhJ8GZ9AFbAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905039; c=relaxed/simple;
	bh=ucO4cysqPwTmx6xYIxSYS97Tl4xOFBH5lbsL4374Z6A=;
	h=Date:To:From:Subject:Message-Id; b=noGMIj4Y5c8X2gwDtXdeI+6VIJds+TkE46S7Ff3PoXa1PEPaF40updjh/7rD181LBvmhAIvpjDuOGFdUPT5UnTSxbg74A3D000d4OFEdda9G4a5O7m8pwrCSZ3MrQ9xMZwb708lhxmHi1od4c3RuRt1pyg2TTEuHPr7qhymI9Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1dM2EzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1dM2EzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40198C4CEF1;
	Sun,  1 Feb 2026 00:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905039;
	bh=ucO4cysqPwTmx6xYIxSYS97Tl4xOFBH5lbsL4374Z6A=;
	h=Date:To:From:Subject:From;
	b=I1dM2EzAumnTzKGvVF1hbYm2UdR0EW2XlNCYhn584n4IGhtiAsb1gg7WFnhzpR4X5
	 njnqReZ1YX56i6PBu0Y1dZAz97RI8XVrn1FyH7ADQJYqGPdyQXE21dwbyNDQCvOC6Z
	 dYd+bVTdYx2Mn6d3rDPd2ZBdVz11PSuJ/Pyp0q2I=
Date: Sat, 31 Jan 2026 16:17:18 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] netclassid-use-thread_group_leaderp-in-update_classid_task.patch removed from -mm tree
Message-Id: <20260201001719.40198C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: netclassid: use thread_group_leader(p) in update_classid_task()
has been removed from the -mm tree.  Its filename was
     netclassid-use-thread_group_leaderp-in-update_classid_task.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: netclassid: use thread_group_leader(p) in update_classid_task()
Date: Sun, 25 Jan 2026 17:08:00 +0100

Cleanup and preparation to simplify planned future changes.

Link: https://lkml.kernel.org/r/aXY_4NSP094-Cf-2@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netclassid_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/netclassid_cgroup.c~netclassid-use-thread_group_leaderp-in-update_classid_task
+++ a/net/core/netclassid_cgroup.c
@@ -93,7 +93,7 @@ static void update_classid_task(struct t
 	/* Only update the leader task, when many threads in this task,
 	 * so it can avoid the useless traversal.
 	 */
-	if (p != p->group_leader)
+	if (!thread_group_leader(p))
 		return;
 
 	do {
_

Patches currently in -mm which might be from oleg@redhat.com are


