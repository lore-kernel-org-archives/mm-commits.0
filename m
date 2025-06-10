Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928E74685
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749587806; cv=none; b=Nbv7toQ6KAs4gpL/aKn3sVHZvFrFmqcmaPnkUEPGyYNoyswTUEZExWx3TpL49b7sCZDqoqF0E0YcQ8AKdgkc/7SWK79VWVED74bGwFicaB2OPFTFeMeorpyg9BrEAe6czC9N0MKLrZT4njjqcgOntJjOH8XJvBdFLCVJK8oTO+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749587806; c=relaxed/simple;
	bh=65kGbnVaT53D5dIRaRSyJ0BIXDASO22sGKasn9wO9x0=;
	h=Date:To:From:Subject:Message-Id; b=oT6uhy3Ghkzv/nAokcQ+QIoJkzzGY8BqQvvzrlQKpDS/dMYFB+KGEUK/AXHE/HM0o92kz1p6RGdlQ0nPYGW09wIjubmA4hTgwB0s2dFt2UU4SB1f1l+e51IErNKXTTOo/29gi2MLmZH4LwGRPCooP4Ei+snDDcExIYwtZZyuoFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LMLr8qSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LMLr8qSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6B5C4CEED;
	Tue, 10 Jun 2025 20:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749587806;
	bh=65kGbnVaT53D5dIRaRSyJ0BIXDASO22sGKasn9wO9x0=;
	h=Date:To:From:Subject:From;
	b=LMLr8qSmCLwSD5zYxiaMJb4LOMRpTwRIga4LiKf8joyPYGAz36d5J8HSFziGqHBoz
	 0NK/PngRHfF+vJDuw4yeKIDKwGUI1JZY6+oUMqVrEOeukDq+I1r80+/fC9RuI3JdpG
	 dzBfKPm7ax3UXgZpKB9pG1o+xCb0qpZsp2WEsB+Y=
Date: Tue, 10 Jun 2025 13:36:45 -0700
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-clarify-error-handling-labels-in-memfd_create.patch added to mm-new branch
Message-Id: <20250610203646.0F6B5C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: clarify error handling labels in memfd_create()
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd-clarify-error-handling-labels-in-memfd_create.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-clarify-error-handling-labels-in-memfd_create.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/memfd: clarify error handling labels in memfd_create()
Date: Tue, 10 Jun 2025 16:37:30 +0800

err_name --> err_free_name (fd failure case)
err_fd --> err_free_fd (file failure case)

Link: https://lkml.kernel.org/r/20250610083730.527619-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memfd.c~mm-memfd-clarify-error-handling-labels-in-memfd_create
+++ a/mm/memfd.c
@@ -475,22 +475,22 @@ SYSCALL_DEFINE2(memfd_create,
 	fd = get_unused_fd_flags((flags & MFD_CLOEXEC) ? O_CLOEXEC : 0);
 	if (fd < 0) {
 		error = fd;
-		goto err_name;
+		goto err_free_name;
 	}
 
 	file = alloc_file(name, flags);
 	if (IS_ERR(file)) {
 		error = PTR_ERR(file);
-		goto err_fd;
+		goto err_free_fd;
 	}
 
 	fd_install(fd, file);
 	kfree(name);
 	return fd;
 
-err_fd:
+err_free_fd:
 	put_unused_fd(fd);
-err_name:
+err_free_name:
 	kfree(name);
 	return error;
 }
_

Patches currently in -mm which might be from liuye@kylinos.cn are

tools-mm-add-script-to-display-page-state-for-a-given-pid-and-vaddr.patch
mm-memfd-clarify-error-handling-labels-in-memfd_create.patch

