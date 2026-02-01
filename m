Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57803EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905026; cv=none; b=MSgHRnjZ8Ex0NDrbnYON6R4ynDGtl68byVJk79SpwWjs4eN6hQBEsbao1jpWHIzx6j5UXU6qc7okVOs+NNsM5R8tdDMGA2ZJGo0OgfZIaF349LFC7A0fS/740tUxD8x+NxMux3mQAGPfMUzBATwPLZC6an6hvACVNho2EFQwvA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905026; c=relaxed/simple;
	bh=Wmo1w5RNmngWkTpl+HaTSH5qRrBaFlXDp1A0U0u8GMM=;
	h=Date:To:From:Subject:Message-Id; b=a14C4wTcQxzruEsIe+Ckf2pJ3LHf48nIBbZQcYRUqmKzE9AFL6vRYqmeLzoo6hpx7RUH2cOGBl5Xx/FO4gwVioD04/JUVn9UmbigHgdSiRYBA8p1VWu7PXaDkNjbC5WhMvREBYhcjd4ifSBdxZX0/7jtiMlvAQn3tF9VsSvKPP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BQyqSB2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQyqSB2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE66C4CEF1;
	Sun,  1 Feb 2026 00:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905025;
	bh=Wmo1w5RNmngWkTpl+HaTSH5qRrBaFlXDp1A0U0u8GMM=;
	h=Date:To:From:Subject:From;
	b=BQyqSB2ZNss9tDxq23vC+wcLEu3sjkGIM7VJTHiHHFA4xwz0CKAlYFjhIPDhid907
	 uWJukAcAPDV4NdipCBZ91jB29q8bVoAkWBm2kt1QrZBDxrlU/mdo7ui5G3rbfZet3N
	 u1hRJjhjujXKbv+f+41nNJPcUq2E+xxEp+oCzEvM=
Date: Sat, 31 Jan 2026 16:17:05 -0800
To: mm-commits@vger.kernel.org,serge@hallyn.com,paul@paul-moore.com,legion@kernel.org,ebiederm@xmission.com,omosnace@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ucount-check-for-cap_sys_resource-using-ns_capable_noaudit.patch removed from -mm tree
Message-Id: <20260201001705.BCE66C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()
has been removed from the -mm tree.  Its filename was
     ucount-check-for-cap_sys_resource-using-ns_capable_noaudit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Paul Moore <paul@paul-moore.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>
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


