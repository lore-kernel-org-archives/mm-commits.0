Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C263F6C30
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660964; cv=none; b=sFEOEn880MIWSnALuA0jikW/mk8nCuC6E8BpfTGkUNCliBChjys0EaIofAwcHIsiNySPIrYpH8E0vqbha2Bw9I423DL0cwn2QW48VjcA6A0t4DYkcfrS/+AwBGtjOvDtkU/3rActQGM2UxJunK4E4XJPLSVLRNBOChPF09OR4aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660964; c=relaxed/simple;
	bh=fygWmoDaQRvIoh4PMeEdIuMbLFMnsf7eGL+UL/I3vtk=;
	h=Date:To:From:Subject:Message-Id; b=N+frpmh74BcXckNu/P90xd1W8Zd5Rg4mnnzazYXHLZxP7YNL0dRcnwBXzB/P8s54DRLM4j+HXWQzyOifmrQQf0CYC3Hv6g3QZxpt6lLq0QvhQypc7DVGVCozwRkNoB88ow5MmgtcU4sUaPdgM3CgZqHl48pvrORac822G9CnkM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tMJApXbc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tMJApXbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66C21F00A3A;
	Thu, 13 Aug 2026 22:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660962;
	bh=tH0LA+7LiLM/1pPP6AsSikWaMeylMR8gK1bGxrGxqHw=;
	h=Date:To:From:Subject;
	b=tMJApXbcSCmYSG7HkQl/szbUAdtytzNp6Qr7n5rBpwgyWcQp597LqZ4u/TH21hFyS
	 VtKIRTLT4YFUCE1xBiif7X7qutomF+0ZHlozch9mtxjmxAqpoVP5ZL/9xKGRWSZBOp
	 pvL35HKU+aJtJUFASpu8zNszWTnauSxMkYB2Eb0I=
Date: Thu, 13 Aug 2026 15:42:42 -0700
To: mm-commits@vger.kernel.org,bsingharora@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-fold-the-two-cpumask-handlers-into-one.patch removed from -mm tree
Message-Id: <20260813224242.B66C21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: fold the two cpumask handlers into one
has been removed from the -mm tree.  Its filename was
     taskstats-fold-the-two-cpumask-handlers-into-one.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

prctl-fix-pr_set_mm_auxv-losing-the-forced-at_null-terminator.patch
taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch

