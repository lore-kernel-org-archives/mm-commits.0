Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793562275;
	b=kkmbM0Ewv0Vw4CxCKzmVASD4uExVDB4UDhJQVRs302qAUSb3+GKN3ZHY/fJQmtlfEu83
	 hGdJuLGtDnvGWx/LB9F/lgdXkpJ8XvtrDXfjZ5mtVi4REeYzP65KVIRRKbyiOBz24ktt8
	 S7Qdx8cp39hWOja0/pYs8yBFEmTn8dKwDJSnIDLRRz2yml0X0J31ZzptXfoDhQUImjNCv
	 iQFMLTzPPu07z938BvD5903D0CStCu5tAHzYMEYCTpOMka/jiiS0O1oVFMB9B8aIDWxOM
	 fz6vXHlPy535AqVPrZGrgjwZ7B8AmPRYGKSOCsxXMemQpjhasZu4LdPQRYCu4u1Zpzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562275;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0xzPpztL6ZAPTWzkaOBD+xn/GGZArcM3a+nx+fwW+BM=;
	b=TQvA5rmt2cOE8PrvjJmQkp9Z2rgJFUcG6taUxBzjvol8e2NKP1ohbF178jl4jkUGo1DA
	 o7Nr8+9zvXOyLh+jS+ZZoo88tjOYfIWqTmiTztyAmY0tpZZ+3q+u7z5/jHQiMfMqHtFJn
	 CltUk1e4sdntshh7gX4mHwZqYds9kXouYkO6GPNy/JCr4E/cgr0FTcSte/P4qmOZ03dZv
	 tdMNb3WcQCTMCJIDtkoQELOkCufBgkUP5KUAK+9OTbR8V6OzNf5W4BmKdpwYjW/Jh3DJZ
	 TKNdC8GiUWH6AnXYFECU4Rvu/GtSLS2cSRTjH4oPWejSgg9nreVFK9YqbRJACtILshQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CVM2Wik8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC12B606A325
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 19:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CVM2Wik8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6B81F000C1;
	Sun,  1 Nov 2026 19:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793562274;
	bh=0xzPpztL6ZAPTWzkaOBD+xn/GGZArcM3a+nx+fwW+BM=;
	h=Date:To:From:Subject;
	b=CVM2Wik8a4Z4u18K+clh5/YCwMUnUzqVfhP2byF62rY+Mo5MsDhdB1JlVgxsl1WaW
	 hy6qjIozWvzaxmg54aosDF8Fefd83T/8iiPdoYylOP/RGM9HF4jplc+sEss717USbD
	 ngf/vcoL4IAkl0E0cyismzEEUpDcqNAwLLlFMzXo=
Date: Sun, 01 Nov 2026 11:44:33 -0800
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,brads@mainlining.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-reuse-na-in-cgroupstats_user_cmd.patch added to mm-nonmm-unstable branch
Message-Id: <20261101194434.3C6B81F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: taskstats: reuse na in cgroupstats_user_cmd()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-reuse-na-in-cgroupstats_user_cmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-reuse-na-in-cgroupstats_user_cmd.patch

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
Subject: taskstats: reuse na in cgroupstats_user_cmd()
Date: Sun, 01 Nov 2026 00:57:42 +0000

cgroupstats_user_cmd() already pulled CGROUPSTATS_CMD_ATTR_FD into na to
check that the user sent it, then indexes info->attrs[] a second time to
read the value out of the very same attribute.  Read it from na.

No functional change.

Link: https://lore.kernel.org/20261101005743.3022780-3-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/taskstats.c~taskstats-reuse-na-in-cgroupstats_user_cmd
+++ a/kernel/taskstats.c
@@ -417,7 +417,7 @@ static int cgroupstats_user_cmd(struct s
 	if (!na)
 		return -EINVAL;
 
-	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
+	fd = nla_get_u32(na);
 	CLASS(fd, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;
_

Patches currently in -mm which might be from brads@mainlining.org are

taskstats-use-nla_put_u32-in-mk_reply.patch
taskstats-take-the-inode-once-in-exe_add_tsk.patch
taskstats-reuse-na-in-cgroupstats_user_cmd.patch
taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task.patch

