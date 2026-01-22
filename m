Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8141939CEE3
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769098153; cv=none; b=eKbFlhRXrwsvOVD98g3905Pn0oGSB8BLWmrTj/S8ckDYYVRxYcoNFOaw5pEh8MuqVB6lzOExFa0vfPyaGxF42fVBb6s2CBhQXXv2wdV/yZgC0BUU2YHbxH3KuzNy09L1Lckl7SFPv+1ofBNpsQQv1mA3luG9INxt0S8u7VNTtng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769098153; c=relaxed/simple;
	bh=8x7wDzlaho+SUvdEHaxS6ezf2VYFleqAzmqzv9NRtUs=;
	h=Date:To:From:Subject:Message-Id; b=R1zk0oQexB9uLaMGqfeFa9L3bBKrzBr2hIjgUWAD0j+2PNAOYaF4e/2kg/mtsEAZPV6hhrUVQoKxdpcztvVv4OwzhJ/upze5iqQQ4pTN4Xcp1zcPTyW2bkthd1S+c5d0BmJH7QJO0XVoVzeo8l+7rAt+R9oUK24+jdaSuoq+qYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LB9vxVvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LB9vxVvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B84C116C6;
	Thu, 22 Jan 2026 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769098152;
	bh=8x7wDzlaho+SUvdEHaxS6ezf2VYFleqAzmqzv9NRtUs=;
	h=Date:To:From:Subject:From;
	b=LB9vxVvHgc9f9Vrs9yzK/pr8JC8JCNZkXP57HETGSigqBhDb7BVJ5F8sKxM7urmci
	 2j+X9+NWLLVr1VZFYFWMt7urZw1dzFU4kZBag6JYAg+DPkHsJwYPj2nZoam9qmYeGd
	 WWWlZcOvWyqlvtKiGf8YUKy8Pjx1CJbnoMaHky5U=
Date: Thu, 22 Jan 2026 08:09:12 -0800
To: mm-commits@vger.kernel.org,serge@hallyn.com,legion@kernel.org,ebiederm@xmission.com,omosnace@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucount-check-for-cap_sys_resource-using-ns_capable_noaudit.patch added to mm-nonmm-unstable branch
Message-Id: <20260122160912.91B84C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ucount-check-for-cap_sys_resource-using-ns_capable_noaudit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucount-check-for-cap_sys_resource-using-ns_capable_noaudit.patch

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
From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()
Date: Thu, 22 Jan 2026 15:07:45 +0100

The user.* sysctls implement the ctl_table_root::permissions hook and they
override the file access mode based on the CAP_SYS_RESOURCE capability (at
most rwx if capable, at most r-- if not).  The capability is being checked
unconditionally, so if an LSM denies the capability, an audit record may
be logged even when access is in fact granted.

Given the logic in the set_permissions() function in kernel/ucount.c and
the unfortunate way the permission checking is implemented, it doesn't
seem viable to avoid false positive denials by deferring the capability
check.  Thus, do the same as in net_ctl_permissions() (net/sysctl_net.c) -
switch from ns_capable() to ns_capable_noaudit(), so that the check never
logs an audit record.

Link: https://lkml.kernel.org/r/20260122140745.239428-1-omosnace@redhat.com
Fixes: dbec28460a89 ("userns: Add per user namespace sysctls.")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/ucount.c~ucount-check-for-cap_sys_resource-using-ns_capable_noaudit
+++ a/kernel/ucount.c
@@ -47,7 +47,7 @@ static int set_permissions(struct ctl_ta
 	int mode;
 
 	/* Allow users with CAP_SYS_RESOURCE unrestrained access */
-	if (ns_capable(user_ns, CAP_SYS_RESOURCE))
+	if (ns_capable_noaudit(user_ns, CAP_SYS_RESOURCE))
 		mode = (table->mode & S_IRWXU) >> 6;
 	else
 	/* Allow all others at most read-only access */
_

Patches currently in -mm which might be from omosnace@redhat.com are

ipc-dont-audit-capability-check-in-ipc_permissions.patch
ucount-check-for-cap_sys_resource-using-ns_capable_noaudit.patch

