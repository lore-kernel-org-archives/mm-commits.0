Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235EC4C62
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977365; cv=none; b=DfCFoGILENJyXKX1cM5vvqsurx3enrhqzL9yga2PFHjY3EJRY7LyyoKyfalJN3akqqS3SmicZgS41dEV64rnU85Ajp7e+oVVE1iVEZhtKUx8gHGCDrlw6fsrEHeX3+79G828mu0iQV+pgxXwiwQGyLWH0DR9TXgcjCtbF2DFsdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977365; c=relaxed/simple;
	bh=LlZS6AO/0XIDIhDDLElUTYtMWbFvQIGXLy6jq6NZ4is=;
	h=Date:To:From:Subject:Message-Id; b=KSvD5qVPg/5qfGU8vusphBq1lnxvQadjggogIEUFyo6GDVc0WeQIstxpZmxKPDu5BJ7u2viniH00o6K1rOJQ2r5aNRaYgV1QCiEQ/Y6SOJW3J6sQUwDWcWMlWiTo/FqhsaewBu2heaQnGe2rVNdqiuyyIqyyQXxAFQYakeZbgAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SimjzIre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SimjzIre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2725C4CEE3;
	Sun, 20 Jul 2025 02:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977365;
	bh=LlZS6AO/0XIDIhDDLElUTYtMWbFvQIGXLy6jq6NZ4is=;
	h=Date:To:From:Subject:From;
	b=SimjzIreUAC1Sh39TvUKCwivLTg17IEo2F/v/+rSfB8tEEjpSoJn92Bfo4VQqpTXe
	 j1e5e2jEfx290apIUraEFVUtAf1PwZs8S3HWU6drXEW+Fie01PEQvfxR3IkQF31plo
	 jP+2k073NQun+GpHoO38N4prByJeigtREk87v6I0=
Date: Sat, 19 Jul 2025 19:09:24 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,nabijaczleweli@nabijaczleweli.xyz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-dlm-fix-take-a-while-typo.patch removed from -mm tree
Message-Id: <20250720020924.E2725C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2/dlm: fix "take a while" typo
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-take-a-while-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Subject: ocfs2/dlm: fix "take a while" typo
Date: Thu, 3 Jul 2025 20:21:27 +0200

Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-take-a-while-typo
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2632,7 +2632,7 @@ again:
 					 dlm_reco_master_ready(dlm),
 					 msecs_to_jiffies(1000));
 		if (!dlm_reco_master_ready(dlm)) {
-			mlog(0, "%s: reco master taking awhile\n",
+			mlog(0, "%s: reco master taking a while\n",
 			     dlm->name);
 			goto again;
 		}
_

Patches currently in -mm which might be from nabijaczleweli@nabijaczleweli.xyz are


