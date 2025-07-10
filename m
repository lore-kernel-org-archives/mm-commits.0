Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEE817741
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127145; cv=none; b=WncJAQFMAnze3/zmEDzmNJl1UMue6t7S5ZmQ1fhs8efiMwqHZGlQcBXlsyiQBe1HB5+mueGSdXytFRv1oAlycZJc/dmilJoJttLDqzf4aBKKxpP67wvj0ZvjUKyUXBwxlV2HEbgHZTRYwpgknCILeDnJn4XoSG13DeW8ln4dI1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127145; c=relaxed/simple;
	bh=ste1bc7RILOtOYueXRxoxNUWYOOs09dSl43C4t3h8KQ=;
	h=Date:To:From:Subject:Message-Id; b=jXe3Mt2aHwSYk0uTixGn/ehvteC2CmyHYQlaZXXweHGTlou2uyNmnxqDK1YoUy7Cn7ALPH0OulTn/CSVI2iE/tkFK7Z4wNhNCzPOmF5uug0a/Vnjs3FR2wZGcYUCFDjKHUxrJQ787hfSpZCKrz8zzo4jiKnw8VzkqpYA+vHe/BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fR/hoheC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fR/hoheC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FB9C4CEE3;
	Thu, 10 Jul 2025 05:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127145;
	bh=ste1bc7RILOtOYueXRxoxNUWYOOs09dSl43C4t3h8KQ=;
	h=Date:To:From:Subject:From;
	b=fR/hoheCRF7HrHW31LeuGo6M0bw0NnF2kv9w8UPKQ5WhVHPcXE1Y9yaG2NEBtiSCx
	 dZr0JBGB46KEcO4eY2YWkVeuNth0YFPFXbkYsxJDRk61sHvXYxtyh214Vyb9jWrl8Y
	 WqAs0kmo03nug3wAASf/2YH9cvkjUfd0Dlt2+MEs=
Date: Wed, 09 Jul 2025 22:59:04 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-replace-simple_strtol-with-kstrtol.patch removed from -mm tree
Message-Id: <20250710055905.59FB9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: replace simple_strtol with kstrtol
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-simple_strtol-with-kstrtol.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Hui <suhui@nfschina.com>
Subject: ocfs2: replace simple_strtol with kstrtol
Date: Tue, 27 May 2025 17:23:34 +0800

kstrtol() is better because simple_strtol() ignores overflow.  And using
kstrtol() is more concise.

Link: https://lkml.kernel.org/r/20250527092333.1917391-1-suhui@nfschina.com
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/stack_user.c~ocfs2-replace-simple_strtol-with-kstrtol
+++ a/fs/ocfs2/stack_user.c
@@ -360,7 +360,6 @@ static int ocfs2_control_do_setnode_msg(
 					struct ocfs2_control_message_setn *msg)
 {
 	long nodenum;
-	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
 
 	if (ocfs2_control_get_handshake_state(file) !=
@@ -375,8 +374,7 @@ static int ocfs2_control_do_setnode_msg(
 		return -EINVAL;
 	msg->space = msg->newline = '\0';
 
-	nodenum = simple_strtol(msg->nodestr, &ptr, 16);
-	if (!ptr || *ptr)
+	if (kstrtol(msg->nodestr, 16, &nodenum))
 		return -EINVAL;
 
 	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||
@@ -391,7 +389,6 @@ static int ocfs2_control_do_setversion_m
 					   struct ocfs2_control_message_setv *msg)
 {
 	long major, minor;
-	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
 	struct ocfs2_protocol_version *max =
 		&ocfs2_user_plugin.sp_max_proto;
@@ -409,11 +406,9 @@ static int ocfs2_control_do_setversion_m
 		return -EINVAL;
 	msg->space1 = msg->space2 = msg->newline = '\0';
 
-	major = simple_strtol(msg->major, &ptr, 16);
-	if (!ptr || *ptr)
+	if (kstrtol(msg->major, 16, &major))
 		return -EINVAL;
-	minor = simple_strtol(msg->minor, &ptr, 16);
-	if (!ptr || *ptr)
+	if (kstrtol(msg->minor, 16, &minor))
 		return -EINVAL;
 
 	/*
@@ -441,7 +436,6 @@ static int ocfs2_control_do_down_msg(str
 				     struct ocfs2_control_message_down *msg)
 {
 	long nodenum;
-	char *p = NULL;
 
 	if (ocfs2_control_get_handshake_state(file) !=
 	    OCFS2_CONTROL_HANDSHAKE_VALID)
@@ -456,8 +450,7 @@ static int ocfs2_control_do_down_msg(str
 		return -EINVAL;
 	msg->space1 = msg->space2 = msg->newline = '\0';
 
-	nodenum = simple_strtol(msg->nodestr, &p, 16);
-	if (!p || *p)
+	if (kstrtol(msg->nodestr, 16, &nodenum))
 		return -EINVAL;
 
 	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||
_

Patches currently in -mm which might be from suhui@nfschina.com are


