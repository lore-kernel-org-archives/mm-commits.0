Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D441B4236
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 02:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751940440; cv=none; b=eCb/uU+djf31bdsZa9XbSs7Aet9p9MwZ+3ytaGBaq8kryWIxamTma0K9+tfHpzlwvviYHxDrOD2lBI7GmFa2mzPQMgmehzw2xpUHapVoV+s6VLoUyUZzrqH8HInManX11/si1KpLHO8nfB1pMCz82Cr3Dd+t4QfvuDu/wxt7E3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751940440; c=relaxed/simple;
	bh=5A0eH+RJVWkf12JhFM/7JQ8XsXdfWcbeJQjZh/dFLos=;
	h=Date:To:From:Subject:Message-Id; b=qWsn4RZXVEXfsicDN28Zlu8lO5LTnRyCV8Zw1DjzO1pljxz1YiQ67yuCj/qFlk4agYbipKNkRUtIoBntJADyJ6HFdzOAv9XTnkhAXhaHSMiRmiTBnqvZ91y0FKr/TTfqU8CLWZRGVjNekHV9btvT71KWvhFpPqO4dLlmvoyxlcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Br1HxgQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Br1HxgQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751A7C4CEE3;
	Tue,  8 Jul 2025 02:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751940439;
	bh=5A0eH+RJVWkf12JhFM/7JQ8XsXdfWcbeJQjZh/dFLos=;
	h=Date:To:From:Subject:From;
	b=Br1HxgQBiqALzX4LVd+kv4QGSuvMIciPZCLUGpHdrwohAw/V95lhPocleB5alLMOt
	 DRUtEals7V1jq4mVsSIJjivRPwhGMm77ELz4a0fXsFFN9KN30JnDAX5f9NvQBjCpbU
	 /0oWHPpp99Qn0Hsk26lqmdUvgWnz9++hbIlAtnHI=
Date: Mon, 07 Jul 2025 19:07:18 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,nabijaczleweli@nabijaczleweli.xyz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-dlm-fix-take-a-while-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20250708020719.751A7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2/dlm: fix "take a while" typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dlm-fix-take-a-while-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dlm-fix-take-a-while-typo.patch

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

ocfs2-dlm-fix-take-a-while-typo.patch

