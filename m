Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D3833122D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338679; cv=none; b=alrZ7f83f/uyQQOm1jlK7fG23nHO96D40FHlE8XuvttUDzvdquJ4yvn3/bd9J1nagx+Cd6qHikiplx52u7SdMMvHSoKQDMZ1uVve4b/tQNYrYowZovFo1EV3GrJKBlRIenxg3Q3DyMda5N63xFIFlQIl55JC2FAuu5hobHpvCTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338679; c=relaxed/simple;
	bh=7M4JGVBklQuP8mC9l1OPlOzUAYnyt92rqtvV6SvO0Bs=;
	h=Date:To:From:Subject:Message-Id; b=niMF+0hNXhh+bVTjh+gOKJS4boU4+mw7bWvb3PhsXbzSsiWv5rAU/N8GZnvKBMbHgvaLbhc4cfdYePp9c3VZf+yuSKOnwNeQCnMxeKhaEoaNcCCD2/pjHXS3CBuIHSRgV0NJnzNo7mHEocWknVddHBO4FngUBn047IJQdca5uNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mpoa43NE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mpoa43NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B08D1F0089B;
	Wed,  7 Oct 2026 02:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338677;
	bh=2ttoKxWXcYg2YY0V+FVAIw+kRIB6djsqc6WToLgYstc=;
	h=Date:To:From:Subject;
	b=mpoa43NEaoushpceNXAyVwoQ7RMBvp9HgEHVN5lFq99aDz7ki04OjpOq+4IfhPjwN
	 QRBSByzX40qK4/06UIziwvf+fxnDLxkzr52v7u6+S+uX9C9XmnkJ3DND+PV7BR9CK7
	 nTniBOsf5tXgu2OQjB36T48Zp5oKhVglqooe49ro=
Date: Tue, 06 Oct 2026 19:04:37 -0700
To: mm-commits@vger.kernel.org,bsingharora@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org,include@grrlz.net
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-fold-the-two-pid-tgid-handlers-into-one.patch removed from -mm tree
Message-Id: <20261007020437.9B08D1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: fold the two pid/tgid handlers into one
has been removed from the -mm tree.  Its filename was
     taskstats-fold-the-two-pid-tgid-handlers-into-one.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: taskstats: fold the two pid/tgid handlers into one
Date: Sat, 1 Aug 2026 22:58:44 +0000

cmd_attr_pid() and cmd_attr_tgid() are copy paste.  fold them into one
handler that takes the attr type and fill function as parameters, same
pattern as the cpumask fold in 59c0bc949c5e.

No functional change.

Link: https://lore.kernel.org/20260801225845.23855-1-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
---

 kernel/taskstats.c |   47 ++++++++++---------------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

--- a/kernel/taskstats.c~taskstats-fold-the-two-pid-tgid-handlers-into-one
+++ a/kernel/taskstats.c
@@ -473,7 +473,8 @@ static size_t taskstats_packet_size(void
 	return size;
 }
 
-static int cmd_attr_pid(struct genl_info *info)
+static int cmd_attr_pid_tgid(struct genl_info *info, int attr,
+			     int (*fill)(pid_t, struct taskstats *))
 {
 	struct taskstats *stats;
 	struct sk_buff *rep_skb;
@@ -488,41 +489,15 @@ static int cmd_attr_pid(struct genl_info
 		return rc;
 
 	rc = -EINVAL;
-	pid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_PID]);
-	stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid);
+	pid = nla_get_u32(info->attrs[attr]);
+	stats = mk_reply(rep_skb,
+			 attr == TASKSTATS_CMD_ATTR_PID
+				? TASKSTATS_TYPE_PID : TASKSTATS_TYPE_TGID,
+			 pid);
 	if (!stats)
 		goto err;
 
-	rc = fill_stats_for_pid(pid, stats);
-	if (rc < 0)
-		goto err;
-	return send_reply(rep_skb, info);
-err:
-	nlmsg_free(rep_skb);
-	return rc;
-}
-
-static int cmd_attr_tgid(struct genl_info *info)
-{
-	struct taskstats *stats;
-	struct sk_buff *rep_skb;
-	size_t size;
-	u32 tgid;
-	int rc;
-
-	size = taskstats_packet_size();
-
-	rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, size);
-	if (rc < 0)
-		return rc;
-
-	rc = -EINVAL;
-	tgid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_TGID]);
-	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid);
-	if (!stats)
-		goto err;
-
-	rc = fill_stats_for_tgid(tgid, stats);
+	rc = fill(pid, stats);
 	if (rc < 0)
 		goto err;
 	return send_reply(rep_skb, info);
@@ -542,9 +517,11 @@ static int taskstats_user_cmd(struct sk_
 					TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK,
 					DEREGISTER);
 	else if (info->attrs[TASKSTATS_CMD_ATTR_PID])
-		return cmd_attr_pid(info);
+		return cmd_attr_pid_tgid(info, TASKSTATS_CMD_ATTR_PID,
+					 fill_stats_for_pid);
 	else if (info->attrs[TASKSTATS_CMD_ATTR_TGID])
-		return cmd_attr_tgid(info);
+		return cmd_attr_pid_tgid(info, TASKSTATS_CMD_ATTR_TGID,
+					 fill_stats_for_tgid);
 	else
 		return -EINVAL;
 }
_

Patches currently in -mm which might be from include@grrlz.net are


