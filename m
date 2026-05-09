Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBEB19067C;
	Sat,  9 May 2026 00:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778286742; cv=none; b=T917qp2dbsOYGyi20ZsRsChqcF7EqBGEb0rAVtaTHdPdLcmNTPB4QvMEANnJPIQ54e+pndCfEU1XPE7nQbwP0F8mK0T4ihGwSoER8RPBo7L/P70q9K04gFKc/EuCLHiH8yCERRWNaSgfMDxcFDxlKZVSma3pgMvYIoXnsOlxZw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778286742; c=relaxed/simple;
	bh=nA3vBqx+cka19LK/V+0bdW4+dgWIC53jyPT1VnZLHFU=;
	h=Date:To:From:Subject:Message-Id; b=DzHKulkZLpouB6DB5bF6zEIsxS6Lbhf1e5HmYEYgCLn1UoUfC/4U1f9MSgnORtzueZXw6zTkf0ScOYNAuxBMSU7jD22pfDIjSmJ2UeExxLZ9mILLhvkdDgXAkijPrQBgo0R6wx0swFeZqTWBip+9+VaSPkWvYL3NlJmz6aqXdIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6XnMQrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6XnMQrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ACDC2BCB0;
	Sat,  9 May 2026 00:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778286741;
	bh=nA3vBqx+cka19LK/V+0bdW4+dgWIC53jyPT1VnZLHFU=;
	h=Date:To:From:Subject:From;
	b=H6XnMQrO7hS0r8kxhv1cbCO8rBMvir9QfTZhqbnDyA7c7Oj4QlFnp5Wa20cFOkJ3l
	 DsggNttUUYB3gKkON+U7S6aZoeFfwoEN2OkwfFtUAoLW5WomcgA3FK0X6GMpHEkSHn
	 6mmxjpJjvcIHTESI1zlZ3Y1BUEfYUA1OT2xuOnwY=
Date: Fri, 08 May 2026 17:32:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pasha.tatashin@soleen.com,kees@kernel.org,jeffxu@google.com,jackmanb@google.com,hughd@google.com,gthelen@google.com,david@kernel.org,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-deny-writeable-mappings-when-implying-seal_write.patch added to mm-hotfixes-unstable branch
Message-Id: <20260509003221.D5ACDC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memfd: deny writeable mappings when implying SEAL_WRITE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memfd-deny-writeable-mappings-when-implying-seal_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-deny-writeable-mappings-when-implying-seal_write.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: memfd: deny writeable mappings when implying SEAL_WRITE
Date: Tue, 5 May 2026 15:39:20 +0200

When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X.  But the
implied seal is set after the check that makes sure the memfd can not have
any writable mappings.  This means one can use SEAL_EXEC to apply
SEAL_WRITE while having writeable mappings.

This breaks the contract that SEAL_WRITE provides and can be used by an
attacker to pass a memfd that appears to be write sealed but can still be
modified arbitrarily.

Fix this by adding the implied seals before the call for
mapping_deny_writable() is done.

Link: https://lore.kernel.org/20260505133922.797635-1-pratyush@kernel.org
Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to executable memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 
Acked-by: Jeff Xu <jeffxu@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memfd.c~memfd-deny-writeable-mappings-when-implying-seal_write
+++ a/mm/memfd.c
@@ -283,6 +283,12 @@ int memfd_add_seals(struct file *file, u
 		goto unlock;
 	}
 
+	/*
+	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
+	 */
+	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
+		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
+
 	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
 		error = mapping_deny_writable(file->f_mapping);
 		if (error)
@@ -295,12 +301,6 @@ int memfd_add_seals(struct file *file, u
 		}
 	}
 
-	/*
-	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
-	 */
-	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
-		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
-
 	*file_seals |= seals;
 	error = 0;
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

memfd-deny-writeable-mappings-when-implying-seal_write.patch

