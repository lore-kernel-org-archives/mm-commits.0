Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8D02147E5
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 00:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785283207; cv=none; b=HuE+H7K68HeIRmmrbuiE4Tedmwib5nkT7ODIV7cPUY0hP1HXoEmB2VzscHRTrt3CLPMR2Y/+7MMxhcCHZmJ/w7uScO5uT8zDaxmPA96SYMiOnwVzcchlhCLEDRMdm4f6dKcj7h8yijQz4uHpjyGQXlVgayOcwOA/tXvIPe/PvG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785283207; c=relaxed/simple;
	bh=sKclTHggkiTkvrU5+Fm4GKEtUELLmQsZK+j2lY63pTU=;
	h=Date:To:From:Subject:Message-Id; b=ESURZzKrLNJHaW2DWmiheNTsJ9IVJTbfucxBgVoU1dnvontgR0XIYb36J/kj8WSmpjoKfq99UyPdpkfYVchvSuI5WelUCkStp1dvAaTBVhSCpWibdaNvuac+rObzsypmgZp599e6d2bMOLSJQ5pBJUlSo8wnJwfakl6YL/AuDMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M5tbr+Ed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M5tbr+Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDBB1F00A3A;
	Wed, 29 Jul 2026 00:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785283205;
	bh=F480/YKtG73B0qL6UpyzD/WdnDzrG1kRiuVKP+CI7e0=;
	h=Date:To:From:Subject;
	b=M5tbr+EdpGInshhtU8Y9h85WiTz6LazDCDSixpZQt66yeCMniA1cv52uh92BIJZXt
	 bIen2ReN6bdQYJApxHqvpiYYGhqSNGLiTKJn3Sdu70gjz8Yhq2PKA1tzbQY23rItWb
	 cPwSuhgBOGQ6rVJfKTS89VyeP1PcY/cL4jMv6G1o=
Date: Tue, 28 Jul 2026 17:00:04 -0700
To: mm-commits@vger.kernel.org,bsingharora@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-fold-the-two-cpumask-handlers-into-one.patch added to mm-nonmm-unstable branch
Message-Id: <20260729000005.1FDBB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: fold the two cpumask handlers into one
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-fold-the-two-cpumask-handlers-into-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-fold-the-two-cpumask-handlers-into-one.patch

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
From: Bradley Morgan <include@grrlz.net>
Subject: taskstats: fold the two cpumask handlers into one
Date: Tue, 28 Jul 2026 20:21:04 +0000

cmd_attr_register_cpumask() and cmd_attr_deregister_cpumask() differed
only in which attribute they parsed and which action they passed on, so
take both as arguments.  __free(free_cpumask_var) then removes the goto.

No functional change.

Link: https://lore.kernel.org/20260728202104.17839-3-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

--- a/kernel/taskstats.c~taskstats-fold-the-two-cpumask-handlers-into-one
+++ a/kernel/taskstats.c
@@ -448,36 +448,18 @@ static int cgroupstats_user_cmd(struct s
 	return send_reply(rep_skb, info);
 }
 
-static int cmd_attr_register_cpumask(struct genl_info *info)
+static int cmd_attr_cpumask(struct genl_info *info, int attr,
+			    enum actions action)
 {
-	cpumask_var_t mask;
+	cpumask_var_t mask __free(free_cpumask_var) = CPUMASK_VAR_NULL;
 	int rc;
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
-	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
+	rc = parse(info->attrs[attr], mask);
 	if (rc < 0)
-		goto out;
-	rc = add_del_listener(info->snd_portid, mask, REGISTER);
-out:
-	free_cpumask_var(mask);
-	return rc;
-}
-
-static int cmd_attr_deregister_cpumask(struct genl_info *info)
-{
-	cpumask_var_t mask;
-	int rc;
-
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
-		return -ENOMEM;
-	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], mask);
-	if (rc < 0)
-		goto out;
-	rc = add_del_listener(info->snd_portid, mask, DEREGISTER);
-out:
-	free_cpumask_var(mask);
-	return rc;
+		return rc;
+	return add_del_listener(info->snd_portid, mask, action);
 }
 
 static size_t taskstats_packet_size(void)
@@ -552,9 +534,13 @@ err:
 static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 {
 	if (info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK])
-		return cmd_attr_register_cpumask(info);
+		return cmd_attr_cpumask(info,
+					TASKSTATS_CMD_ATTR_REGISTER_CPUMASK,
+					REGISTER);
 	else if (info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK])
-		return cmd_attr_deregister_cpumask(info);
+		return cmd_attr_cpumask(info,
+					TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK,
+					DEREGISTER);
 	else if (info->attrs[TASKSTATS_CMD_ATTR_PID])
 		return cmd_attr_pid(info);
 	else if (info->attrs[TASKSTATS_CMD_ATTR_TGID])
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
taskstats-fix-cpumask-parsing-cutting-off-the-last-character.patch
taskstats-drop-the-dead-null-attribute-check-in-parse.patch
taskstats-fold-the-two-cpumask-handlers-into-one.patch

