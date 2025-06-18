Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FACF1632CA;
	Wed, 18 Jun 2025 01:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750209482; cv=none; b=MOb0sIXBfQH1LJSGgegKQ6rRNVzo57i4b9+KpJ1udRbq7zGDQ2hXh+qFKApOiQB+czFFZ8lywxfeKZzeTAcDnuJt1PoeOyMIMHxOLBhZmW7vxDG2D5S40SdGGfMEtXfamcPKKBjbEuJHBLuDH9KeYow9/jC4rVOhY8/rWaByIV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750209482; c=relaxed/simple;
	bh=lerISQSspKt7OkabgJZhbLylnYyFwjhb5P69GsdDVms=;
	h=Date:To:From:Subject:Message-Id; b=Cnpodlst7JjCd3TXpbR4SzJCASPLUT2vJGHxURI4Myce2gQ6wDTTBsqOJMGC6IJugtFbSb/BpjIMna0AsBvMnfFuvoxP7jwTUzd2Waj5vCLRtnHrVovz+2FoA3bnaXtBlrRryEaJPfzKXVAL7DBRZ8D0Ov6N3YjgT+4wduVptdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ok7BnYXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ok7BnYXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7A5C4CEE7;
	Wed, 18 Jun 2025 01:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750209481;
	bh=lerISQSspKt7OkabgJZhbLylnYyFwjhb5P69GsdDVms=;
	h=Date:To:From:Subject:From;
	b=ok7BnYXnXY5bML31H2SAXpNTz+MT2po6/q0x2pg+Smnkcs2AO2ri+l8C8uwczdiLg
	 VVExJBB3brKLvlnjzBHEblWh3p2LD/2YGPQw6HMW80TCfDebFEhLo6SVcvORNjp/0d
	 j2iTAD36JIZPd2aEDMyjTM9lf7hHwhnYL25fHl5c=
Date: Tue, 17 Jun 2025 18:18:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,lizhi.xu@windriver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reset-folio-to-null-when-get-folio-fails.patch added to mm-nonmm-unstable branch
Message-Id: <20250618011801.BF7A5C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reset folio to NULL when get folio fails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reset-folio-to-null-when-get-folio-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reset-folio-to-null-when-get-folio-fails.patch

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
From: Lizhi Xu <lizhi.xu@windriver.com>
Subject: ocfs2: reset folio to NULL when get folio fails
Date: Mon, 16 Jun 2025 09:31:40 +0800

The reproducer uses FAULT_INJECTION to make memory allocation fail, which
causes __filemap_get_folio() to fail, when initializing w_folios[i] in
ocfs2_grab_folios_for_write(), it only returns an error code and the value
of w_folios[i] is the error code, which causes
ocfs2_unlock_and_free_folios() to recycle the invalid w_folios[i] when
releasing folios.

Link: https://lkml.kernel.org/r/20250616013140.3602219-1-lizhi.xu@windriver.com
Reported-by: syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c2ea94ae47cd7e3881ec
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/aops.c~ocfs2-reset-folio-to-null-when-get-folio-fails
+++ a/fs/ocfs2/aops.c
@@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(s
 			if (IS_ERR(wc->w_folios[i])) {
 				ret = PTR_ERR(wc->w_folios[i]);
 				mlog_errno(ret);
+				wc->w_folios[i] = NULL;
 				goto out;
 			}
 		}
_

Patches currently in -mm which might be from lizhi.xu@windriver.com are

ocfs2-reset-folio-to-null-when-get-folio-fails.patch

