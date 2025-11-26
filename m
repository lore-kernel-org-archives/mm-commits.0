Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AEB343207;
	Wed, 26 Nov 2025 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764178871; cv=none; b=d61tb1zdiJ0GzAMCVy+iZqTvos7eijmzK9m9jNa9Af35ztG3oz0azqkvTxoC7yeCabUy9h9s/UuxqKjZZSz0Ye+XByYZRTWqlryESOS8yPdKCYCZ6MSQ4nOkga+XGh/+AB5XSvUT57qkmP2tdya/mA7OELAjuWopG1VlA1T9QKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764178871; c=relaxed/simple;
	bh=WXWUhEIvdbridsqfFqGqok8+I7bhOODXxOKbf3qUHTU=;
	h=Date:To:From:Subject:Message-Id; b=mrSfXWEpjUqy1u+u+1f97pLm7t5Tqn3URj8R2wFz2EbmW2Q5gsf9EgwGAouNjO7cgJdYcpApSadkHU7ZeTInJQ/LT17C5OI9ZllIi1g7Kur64Kv2DzJNmZ0e988nALned3oAY+Ga+t85pnTqrtg3dj6PZDstWSKBxSse4de3e8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MhGraYit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MhGraYit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1D2C4CEF7;
	Wed, 26 Nov 2025 17:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764178870;
	bh=WXWUhEIvdbridsqfFqGqok8+I7bhOODXxOKbf3qUHTU=;
	h=Date:To:From:Subject:From;
	b=MhGraYithh75N9uL5uM6tHXooksQjpBVYOngOOSbOv6rT8dA7l1GmIEwGApe+szt9
	 Nn7N+n0uvQ16I1hKyj8KKwtruGks24XZe2Ob9dFbG5dmYuVUfmS1cEnyeZLHywvkg+
	 7zGIN9Hn5DtyZTBaRqb39YdALzkcL9Inm8UCehWA=
Date: Wed, 26 Nov 2025 09:41:10 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-pseries-cmm-call-balloon_devinfo_init-also-without-config_balloon_compaction.patch added to mm-new branch
Message-Id: <20251126174110.9A1D2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
has been added to the -mm mm-new branch.  Its filename is
     powerpc-pseries-cmm-call-balloon_devinfo_init-also-without-config_balloon_compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-pseries-cmm-call-balloon_devinfo_init-also-without-config_balloon_compaction.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
Date: Tue, 21 Oct 2025 12:06:05 +0200

Patch series "powerpc/pseries/cmm: two smaller fixes".

Two smaller fixes identified while doing a bigger rework.


This patch (of 2):

We always have to initialize the balloon_dev_info, even when compaction is
not configured in: otherwise the containing list and the lock are left
uninitialized.

Likely not many such configs exist in practice, but let's CC stable to
be sure.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251021100606.148294-1-david@redhat.com
Link: https://lkml.kernel.org/r/20251021100606.148294-2-david@redhat.com
Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/cmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/cmm.c~powerpc-pseries-cmm-call-balloon_devinfo_init-also-without-config_balloon_compaction
+++ a/arch/powerpc/platforms/pseries/cmm.c
@@ -550,7 +550,6 @@ static int cmm_migratepage(struct balloo
 
 static void cmm_balloon_compaction_init(void)
 {
-	balloon_devinfo_init(&b_dev_info);
 	b_dev_info.migratepage = cmm_migratepage;
 }
 #else /* CONFIG_BALLOON_COMPACTION */
@@ -572,6 +571,7 @@ static int cmm_init(void)
 	if (!firmware_has_feature(FW_FEATURE_CMO) && !simulate)
 		return -EOPNOTSUPP;
 
+	balloon_devinfo_init(&b_dev_info);
 	cmm_balloon_compaction_init();
 
 	rc = register_oom_notifier(&cmm_oom_nb);
_

Patches currently in -mm which might be from david@redhat.com are

powerpc-pseries-cmm-call-balloon_devinfo_init-also-without-config_balloon_compaction.patch
powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages.patch

