Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EF520E031;
	Wed, 25 Jun 2025 20:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750884005; cv=none; b=cvKbKKsyUyRm55O1pJhpjO3OClt6EttUnSLDUGLQmgWrehJcaB1ARy4XRUt2yTasBNAJME2sQt9SAhlLlqDY2eSf69eSNq0eHLmIpjP0o4SFUWDyQG6WM09KcuztTKVGjBn6KaNMnOj7AFKtSLBA0qrWhYey2vijf0gXzcOA0yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750884005; c=relaxed/simple;
	bh=ozkF1RQtxWQSwdTh9X1qYOTAsbxBp1f5irTjsPEMmW0=;
	h=Date:To:From:Subject:Message-Id; b=g367yuQRHlVuR4n0Pvf1tnnHPtvy6g3Pz9BeEgkn5d8YaBipGikUjhqt0knNdfgi5PIQkS3fV83xXpwzQd3BTdA1038u0YVrZGSungrHyncVOVUn5icEOXGTx1T16lwHaYpNcMFGeoI7n2tyz+jCiNzocl6gDrAIaDaS81V8MGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j3kzPxW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3kzPxW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC09C4CEEA;
	Wed, 25 Jun 2025 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750884004;
	bh=ozkF1RQtxWQSwdTh9X1qYOTAsbxBp1f5irTjsPEMmW0=;
	h=Date:To:From:Subject:From;
	b=j3kzPxW40+y0DXg/USw2QJfvZpPnpZz0cOs3rWMtfJVPOzymXX+mhdRrj7f3DAmzY
	 FTanetEPuK+wFIO3yuGo4OUsXEV75JXR9QVG/k5FurtoVaM4IslmwQOTzvVBMkoSMA
	 5uHu4uVWs9+Y3XJI3lq7/s5NQWY6FjnlL/7HSqk8=
Date: Wed, 25 Jun 2025 13:40:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,bertranddrouvot.pg@gmail.com,apopple@nvidia.com,myon@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-do_pages_stat-to-use-compat_uptr_t.patch added to mm-hotfixes-unstable branch
Message-Id: <20250625204004.9DC09C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate.c: fix do_pages_stat to use compat_uptr_t
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fix-do_pages_stat-to-use-compat_uptr_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-do_pages_stat-to-use-compat_uptr_t.patch

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
From: Christoph Berg <myon@debian.org>
Subject: mm/migrate.c: fix do_pages_stat to use compat_uptr_t
Date: Wed, 25 Jun 2025 17:24:14 +0200

For arrays with more than 16 entries, the old code would incorrectly
advance the pages pointer by 16 words instead of 16 compat_uptr_t.

Link: https://lkml.kernel.org/r/aFwUnu7ObizycCZ8@msg.df7cb.de
Signed-off-by: Christoph Berg <myon@debian.org>
Suggested-by: Bertrand Drouvot <bertranddrouvot.pg@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~fix-do_pages_stat-to-use-compat_uptr_t
+++ a/mm/migrate.c
@@ -2444,7 +2444,13 @@ static int do_pages_stat(struct mm_struc
 		if (copy_to_user(status, chunk_status, chunk_nr * sizeof(*status)))
 			break;
 
-		pages += chunk_nr;
+		if (in_compat_syscall()) {
+			compat_uptr_t __user *pages32 = (compat_uptr_t __user *)pages;
+
+			pages32 += chunk_nr;
+			pages = (const void __user * __user *) pages32;
+		} else
+			pages += chunk_nr;
 		status += chunk_nr;
 		nr_pages -= chunk_nr;
 	}
_

Patches currently in -mm which might be from myon@debian.org are

fix-do_pages_stat-to-use-compat_uptr_t.patch

