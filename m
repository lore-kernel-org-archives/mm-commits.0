Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326AB372B50
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622949; cv=none; b=rgnn59lNfS66cIle3O0/kpdA5vxjTP2oOOTmO4A6El1HW90VNg3G+vqER9RsTe8CS/STLsVcuoaDbTsYay04oRnbxR7XsgHSgMk4php17NR2yV8MOdyXbV6j2cZfu56aVuVBEw15bxfDzTcZ8/BUas2hDf1YirJwjtTbwYpwLAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622949; c=relaxed/simple;
	bh=Q/+6drtuHzCmPuI+JoX98E/oAfkiLZF7BjTc6YOT08o=;
	h=Date:To:From:Subject:Message-Id; b=WKTYtRxEKIly55tJ9sIGSMn5Oa/q0EePN5uKtkbF1lF6GsPfksaNvPb+PwC7YR4lwAErsKzWB+7rwu1vfY0tcdhGJCZDwscN8C4Dagdk/KP5PYBlndou2wvH6vM3O/q+5q+RZVf/0SVfnA0oTZXHY8Y0ctD2rbmn6SdYaefAXD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rlM2MoPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rlM2MoPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F384A1F000E9;
	Tue, 25 Aug 2026 01:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622948;
	bh=5186pengw5h7fd4//jfeQO8a0vsTcmlVpOFYubc0EO0=;
	h=Date:To:From:Subject;
	b=rlM2MoPiTjWPpc9sihduxKzdE+iqqCG91+x8SSSxuWFRlb02OaHrjcyAPIM6ZCKFp
	 a3EiLun4AB8/zXTmbTYX2RkOMOjUBcJlctanoiUn5CRnVFzdr2cmbmAiYfKRdn/laM
	 T+qQo8mENzUEDmJR/CJOvmPBCX0tNvESGOHClass=
Date: Mon, 24 Aug 2026 18:55:47 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,lkp@intel.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch removed from -mm tree
Message-Id: <20260825015547.F384A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hmm.c:hmm_do_fault(): suppress sparse warning
has been removed from the -mm tree.  Its filename was
     mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hmm.c:hmm_do_fault(): suppress sparse warning
Date: Mon Aug 10 01:16:37 PM PDT 2026

mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Stanislav says this can't happen.  Waste a few cycles to make the warning
go away.

[akpm@linux-foundation.org: WARN_ON_ONCE() if the handler didn't set ->locked, per Stanislav]
  Link: https://lore.kernel.org/anu1N-DOnQwxO1kF@skinsburskii
Fixes: 121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202608101053.PhnVUM4u-lkp@intel.com
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-hmm_do_fault-suppress-sparse-warning
+++ a/mm/hmm.c
@@ -670,7 +670,10 @@ static int hmm_do_fault(struct mm_struct
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			*hmm_vma_walk->locked = false;
+			if (hmm_vma_walk->locked)    /* needed by sparse */
+				*hmm_vma_walk->locked = false;
+			else
+				WARN_ON_ONCE(1);    /* broken fault handler */
 			return HMM_FAULT_UNLOCKED;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

