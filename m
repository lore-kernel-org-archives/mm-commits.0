Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F6C1D5CE0
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 00:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768697114; cv=none; b=BM3wOSemTtmrCMbVHsqckvWhQ/z+RpKbO9Tm/3vxP5GyrHEKyfsnn73p4m4OBtUTT7sysTB8LEFxzLkYbnJeBrIyfPp9eEX8jfBPbhxM+slINCwplJNcRnRceBdUDrbKQ2vHQJKBOMzvv0du9u5lkfviYwNnPN9Pvd9bK6AW1wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768697114; c=relaxed/simple;
	bh=jD0bNKxEyShjLQU9y9wXc3h4IL6cWV3EgOhA/mAb+48=;
	h=Date:To:From:Subject:Message-Id; b=Rz/OyP1V/ETz4Xj8RzzPoG1ltftwpFJlu2g9VGeEErhg/tKp3PhnwdmsGkubKUMuo031FqOisO8n3ayPL119p6rLTWt3nPMWxcQ7DaKkBPi57nlCQP67wDTSihP+7bxi1VvFqDrSooIzs9rmDorh8pcHaqgIC1ctM6VMwsC7LqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M5biVJMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M5biVJMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE735C4CEF7;
	Sun, 18 Jan 2026 00:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768697113;
	bh=jD0bNKxEyShjLQU9y9wXc3h4IL6cWV3EgOhA/mAb+48=;
	h=Date:To:From:Subject:From;
	b=M5biVJMsGPA/BIsgrZBXStErpTyVSFxF9RRNVguY8X5+kxTHFIT6u9PxFb52wfDPT
	 +d+zbuOJgfYpPyeNdzqGjmy2z8g+CJqhWdqFTkvoyiSxzn37QG9DQJrhMRnr3tYAUn
	 jcojDAYAp9k3Os2V9IAfUZCOrWw/GYAcxfWogmKk=
Date: Sat, 17 Jan 2026 16:45:13 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,maainnewkin59@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-kernel-doc-for-__swap_cache_clear_shadow.patch added to mm-new branch
Message-Id: <20260118004513.AE735C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update kernel-doc for __swap_cache_clear_shadow()
has been added to the -mm mm-new branch.  Its filename is
     mm-update-kernel-doc-for-__swap_cache_clear_shadow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-kernel-doc-for-__swap_cache_clear_shadow.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Taeyang Kim <maainnewkin59@gmail.com>
Subject: mm: update kernel-doc for __swap_cache_clear_shadow()
Date: Sat, 17 Jan 2026 19:14:28 +0900

The kernel-doc comment referred to swap_cache_clear_shadow(), but the
actual function name is __swap_cache_clear_shadow().

Update the comment to match the function name.

Link: https://lkml.kernel.org/r/20260117101428.113154-1-maainnewkin59@gmail.com
Signed-off-by: Taeyang Kim <maainnewkin59@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-update-kernel-doc-for-__swap_cache_clear_shadow
+++ a/mm/swap_state.c
@@ -352,7 +352,7 @@ void __swap_cache_replace_folio(struct s
 }
 
 /**
- * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
+ * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
  * @entry: The starting index entry.
  * @nr_ents: How many slots need to be cleared.
  *
_

Patches currently in -mm which might be from maainnewkin59@gmail.com are

mm-update-kernel-doc-for-__swap_cache_clear_shadow.patch

