Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7C5377A84
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 04:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788238164; cv=none; b=F/Wvu9mtI38mnDe74tQXpHpI/ryK5QStQrR/2RFK6Q7X9b6hjvfhiIavzcgzZZmnxNFeOAx6CTC4bzcTwY6+zIz9tRHDVWngXrKJQw9HUFZj57FZTurIlAYCg3lcn6RWAC7httWM9d4dw7KEN4eJVnZif5a4/QPZ6ZyuyvJQOhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788238164; c=relaxed/simple;
	bh=ccz8ePhKO/GHlzX3gtFTAFXxZUwIrvdgzkNHB/6Yw3M=;
	h=Date:To:From:Subject:Message-Id; b=mnLfoYLhpOiYMNv1zOahePafd6J/OWuaEm3sWA9/oFvLaBdbn74RnZNgvsYZGGYVC9icvaYLCe/czlf9TB1iRlD/GutJcBNkZk5YXq24RRCA5RdqtvZAU9kKzMaGLAOVBZu2WnDAvBlrNa32gu8AvzuoMVoCFA8geSGOmTVKfvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mH4Y2yBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mH4Y2yBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA941F000E9;
	Tue,  1 Sep 2026 04:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788238162;
	bh=pKk3fmFAiVQdup/yJsug98fgQQsJA9yugZXsoubos6c=;
	h=Date:To:From:Subject;
	b=mH4Y2yBdsZZWaFWNiCxTVNdtoczyHRnsDcjl+CAZ9nwxtVpIc6aw+0DmjhDapasan
	 bB2WybTRDItKY7IFtBMk0rSA06zxpGkApxpBKjB5NjoArxe843U4PLmf6gz4oB8j2K
	 Unk3P/h64l4VIiOeNycUemjdJ1lXPb5QV2DIDhz4=
Date: Mon, 31 Aug 2026 21:49:22 -0700
To: mm-commits@vger.kernel.org,bsingharora@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-fold-the-two-pid-tgid-handlers-into-one.patch added to mm-nonmm-unstable branch
Message-Id: <20260901044922.ACA941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: fold the two pid/tgid handlers into one
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-fold-the-two-pid-tgid-handlers-into-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-fold-the-two-pid-tgid-handlers-into-one.patch

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
Subject: taskstats: fold the two pid/tgid handlers into one
Date: Sat, 1 Aug 2026 22:58:44 +0000

cmd_attr_pid() and cmd_attr_tgid() are copy paste.  fold them into one
handler that takes the attr type and fill function as parameters, same
pattern as the cpumask fold in 59c0bc949c5e.

No functional change.

Link: https://lore.kernel.org/20260801225845.23855-1-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

taskstats-fold-the-two-pid-tgid-handlers-into-one.patch

