Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BEF23C4F4
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308802; cv=none; b=FFyDT5NoM/Zc843nI2NZF9BqSA0sq8X0obNuKgWk5AGccGTmXv7q4N190VnU63oqeoA7uSxy1oD+M2vawVkcrUpEd6+EZ0nXdGgxWMYD807lXMvwAHIjRtTfYuR9RacP/E9z0Id5J2v6MqCM57rBv6LHypR5rvwZL5qtnWsWRXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308802; c=relaxed/simple;
	bh=46OFjvI/KpxtFVcet1/OnFf/+xjbpp8cTVbqrTEsbbg=;
	h=Date:To:From:Subject:Message-Id; b=tnxi/Jna8F/JjEt9jGbzri/Wo3wZP7dUzFqJxXE8W69GmlCobZTIIjwK+zahQF85Qxjtsyh9cKa1zYqQ9VdVTLjFM4t4f65nPC9JxXqqHC+C+zNKAANIMCFrRZufPwtqi/MkSwbz+pA7ll0ESpZGOJJyivLi0f7CVxAQxXBsTps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=St9YBqM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="St9YBqM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AB4C4CEF5;
	Tue,  9 Dec 2025 19:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308802;
	bh=46OFjvI/KpxtFVcet1/OnFf/+xjbpp8cTVbqrTEsbbg=;
	h=Date:To:From:Subject:From;
	b=St9YBqM6nXEqNy1bU3BMjjy90/R6zW69SmPMYwggw6+oCHG+Yxn2YjaZAGEHjk2bC
	 FSjvxFdjo4QyPudpqp2loRohi71rqmAmAKHWmwGS3LtvmvBmLmsDihsol8/n7/5bKB
	 I+dVvdPoirU3LTSrjLjb1LetqUm/Ja/0+xXe9blM=
Date: Tue, 09 Dec 2025 11:33:21 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,lkp@intel.com,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] liveupdate-luo_core-fix-redundant-bound-check-in-luo_ioctl.patch removed from -mm tree
Message-Id: <20251209193322.39AB4C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: luo_core: fix redundant bound check in luo_ioctl()
has been removed from the -mm tree.  Its filename was
     liveupdate-luo_core-fix-redundant-bound-check-in-luo_ioctl.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


