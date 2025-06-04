Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9445B70838
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 03:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008794; cv=none; b=jlelDngvNfsz5dw/u8yILG5e3coVFdCJ66IICCS7MnPL6jQ+X1EPN1nr5rakA58w27xNQ9RkDTqkpxZYssago9aq/fsC3SD4R/btwCfy44eF9C//wMoRMgq+zg8GHGPYwrXia3vQMxo1yH1bCIttiCAFG/RgEe9F4HiJanPit8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008794; c=relaxed/simple;
	bh=VcEl+/KhCK6CtmNYXjXUBd1DenTzbl8D1Zm1gMNoQxw=;
	h=Date:To:From:Subject:Message-Id; b=diCXSknvmJaM5mahmrof9vsxNp7DfH5ALUAu3Xytr9tIgp7TzOseCV7TwBJVEJgiShQllk3WYLRr7eEtSqx16FO1/6pPSEY+ZnVL9/CzYBksBkLzZYTxkS/Y3coe34IbK6Ej7QlLCmMR/cyLk2GbIgRQYEp9gkfL1mRnSCCg9lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pRfhRV18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pRfhRV18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EACC4CEF0;
	Wed,  4 Jun 2025 03:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749008794;
	bh=VcEl+/KhCK6CtmNYXjXUBd1DenTzbl8D1Zm1gMNoQxw=;
	h=Date:To:From:Subject:From;
	b=pRfhRV18M1PW2xW6ie/KTIYRjUZOUszHZ/bMxonYG9WQOBcaiilsGq2bsN+UaWmOZ
	 woLRDSmgVFz/bXOU6RrVqNy89JLtHsdEAHrKFWroOKwMbtRRR1f7FhsHMs0aEQK5oa
	 egl8cEpLXe08OPPFHGeni23uDs8u7oHU+x2IKR04=
Date: Tue, 03 Jun 2025 20:46:32 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-simple_strtol-with-kstrtol.patch added to mm-nonmm-unstable branch
Message-Id: <20250604034633.E6EACC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: replace simple_strtol with kstrtol
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-simple_strtol-with-kstrtol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-simple_strtol-with-kstrtol.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ocfs2-replace-simple_strtol-with-kstrtol.patch

