Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6011CFBC
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742227704; cv=none; b=qnEZHQPHFkwsHA95PExu5i3ahtkEbvdxjarBdFg6Z8MncLXtdjkY9/FvzoBgAe9ijNmB4YYajqVAv6bQmyAouIjMFoDQObtOXhcVUAMooArtqB56loA3zxNhYHUHnu0wclmo+PsOpoOAjzg36OtbwTUA/+HJ6xFp+2PPTrjr0zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742227704; c=relaxed/simple;
	bh=rZqk53Q4xnSnDkeNZjN8oXzwSWBYHvmQVQ6r/jwUI2I=;
	h=Date:To:From:Subject:Message-Id; b=AAlP3i/Qg8AqQNifTqJe5hk2fS0K5CLCbMfVOYXFCHH+E0tLAzc0p3pzAcC+v7FrpcXUb8+6p9iguwRpsGMH5+TKvHzpUVnIM4XMBi9KUWtSuZ1sPxrsP6IniMS+FL1+YKF571XqVu4whaK2zOn264nn9Y5jePwCPG/WyXD6LX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f/WA9kM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f/WA9kM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637BEC4CEEC;
	Mon, 17 Mar 2025 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742227703;
	bh=rZqk53Q4xnSnDkeNZjN8oXzwSWBYHvmQVQ6r/jwUI2I=;
	h=Date:To:From:Subject:From;
	b=f/WA9kM3CLiVWx0ZehzTIPCHucYPV55CvJFMapkcxP8ma4JdrLiwqTf9Sl5EVgICg
	 3PnABS+L9fCklovBm5m3dAvWvtyA7SHyoqg8oaCxNDlWcvmU32B+jWSV6n8xHmWohj
	 eQebx9PQY6N/Mjh/IzfQXAocOraND08StXFcRPMc=
Date: Mon, 17 Mar 2025 09:08:22 -0700
To: mm-commits@vger.kernel.org,keescook@chromium.org,ebiederm@xmission.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-myself.patch added to mm-nonmm-unstable branch
Message-Id: <20250317160823.637BEC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove Eric
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-remove-myself.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-myself.patch

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
From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: MAINTAINERS: remove Eric
Date: Mon, 17 Mar 2025 08:47:30 -0500

Unfortunately I no longer have time to meaningfully take part in the
linux kernel development.

Link: https://lkml.kernel.org/r/87r02v7or1.fsf@email.froward.int.ebiederm.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ---
 1 file changed, 3 deletions(-)

--- a/MAINTAINERS~maintainers-remove-myself
+++ a/MAINTAINERS
@@ -8643,7 +8643,6 @@ F:	rust/kernel/net/phy/reg.rs
 
 EXEC & BINFMT API, ELF
 M:	Kees Cook <kees@kernel.org>
-R:	Eric Biederman <ebiederm@xmission.com>
 L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/execve
@@ -12826,9 +12825,7 @@ F:	fs/kernfs/
 F:	include/linux/kernfs.h
 
 KEXEC
-M:	Eric Biederman <ebiederm@xmission.com>
 L:	kexec@lists.infradead.org
-S:	Maintained
 W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 F:	include/linux/kexec.h
 F:	include/uapi/linux/kexec.h
_

Patches currently in -mm which might be from ebiederm@xmission.com are

maintainers-remove-myself.patch

