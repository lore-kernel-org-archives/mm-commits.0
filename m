Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246D820AF67
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 23:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755734275; cv=none; b=kJleMmhMJWm5NNAb2MREQzzeK7edD/cx3xPxy2uPA2qpsmpIYvWhTmCTRjngurzMWDRMXoA1dKzaeny+jIm95gpJoQzEihcJ9G35Bxs2mIL/NWCwo3X9HyG525c8N5rbK02yKVbS4h53IekWjHCFW5O6Yue+aJpskkMBCr+sKHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755734275; c=relaxed/simple;
	bh=Ji13EIzr6B8xxqNNVhcIMIY7taBcxufNDbT5wgbze2c=;
	h=Date:To:From:Subject:Message-Id; b=i9mAqv9luPn0hbs3n/fjyA5xuSOuuSCEokSUIdgwyINq0F73e+vD7Vx4O5EGo4b5LKat6nDE4vxwik5ptvojirc+KwBJykOsFp1gXqj7Uq0q8WVrCCTJTVY3n6jkX41mhyFMKc0pdSzX9NEGQrN2uhwj8iJOJ8HvYBaEmA+u8E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mRbYnNFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mRbYnNFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F0AC4CEE7;
	Wed, 20 Aug 2025 23:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755734274;
	bh=Ji13EIzr6B8xxqNNVhcIMIY7taBcxufNDbT5wgbze2c=;
	h=Date:To:From:Subject:From;
	b=mRbYnNFKrTH6MFvr89FDodU2jg+f/NgT0cKp+5tXSsQ6aCzxJK4aJ+LjlvpcFh3yl
	 XVuh3yavb6VYXv6a0fmp3usrmBJ7c9GJiU3oyqhWjdSQKk1kGKjOfv/VbIzDRepdtE
	 hY/+loseGt8bMGpkNo8MbDBYD43gDAOAQhHfec9E=
Date: Wed, 20 Aug 2025 16:57:54 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-unnecessary-null-check-in-ocfs2_grab_folios.patch added to mm-nonmm-unstable branch
Message-Id: <20250820235754.86F0AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove unnecessary NULL check in ocfs2_grab_folios()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-unnecessary-null-check-in-ocfs2_grab_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-unnecessary-null-check-in-ocfs2_grab_folios.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: ocfs2: remove unnecessary NULL check in ocfs2_grab_folios()
Date: Tue, 19 Aug 2025 12:41:51 +0300

Smatch complains that checking "folios" for NULL doesn't make sense
because it has already been dereferenced at this point.  Really passing a
NULL "folios" pointer to ocfs2_grab_folios() doesn't make sense, and
fortunately none of the callers do that.  Delete the unnecessary NULL
check.

Link: https://lkml.kernel.org/r/aKRG39hyvDJcN2G7@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-remove-unnecessary-null-check-in-ocfs2_grab_folios
+++ a/fs/ocfs2/alloc.c
@@ -6928,8 +6928,7 @@ static int ocfs2_grab_folios(struct inod
 
 out:
 	if (ret != 0) {
-		if (folios)
-			ocfs2_unlock_and_free_folios(folios, numfolios);
+		ocfs2_unlock_and_free_folios(folios, numfolios);
 		numfolios = 0;
 	}
 
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

ocfs2-remove-unnecessary-null-check-in-ocfs2_grab_folios.patch

