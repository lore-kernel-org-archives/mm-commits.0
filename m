Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB143112D3
	for <mm-commits@vger.kernel.org>; Mon,  1 Dec 2025 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764611166; cv=none; b=H+jiZqtkxS9UIBj9qJYrqQ4yWkhV5hJWWW/GvQb9bD1/xz6Pm2ft4QuOEQP6eKEFLwaIuZWc891eVHqkLf7m9JOZBOfDwlwrcz/M6cwg+fHGsI2FO8k5xIwo2ZY+fugpGyhoCU37tW1khhCP3E6k36CKghzeOmZfkDhv8vz2SJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764611166; c=relaxed/simple;
	bh=AWW5IU98E2PUD3ybrpIwJtOjaURhvzkHuUxTNi0sTuI=;
	h=Date:To:From:Subject:Message-Id; b=a4oIu44oHdY6HuQMSankG513+MRVsMgGtXVVfg9vZQUFKWet5MO0wMxUIoaPgRED6KLmeNIw+p0G8+teg0DcwFST2ewqCjCDfvW/92GqxR6IJbaxvZ1CWKOZnVK23cX7aeYIMLHEX/NmmPe/1cUcsF2i9Z6hoKtmKbF+PPGwZmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xqEnImXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xqEnImXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0B1C116C6;
	Mon,  1 Dec 2025 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764611163;
	bh=AWW5IU98E2PUD3ybrpIwJtOjaURhvzkHuUxTNi0sTuI=;
	h=Date:To:From:Subject:From;
	b=xqEnImXhoX7ohO9qoaXn2nxVp59VAelg4Faat6CJ/VuVKwH9r2g3uokcFe/xs7EAT
	 l8Ojz8RCCBKeRslqfc1TDcfAKzYkoJ3Jrjh0HOhf66OHUVybu32wKQItvRjda8scK4
	 w5Ze1ilVHNw6DDh1SmwU6LMLLDwjgFvU4PjHIlmY=
Date: Mon, 01 Dec 2025 09:46:02 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,lkp@intel.com,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_core-fix-redundant-bound-check-in-luo_ioctl.patch added to mm-nonmm-unstable branch
Message-Id: <20251201174603.0D0B1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: luo_core: fix redundant bound check in luo_ioctl()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-luo_core-fix-redundant-bound-check-in-luo_ioctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_core-fix-redundant-bound-check-in-luo_ioctl.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: luo_core: fix redundant bound check in luo_ioctl()
Date: Sat, 29 Nov 2025 20:09:19 -0500

The kernel test robot reported a Smatch warning:
kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is
never less than zero.

This occurs because 'nr' is unsigned and LIVEUPDATE_CMD_BASE is currently
defined as 0, making the check (nr < LIVEUPDATE_CMD_BASE) always false.

Remove the explicit lower bound check.  The logic remains correct because
'nr' is unsigned; if nr is less than LIVEUPDATE_CMD_BASE, the expression
(nr - LIVEUPDATE_CMD_BASE) will wrap around to a large positive value. 
This will inevitably be larger than ARRAY_SIZE(luo_ioctl_ops) and be
caught by the upper bound check.

Link: https://lkml.kernel.org/r/20251130010919.1488230-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511280300.6pvBmXUS-lkp@intel.com/
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/liveupdate/luo_core.c~liveupdate-luo_core-fix-redundant-bound-check-in-luo_ioctl
+++ a/kernel/liveupdate/luo_core.c
@@ -404,10 +404,8 @@ static long luo_ioctl(struct file *filep
 	int err;
 
 	nr = _IOC_NR(cmd);
-	if (nr < LIVEUPDATE_CMD_BASE ||
-	    (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
+	if (nr - LIVEUPDATE_CMD_BASE >= ARRAY_SIZE(luo_ioctl_ops))
 		return -EINVAL;
-	}
 
 	ucmd.ubuffer = (void __user *)arg;
 	err = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch
liveupdate-luo_core-fix-redundant-bound-check-in-luo_ioctl.patch

