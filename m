Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793562271;
	b=VKn5/XP6ZZojTYKJ3HRbY3lqd0iF9nYYiBqFV/48tYzhkJFjW6MbI4Uw5Ij20tyHcKaS
	 uju46siASQ2ZKMYOa1bHZEhwaaXJWS/Leu3tGaqcA14qaQVaro6ImrA9z+l1HoMsVdqcY
	 oe8tx5ia6dlJJAgmPfQIBZeo2DbsY/Ly1RoTeaxR1iXe6uXFXbt85YLpMwEhbO8W6YMId
	 mmGnUDttrVPRn/s+XAvlf9cqqSJ111Wy3bUXWywbPJzZPlPtBPmtfDtzbtNjrF1bOjIVV
	 54LfGhK+KdQ2Yk/zM2G7QWzO5iMyK2g6VbolqgkXNwuWvrZuBDALeJiynNaCuwuVVHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562271;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8Kb5JLrtHDTpZYf2ftVjFCI6qDRkBVzEq0JQuPifgdk=;
	b=qy8TwortXTd0sIhp8cn9hcC8/RPHGRODbo1ycAut9JD4CIQFqNrqxzapPOEZeJ2lgftz
	 wMo0hTHFyxQeaFyq9eWcdFoWAHa5S3/5Q241nxEunZq/qmYpsp4x0XfWhaRXToyh6qzig
	 MD2IJkQvttwKkSLgEH7x7gFNJfbCr9YyI5DviHD2reqszsN+6nIao90mhl890hYxMcUGK
	 480gWsPOpHWy5X+vH7UBvoC8mIepyMUFt3ho2zlxJcBbN4QwOJKX29XqtjmqDTO9bziOS
	 T9KH0M+AbeAmZPtx92fYtq9UdCXw1hRRV1Rs9J6xt6dackkBCSkTSK8ON/K2qqmX/Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w8sv8gEW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41F1606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 19:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w8sv8gEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D281F000C1;
	Sun,  1 Nov 2026 19:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793562270;
	bh=8Kb5JLrtHDTpZYf2ftVjFCI6qDRkBVzEq0JQuPifgdk=;
	h=Date:To:From:Subject;
	b=w8sv8gEWnuMffIEDbiLw8LgpYlS5tU31BO5o8TmyApohcey1SDxW+z5GcMiDxxHny
	 xI696zCcmP9sqpRJw4tQgW/a6o7B0Mm2MiWCDJiA9Q5vzIgReq8gKhJgYRXhxYonhH
	 FMAWUKtS9F01fQW325fWczuNH10iZr7haBadcNEs=
Date: Sun, 01 Nov 2026 11:44:29 -0800
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,brads@mainlining.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-use-nla_put_u32-in-mk_reply.patch added to mm-nonmm-unstable branch
Message-Id: <20261101194430.83D281F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: taskstats: use nla_put_u32() in mk_reply()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-use-nla_put_u32-in-mk_reply.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-use-nla_put_u32-in-mk_reply.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Bradley Morgan <brads@mainlining.org>
Subject: taskstats: use nla_put_u32() in mk_reply()
Date: Sun, 01 Nov 2026 00:57:40 +0000

Patch series "taskstats: four more tidy-ups in the genl path".

Four small cleanups from reading kernel/taskstats.c again.  No functional


This patch (of 4):

mk_reply() open codes a u32 attribute, nla_put() with sizeof(pid) and
&pid fed to it by hand.  nla_put_u32() is those same three arguments
already collapsed, and it is what the readers of this attribute use.
The helper returns 0 or a negative error, so the bare if() catches
exactly what the < 0 comparison caught.

No functional change.

Link: https://lore.kernel.org/20261101005616.3022705-1-brads@mainlining.org
Link: https://lore.kernel.org/20261101005743.3022780-1-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/taskstats.c~taskstats-use-nla_put_u32-in-mk_reply
+++ a/kernel/taskstats.c
@@ -386,7 +386,7 @@ static struct taskstats *mk_reply(struct
 	if (!na)
 		goto err;
 
-	if (nla_put(skb, type, sizeof(pid), &pid) < 0) {
+	if (nla_put_u32(skb, type, pid)) {
 		nla_nest_cancel(skb, na);
 		goto err;
 	}
_

Patches currently in -mm which might be from brads@mainlining.org are

taskstats-use-nla_put_u32-in-mk_reply.patch
taskstats-take-the-inode-once-in-exe_add_tsk.patch
taskstats-reuse-na-in-cgroupstats_user_cmd.patch
taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task.patch

