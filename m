Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2633B83E3
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 23:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428792; cv=none; b=nmeQsVdiAQ2LudswuXA8cki0+FVGPsS/iF/VBxZIYhFFNSQUI1p9oxvFJEPXmTz9tWSDka1AzQ6TZf30NfQ2aa9KveqKJvoBBfnGxyotNTUPudahjaXLGOSlD0jOZlwzZjbawA94fFA0dPinsmRJXEwvvTDWkmGLIyUCmHg4VaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428792; c=relaxed/simple;
	bh=mxqNxGzTeTWlpe2R5zyJDIVhM9l4miYG+SD5TWaxQdA=;
	h=Date:To:From:Subject:Message-Id; b=Lc/ikU3k3eHpMgGqKWCLNPmC509AZ/KI5wzS+UAMO+NipSNt80lFwwZY6vI8UNRlCDkX8OoiGYw3H7uXzDHYzJ+MTA0L4ejMrHnzfiEZeOCSUGM4CKfy67Jr/lZvwgOVjFfSAdqGH9I2rWb/du6T7SjKKbNwVHZyxmfFzvduwd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZCllFjiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZCllFjiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD5C1F000E9;
	Thu, 25 Jun 2026 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782428785;
	bh=E8M+Y3b2EaY4f1NBQilDFqYlxcfBgKgXIxjL/3AP8Qs=;
	h=Date:To:From:Subject;
	b=ZCllFjiyjuuTQB+oTXvsv85Jp8m3d6/JIyylEBxA3+em/B1JRbim+/6Ez5wyqb2ow
	 Xjz/Y9j07XLdUmk2LWVEDpLM8Jq0eTGn8mK1dP4Ih0FS+riq+2C2STUAVK+gaP+Ki7
	 eRkkiLOZrhp3vk0zT6iDkrFYeJ6sm4vjYg4LG7uQ=
Date: Thu, 25 Jun 2026 16:06:24 -0700
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,dave@stgolabs.net,shijianlin11@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-only-destroy-orphaned-shm-segments-on-sysctl-write.patch added to mm-nonmm-unstable branch
Message-Id: <20260625230625.0CD5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc: only destroy orphaned shm segments on sysctl write
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-only-destroy-orphaned-shm-segments-on-sysctl-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-only-destroy-orphaned-shm-segments-on-sysctl-write.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jianlin Shi <shijianlin11@foxmail.com>
Subject: ipc: only destroy orphaned shm segments on sysctl write
Date: Mon, 15 Jun 2026 10:27:41 +0800

proc_ipc_dointvec_minmax_orphans() currently calls shm_destroy_orphaned()
whenever shm_rmid_forced is set, including on sysctl reads.  Reading
/proc/sys/kernel/shm_rmid_forced should not take shm_ids rwsem for write
and walk all segments.

Only run the cleanup when the sysctl is written and the forced RMID policy
is enabled.

When shm_rmid_forced=1, monitoring tools that read
/proc/sys/kernel/shm_rmid_forced trigger the cleanup on every read.

Link: https://lore.kernel.org/all/?q=only+destroy+orphaned+shm+segments+on+sysctl+write
Link: https://lore.kernel.org/tencent_738A8BC6E9EA205F555E4B0DAA154D4F8E0A@qq.com
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/ipc_sysctl.c~ipc-only-destroy-orphaned-shm-segments-on-sysctl-write
+++ a/ipc/ipc_sysctl.c
@@ -28,7 +28,7 @@ static int proc_ipc_dointvec_minmax_orph
 
 	if (err < 0)
 		return err;
-	if (ns->shm_rmid_forced)
+	if (write && ns->shm_rmid_forced)
 		shm_destroy_orphaned(ns);
 	return err;
 }
_

Patches currently in -mm which might be from shijianlin11@foxmail.com are

ipc-only-destroy-orphaned-shm-segments-on-sysctl-write.patch

