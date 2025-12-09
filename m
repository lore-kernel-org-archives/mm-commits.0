Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19695285C96;
	Tue,  9 Dec 2025 19:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308377; cv=none; b=ilra+TYs/7LcpG4pZlTPbUf1q6D8T/uAGoNxZOtxIl8s4RITmdpzlSN7aXMFM3ZIhe5PbC9kECzFRxAQG+9sZ3Wd8nFMxgSZWno9s3oHZjHx0FGFWm39EERKD3AGPqEddoh/SHwt7JqetGOnLPGlBiFFMB1Espz6S4QfacyIVdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308377; c=relaxed/simple;
	bh=TcV9sXbDM7/kFYV4np2XOrJWvyJfqCyHg572pDdc0II=;
	h=Date:To:From:Subject:Message-Id; b=mT9m7qwiVgqYhEomJMHiD+S6BcJxVvOYlKpE9o57e7316IR0feq0xbvh4o2y2HskPSg2aHHYRJqX5QTpG7f7TLJmY5pH9XEjZyYMBInB5sDlx/ff/ThwK33dt35zI+Vxe6T8CAk3TktsM9uOPszvz5Oc9aQamDBB/RvzDMpVOUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2TdD4Ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2TdD4Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A38C4CEF5;
	Tue,  9 Dec 2025 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308376;
	bh=TcV9sXbDM7/kFYV4np2XOrJWvyJfqCyHg572pDdc0II=;
	h=Date:To:From:Subject:From;
	b=x2TdD4IkDzIg/z/f4ESw6KKNGRzJV0iITpeamoR4pmjbEbb47o8V9V1vuVaICEZxu
	 dO1tSmuTMynZ7bb9oiK+pJF2uZyGCF+yyYg0hiYSmhWkT4Ruua0/ZBAOVc+mKpomh8
	 87JrudCcJ8Ka9SSMP95+nw22s6FzFSzmmkIOhkeg=
Date: Tue, 09 Dec 2025 11:26:15 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ritesh.list@gmail.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-pseries-cmm-call-balloon_devinfo_init-also-without-config_balloon_compaction.patch removed from -mm tree
Message-Id: <20251209192616.93A38C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
has been removed from the -mm tree.  Its filename was
     powerpc-pseries-cmm-call-balloon_devinfo_init-also-without-config_balloon_compaction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
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


