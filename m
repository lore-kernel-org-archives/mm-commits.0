Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A73221F2D
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 23:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748473797; cv=none; b=bbptLgmm+WoxzDp6iiIpOiW02YpoBVkmNFl2fK9Zjg5QbyjhaZaO5/CyqPhi84+QRzX0M1EFvYMQzospyDNJPPOhXg5sNlrVViwJzT/Z1RmFQpXHpUxQJOLU54Z1WTXQJad8DXCJFj1IWefo2pcnMmNYfmXmb6pKezyMRJOMeAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748473797; c=relaxed/simple;
	bh=2LN26dZK3+5DU7BYLu6uLhiyQ9U9ftczpnLnD1AOIGU=;
	h=Date:To:From:Subject:Message-Id; b=C6Aibeg2ZwlSjiwePon70PDdMKWtKlPZWs0DjkrRJQSDknyyXptWviLSADQDNmTIloPSox16G4C6OB4VFE8KXG9VEGoKySl05Yd4EkhsW4QZSKJw1nQdMR6SFxUIgBVLycpaRI3/2w/Qj2Wczo8mftQjKhngXp1flaxbndtxHyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QpVMF3Ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QpVMF3Ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC887C4CEE3;
	Wed, 28 May 2025 23:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748473796;
	bh=2LN26dZK3+5DU7BYLu6uLhiyQ9U9ftczpnLnD1AOIGU=;
	h=Date:To:From:Subject:From;
	b=QpVMF3Ea1MKx/c4ycdu6umhVwV9w87oEbanBVmlKBb9lR5hF+2LAzAYccsxSNChS5
	 nHy/X2TtNOEL504vMx+HTwobojzEWsPMCGKc2EM4x+qpLf/XOxQZfOv0AYMKkmb7E0
	 qknGY4JiAcjqPCWBSRBvnj7AD1pI5aB1abia4LR8=
Date: Wed, 28 May 2025 16:09:56 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,shuah@kernel.org,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-check-correct-variable-in-open_procmap.patch added to mm-unstable branch
Message-Id: <20250528230956.CC887C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing: check correct variable in open_procmap()
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-check-correct-variable-in-open_procmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-check-correct-variable-in-open_procmap.patch

This patch will later appear in the mm-unstable branch at
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
Subject: tools/testing: check correct variable in open_procmap()
Date: Wed, 28 May 2025 11:13:45 +0300

Check if "procmap_out->fd" is negative instead of "procmap_out" (which is
a pointer).

Link: https://lkml.kernel.org/r/aDbFuUTlJTBqziVd@stanley.mountain
Fixes: bd23f293a0d5 ("tools/testing: add PROCMAP_QUERY helper functions in mm self tests")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: levi.yun <yeoreum.yun@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~tools-testing-check-correct-variable-in-open_procmap
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -439,7 +439,7 @@ int open_procmap(pid_t pid, struct procm
 	sprintf(path, "/proc/%d/maps", pid);
 	procmap_out->query.size = sizeof(procmap_out->query);
 	procmap_out->fd = open(path, O_RDONLY);
-	if (procmap_out < 0)
+	if (procmap_out->fd < 0)
 		ret = -errno;
 
 	return ret;
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

tools-testing-check-correct-variable-in-open_procmap.patch

