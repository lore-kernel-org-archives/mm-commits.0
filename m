Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793562273;
	b=M9VNwic4hhQsT/trR5C4tUOZ+eJvRqnH7bAXq4U9XQBdNxdQLBFlIKyfABGtSrRrNAVZ
	 jcY91RU0NKudZrbMMfuQl0VBLnbT5OVyRiqx8phRAqK+dQ0GHpV0/5I8wjVf07BN2JMyJ
	 oei/qdL3hHNXUMLiR69NLMHBPBhFUmOatnB2bfzsl1Wk5nj30YTcy4ThwHqefO2qlVjyY
	 OWOZwPq5PRLT3/3R41GM0ziegSOWMsxi/2UWAEigVT6kGNjnmPeT9F8pdlwhG0vJrrk2d
	 dOjSsy+8i4U0tSclhwDdzgWnkR28XTbAXBvXNGc+0hiXqnLQ3imrac0qfEwY8j2lZ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562273;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jbUZOtL+bnqi0wsW78gKfbZAxL9DT+qPzhxoGSOrgeA=;
	b=QJAY5edpGjUB4GHxwa4yuwc+yxqKUIA3dMMegEdMWuBevRV860Gj5XOHLwBX7Kw2NhT+
	 tVxp+n1OlBeEcvEWNb8dYAQLgd8/ItslAi6LlGCDF/cS5ohMrGrArx7KqVEZ1NdOH1Nh2
	 rSp1Ds1wkweIHxHF3qxBet7YjMzzN6/bwbXXEsTFejwQhsHKk2Rct8CI61Ib+nOeNhVFj
	 eE7V8gQzOj3JJSQcPktpXbcU8CgKJ83pg2YaNT7SwisNauAh36vt9nxysz5xyegGf6Xlx
	 ghFtjB3rwxIoF1rMcPs4LG1qWxNB+Ynd2tQSG+bB63CpMhaj+fKB3eb2iCuB3I0XYnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WTVOMybf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA0D606A326
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 19:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WTVOMybf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F87C1F000C1;
	Sun,  1 Nov 2026 19:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793562272;
	bh=jbUZOtL+bnqi0wsW78gKfbZAxL9DT+qPzhxoGSOrgeA=;
	h=Date:To:From:Subject;
	b=WTVOMybfwiErOYiAG/7KagMVrV8Zn1zYdRGeZ8o++Jwb6YBYBskq3Wba3EjGZvBdA
	 aADy90o/cer29lKWhT8rarH6UsB616jsOIp3Dyv88ln4S0GzxK0O23xpL8exlmOyA2
	 NBC2KV48J39NawpkVsfIx6W36S13pBB/OyeBf3HA=
Date: Sun, 01 Nov 2026 11:44:31 -0800
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,brads@mainlining.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-take-the-inode-once-in-exe_add_tsk.patch added to mm-nonmm-unstable branch
Message-Id: <20261101194432.5F87C1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: taskstats: take the inode once in exe_add_tsk()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-take-the-inode-once-in-exe_add_tsk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-take-the-inode-once-in-exe_add_tsk.patch

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
Subject: taskstats: take the inode once in exe_add_tsk()
Date: Sun, 01 Nov 2026 00:57:41 +0000

exe_add_tsk() walks exe_file->f_inode twice, once for the superblock
device and once for the inode number.  file_inode() is the accessor for
that field, and hoisting the inode out of the two assignments also gets
stats->ac_exe_dev onto one line instead of a split continuation.

Link: https://lore.kernel.org/20261101005743.3022780-2-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>
---

 kernel/taskstats.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/taskstats.c~taskstats-take-the-inode-once-in-exe_add_tsk
+++ a/kernel/taskstats.c
@@ -159,10 +159,11 @@ static void exe_add_tsk(struct taskstats
 	struct file *exe_file = get_task_exe_file(tsk);
 
 	if (exe_file) {
+		struct inode *inode = file_inode(exe_file);
+
 		/* Following cp_new_stat64() in stat.c . */
-		stats->ac_exe_dev =
-			huge_encode_dev(exe_file->f_inode->i_sb->s_dev);
-		stats->ac_exe_inode = exe_file->f_inode->i_ino;
+		stats->ac_exe_dev = huge_encode_dev(inode->i_sb->s_dev);
+		stats->ac_exe_inode = inode->i_ino;
 		fput(exe_file);
 	} else {
 		stats->ac_exe_dev = 0;
_

Patches currently in -mm which might be from brads@mainlining.org are

taskstats-use-nla_put_u32-in-mk_reply.patch
taskstats-take-the-inode-once-in-exe_add_tsk.patch
taskstats-reuse-na-in-cgroupstats_user_cmd.patch
taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task.patch

