Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E4F192B6E;
	Wed, 26 Jun 2024 19:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719431488; cv=none; b=WnceGI9+Ko2UXxap+BoQN2JvnhkcBWfuLS/+9E8bj9lAaXnSZPLVzcCDQ8VCso4i397qGfd21BdUboUwvRJyKnIqAW58rZXgr4+xt4c2YibBEG6t8BH+jcEKXOqprBuM1z/1AngzksZqojl1baHSA7gfgOCY3OtTOp2FovmObNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719431488; c=relaxed/simple;
	bh=Fspbr2jayhH7PmZCH3vmEFmczEtLE+h+S/9l5cOmVl8=;
	h=Date:To:From:Subject:Message-Id; b=QixDCFipUOAzH4QL3UojC7aMgwrwWebjRtOnFTLxzB+6xmh+9ZBslReAxuVlNLHa4+CBUPYrsA3KkQzdNy/625njbGCGgTvIYMhou7Xx8k2mc6vOXobGSrH+6DeUa8L3ykKQeRFBURZqPwlzuRZYfnV1xzLvecAH7waRFkKVrXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZkrWSZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZkrWSZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D55FC4AF0C;
	Wed, 26 Jun 2024 19:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719431488;
	bh=Fspbr2jayhH7PmZCH3vmEFmczEtLE+h+S/9l5cOmVl8=;
	h=Date:To:From:Subject:From;
	b=eZkrWSZCrXtpYQ/I7a0EKaqullJLIZuFJ0QEIGbeMeei3iWRf1rY19jJMewWU2/JM
	 5MP3XiwB0ST4RMfFJtmsWpAuuKcTRgboeVTlxT3YbT4ZIIuTt7nMLBg3m9lXmyMw09
	 zKcC5xd8INrFjh6n9I38RaooixSmHyNPe2ukTXOA=
Date: Wed, 26 Jun 2024 12:51:27 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,shuah@kernel.org,shli@fb.com,rppt@linux.vnet.ibm.com,raquini@redhat.com,peterx@redhat.com,jack@suse.cz,brauner@kernel.org,aarcange@redhat.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-userfaultfd_api-to-return-einval-as-expected.patch added to mm-hotfixes-unstable branch
Message-Id: <20240626195128.2D55FC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Fix userfaultfd_api to return EINVAL as expected
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fix-userfaultfd_api-to-return-einval-as-expected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-userfaultfd_api-to-return-einval-as-expected.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Audra Mitchell <audra@redhat.com>
Subject: Fix userfaultfd_api to return EINVAL as expected
Date: Wed, 26 Jun 2024 09:05:11 -0400

Currently if we request a feature that is not set in the Kernel config we
fail silently and return all the available features.  However, the man
page indicates we should return an EINVAL.

We need to fix this issue since we can end up with a Kernel warning should
a program request the feature UFFD_FEATURE_WP_UNPOPULATED on a kernel with
the config not set with this feature.

 [  200.812896] WARNING: CPU: 91 PID: 13634 at mm/memory.c:1660 zap_pte_range+0x43d/0x660
 [  200.820738] Modules linked in:
 [  200.869387] CPU: 91 PID: 13634 Comm: userfaultfd Kdump: loaded Not tainted 6.9.0-rc5+ #8
 [  200.877477] Hardware name: Dell Inc. PowerEdge R6525/0N7YGH, BIOS 2.7.3 03/30/2022
 [  200.885052] RIP: 0010:zap_pte_range+0x43d/0x660

Link: https://lkml.kernel.org/r/20240626130513.120193-1-audra@redhat.com
Fixes: e06f1e1dd499 ("userfaultfd: wp: enabled write protection in userfaultfd API")
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/userfaultfd.c~fix-userfaultfd_api-to-return-einval-as-expected
+++ a/fs/userfaultfd.c
@@ -2057,7 +2057,7 @@ static int userfaultfd_api(struct userfa
 		goto out;
 	features = uffdio_api.features;
 	ret = -EINVAL;
-	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+	if (uffdio_api.api != UFFD_API)
 		goto err_out;
 	ret = -EPERM;
 	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
@@ -2081,6 +2081,11 @@ static int userfaultfd_api(struct userfa
 	uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
 	uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
 #endif
+
+	ret = -EINVAL;
+	if (features & ~uffdio_api.features)
+		goto err_out;
+
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
_

Patches currently in -mm which might be from audra@redhat.com are

fix-userfaultfd_api-to-return-einval-as-expected.patch

