Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0370157476
	for <mm-commits@vger.kernel.org>; Tue,  9 Apr 2024 23:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704472; cv=none; b=S97uQzh4NIKeuS9aXlqAWVa1HulCZR/OqFgaI2XdvVjrvioA3BjrONyCdR19KT8vsO/09RQ4R1Uk1g8130D/uIKgixydWuOSjMmGY60xQGmR8qRI4oisNksO57jTMoCCm3ttUfr6fruH1pBoFaJ2WFqTsux9D2z0Cl+xBtrrTJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704472; c=relaxed/simple;
	bh=HNzBrf3Hd/a5gAdoyGRZVf+FccsLQutKRLAx6nUIWVc=;
	h=Date:To:From:Subject:Message-Id; b=dHX86ehvfg4TLpKfRIQe5ORO2SoLdfpZOPUD7G0sPeZdNU4/hiYpJQvtfAZqhCMGzyZy+klaad+aeJBnUM1xjbUeG2g0W4k2Q9/NZMd6J0qG8nSAqBMeVVdH7QM59xUJXM+RT+bDNbv2yyqCYuDbMiOOcH9f1NWN+pM2aizPQmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d5YIx/tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d5YIx/tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA9AC433C7;
	Tue,  9 Apr 2024 23:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712704471;
	bh=HNzBrf3Hd/a5gAdoyGRZVf+FccsLQutKRLAx6nUIWVc=;
	h=Date:To:From:Subject:From;
	b=d5YIx/tbSaSrMVQo2XhQEbI/1DNGIYJYrHGifs8D1R8OnTusocnfM5RVhdkbQGU/Y
	 s6JyfCC80ZSLZzkfI91wDqhARtvBPOgFrD0OGKQ7XyKZNzaso3E4P2JS17s8oL9Lqp
	 6l5IBiVwQ15z17G6HRQtcmeKIq90cVkTtCk0RHbk=
Date: Tue, 09 Apr 2024 16:14:30 -0700
To: mm-commits@vger.kernel.org,bugreport@ubisectech.com,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240409231431.2EA9AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2
Date: Tue, 9 Apr 2024 21:47:23 +0100

whitespace fix

Link: https://lkml.kernel.org/r/20240409204723.446925-1-phillip@squashfs.org.uk
Reported-by: "Ubisectech Sirius" <bugreport@ubisectech.com>
Closes: https://lore.kernel.org/lkml/87f5c007-b8a5-41ae-8b57-431e924c5915.bugreport@ubisectech.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/inode.c~squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2
+++ a/fs/squashfs/inode.c
@@ -49,7 +49,7 @@ static int squashfs_new_inode(struct sup
 	int err;
 
 	inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
-	if(inode->i_ino == 0)
+	if (inode->i_ino == 0)
 		return -EINVAL;
 
 	err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->uid), &i_uid);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch
squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2.patch
squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch

