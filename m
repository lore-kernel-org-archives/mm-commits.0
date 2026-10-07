Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771322931E9
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338712; cv=none; b=JLe+nDlcZDgUmCA20sdcRZUm1bcaZEpBcg8tMrg9kRRuNJaNTvBCbbCP2S7uMljPriGHNG3b8AxsrDoiOx8msttYWpRnd4v+k/6eQ6jBPQaw0BYEuh/PxJ2yKuNY5OvehYyyfs0+KO4kzuhqK0O6DufngC3bFdhE11zkrihut0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338712; c=relaxed/simple;
	bh=V4kzt4OcHfRJquWip7PT/DELFonuRbyRNQzgJxvTw0k=;
	h=Date:To:From:Subject:Message-Id; b=ERPcD9kozLI8JRYYbW8eY7y9f51VOO0recMdD8Y4xoxQIvg+UX/y2GO3W9F+EUUx5urKy+9//vrsivoluVUmKzJvTzTd6Zq3L95MzVheVfZrIAtNzDQ4i3i64kM5yfgO3xOwvZLByh5mcTLM5jFIWmr6Rsf5JyZWxOHjeA/rVxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2b41bmR3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2b41bmR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9301F0089C;
	Wed,  7 Oct 2026 02:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338711;
	bh=rjtyLq2e/e2Gl8UYbEWwVypozEPClMnTF8xFKKllftE=;
	h=Date:To:From:Subject;
	b=2b41bmR3kElG1HzFsU10J1on34T9/+yoKaeeNgmnoEPKWK3mpA5viznYZUFpaAdQN
	 gfo1v1XY0ftBQG18mbex4tf8LhvJ7NSBo08Q8zFgVccDo2x5rRzLlS8LEyauo55pVy
	 7Y4SKIDOtCylj8tE5GYFioPqNpG8Yt9Chp9t5Bu0=
Date: Tue, 06 Oct 2026 19:05:10 -0700
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-drop-the-unused-cpu_dont_care-enum-member.patch removed from -mm tree
Message-Id: <20261007020511.4C9301F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: drop the unused CPU_DONT_CARE enum member
has been removed from the -mm tree.  Its filename was
     taskstats-drop-the-unused-cpu_dont_care-enum-member.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
Subject: taskstats: drop the unused CPU_DONT_CARE enum member
Date: Tue, 15 Sep 2026 18:06:23 +0000

CPU_DONT_CARE was added by the original listener cpumask code in 2006
(f9fd8914c1ac) and has never had a single user, not even in the
commit that introduced it. It survived every refactor of the listener
path since, including the recent handler folds.

Kill it, twenty years is enough.

Link: https://lore.kernel.org/20260915180623.22058-1-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
---

 kernel/taskstats.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/taskstats.c~taskstats-drop-the-unused-cpu_dont_care-enum-member
+++ a/kernel/taskstats.c
@@ -59,8 +59,7 @@ static DEFINE_PER_CPU(struct listener_li
 
 enum actions {
 	REGISTER,
-	DEREGISTER,
-	CPU_DONT_CARE
+	DEREGISTER
 };
 
 static int prepare_reply(struct genl_info *info, u8 cmd, struct sk_buff **skbp,
_

Patches currently in -mm which might be from brads@mainlining.org are

watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

