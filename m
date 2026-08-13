Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E8036A03F
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660963; cv=none; b=NEn5GLsoEqi8zkYrhfCVLArklKxDM9yEshfnK8aHHi6q3lCnhK2l8XJL3olVgAerYokwj95ySv3xy3XjVdwbXOGGLv6+pc6qNzVSBgQIweDQ+uuu7edyyv20rxUN1H0Stf0UTFzeXCdfDzDRPx+15D2Zqyb0X4FDa5pd/z0J8Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660963; c=relaxed/simple;
	bh=7zJw7e4xhTYDDBCikNCmyWGb5c//JLPLCPg5VfeMQu8=;
	h=Date:To:From:Subject:Message-Id; b=YpvdLI6kpPGHxkSWtlMLU2Zf91wjyJ6tVpJOuzgium16sr7M/WByeN08eW3FjkLzEqye8oc/40s2j03TaYQrbYMTXKQYc613ke3bmkoQ6vvCViP/tgOcleff+o8159lwWIAelMmjVQCtfozG7BKBFVApPgVoiKZ9m94TmF0HXpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khILQNxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khILQNxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901BD1F000E9;
	Thu, 13 Aug 2026 22:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660961;
	bh=Dotv6Vd24ZKX0VnadjquSO0OZq9U5DvoHrgiOTs+W7I=;
	h=Date:To:From:Subject;
	b=khILQNxDM+fMuOi4aRdYJHuY9/tHPO/rFcVx9TYLH+/jfd2AC/FFKC+rW4ILWsQDR
	 CKB29421UDH05dEu1AgbkiqOnJQC94jEGQ2dPg4V9SdWqmCzM+GYAI2hUZZnG1avQs
	 UN47ibyz7eWIgnbo3kBOaFE+WicpFwPX57yhBxEY=
Date: Thu, 13 Aug 2026 15:42:41 -0700
To: mm-commits@vger.kernel.org,bsingharora@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-drop-the-dead-null-attribute-check-in-parse.patch removed from -mm tree
Message-Id: <20260813224241.901BD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: drop the dead NULL attribute check in parse()
has been removed from the -mm tree.  Its filename was
     taskstats-drop-the-dead-null-attribute-check-in-parse.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: taskstats: drop the dead NULL attribute check in parse()
Date: Tue, 28 Jul 2026 20:21:03 +0000

Patch series "taskstats: tidy up the cpumask command path".

Two small cleanups from reading kernel/taskstats.c. No functional change in
either one.


This patch (of 2):

taskstats_user_cmd() only calls the cpumask handlers after checking the
same info->attrs[] entry, so parse() never sees a NULL attribute.  Drop
the check and its odd "return 1", which no caller tested for anyway.

No functional change.

Link: https://lore.kernel.org/20260728202104.17839-1-include@grrlz.net
Link: https://lore.kernel.org/20260728202104.17839-2-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/taskstats.c~taskstats-drop-the-dead-null-attribute-check-in-parse
+++ a/kernel/taskstats.c
@@ -361,8 +361,6 @@ static int parse(struct nlattr *na, stru
 	int len;
 	int ret;
 
-	if (na == NULL)
-		return 1;
 	len = nla_len(na);
 	if (len > TASKSTATS_CPUMASK_MAXLEN)
 		return -E2BIG;
_

Patches currently in -mm which might be from include@grrlz.net are

prctl-fix-pr_set_mm_auxv-losing-the-forced-at_null-terminator.patch
taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch

