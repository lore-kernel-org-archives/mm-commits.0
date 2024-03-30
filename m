Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4390229A1
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711768616; cv=none; b=EZd58oJWlE+dLav4LN7denm26Y1otsWC+U9Om9Aej85EWGFYL1T/Nil8nv+VcptW2z2leeDTg6OPD9zN9X+/tnXhX4ezVQsSbvYET2EjjMnE1Na572tFTXwteTWQCt7WJ9auEeWhqpDU/ua4zQ6jbK0ZDwEXPIODJhFNH6M8xNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711768616; c=relaxed/simple;
	bh=wYfDu4FRr02+jZSvNi44UucCWJiYLve8GAd7Rqkbk/s=;
	h=Date:To:From:Subject:Message-Id; b=kjTTkrxrt+4riUo79cWPsWeXknCRxxZztkZLqIyQhV+9KGgRhqoAev+geMNzEKqhv0dORayU2SGrRTOXUZBrvFeDXdpvm/7EArn1SRYdHIRYpVgetIjCVIISJvAYqzfsaGdlRBpLnKODy7Ryu3fN8wTyPP/2lbvQhw1G1srpOVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qgl9g+WJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qgl9g+WJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F1BC433C7;
	Sat, 30 Mar 2024 03:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711768615;
	bh=wYfDu4FRr02+jZSvNi44UucCWJiYLve8GAd7Rqkbk/s=;
	h=Date:To:From:Subject:From;
	b=qgl9g+WJX2ckeNoKbTTqe5aJFTDX+5SepMpYU5ZJ/m4GP5o0QZxza3TN5V25cpDpE
	 vWmSY02iqlQoRKv1+p5lefC/quBfZCMHMnSK+p9QCWaxJHc1FinzGxlSLT+D36UBPh
	 fIZvpWfr/F1WnbD5Q6fQZ1RANJXxeWN6olVqk78g=
Date: Fri, 29 Mar 2024 20:16:54 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,pstanner@redhat.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,konishi.ryusuke@gmail.com,justinstitt@google.com,jlayton@kernel.org,brauner@kernel.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-out-of-range-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20240330031655.A2F1BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix out-of-range warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-out-of-range-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-out-of-range-warning.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: nilfs2: fix out-of-range warning
Date: Thu, 28 Mar 2024 15:30:44 +0100

clang-14 points out that v_size is always smaller than a 64KB page size if
that is configured by the CPU architecture:

fs/nilfs2/ioctl.c:63:19: error: result of comparison of constant 65536 with expression of type '__u16' (aka 'unsigned short') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (argv->v_size > PAGE_SIZE)
            ~~~~~~~~~~~~ ^ ~~~~~~~~~

This is ok, so just shut up that warning with a cast.

Link: https://lkml.kernel.org/r/20240328143051.1069575-7-arnd@kernel.org
Fixes: 3358b4aaa84f ("nilfs2: fix problems of memory allocation in ioctl")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Philipp Stanner <pstanner@redhat.com>
Cc: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/ioctl.c~nilfs2-fix-out-of-range-warning
+++ a/fs/nilfs2/ioctl.c
@@ -60,7 +60,7 @@ static int nilfs_ioctl_wrap_copy(struct
 	if (argv->v_nmembs == 0)
 		return 0;
 
-	if (argv->v_size > PAGE_SIZE)
+	if ((size_t)argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
 	/*
_

Patches currently in -mm which might be from arnd@arndb.de are

nilfs2-fix-out-of-range-warning.patch

