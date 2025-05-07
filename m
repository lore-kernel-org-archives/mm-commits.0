Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D84228C5A0;
	Wed,  7 May 2025 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746641298; cv=none; b=hHB5qjf9kkOZrdmGx09Z5Ul5kEI/mvhXrkGSn7a4QGZMs6VugXT9uMSlstimbAg2jz+fhkjIP68g1vbGmM7jF7/pHbL3UllIQykcjHy84hLdHQW0vSF/BMsERjyYo3Xz9s6XH7FTlc+Myxc9RWiMVnkfwKtbjDpLWgZ74DXXZBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746641298; c=relaxed/simple;
	bh=AyFfV8PRMm91vUTLaV/n2eajiVTgi7IyqbfpFM3rdaI=;
	h=Date:To:From:Subject:Message-Id; b=FXg6bQ4jjwjb7p0wLmoBqovU4pmo40CskqRsbryblwRV0cck1KIykRdXviTlY3DU0drmu8biCQY5qB1IpOCjDDgYZbgRqxFeKF+xFewjK3IQJR/ogVGuvs2lrnayFEkewKX1A6SZiSOdPy9M23Q38P+jKzM4rvKRXDgZLZEVlww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OjmiFY9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OjmiFY9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E7FC4CEE9;
	Wed,  7 May 2025 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746641297;
	bh=AyFfV8PRMm91vUTLaV/n2eajiVTgi7IyqbfpFM3rdaI=;
	h=Date:To:From:Subject:From;
	b=OjmiFY9S/uT/hckOWTfIUh54JJDy4nZou4GMVy5/FMDpgWT9y/HQzBpbNjiotoszK
	 9KuYZvCf9nB7kuwDs9WBdJweQWX940thbLgyi9R5ogPBCcym7dIKn6HoDxApTKB1fE
	 JWJSrKZ4doaiSSuWqtE/bKh8nNt5MpIK/J+1MEec=
Date: Wed, 07 May 2025 11:08:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-signedness-error-for-gcc-54.patch added to mm-hotfixes-unstable branch
Message-Id: <20250507180817.C7E7FC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: avoid signedness error for GCC 5.4
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-avoid-signedness-error-for-gcc-54.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-signedness-error-for-gcc-54.patch

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
From: WangYuli <wangyuli@uniontech.com>
Subject: mm: vmscan: avoid signedness error for GCC 5.4
Date: Wed, 7 May 2025 12:08:27 +0800

To the GCC 5.4 compiler, (MAX_NR_TIERS - 1) (i.e., (4U - 1)) is unsigned,
whereas tier is a signed integer.

Then, the __types_ok check within the __careful_cmp_once macro failed,
triggered BUILD_BUG_ON.

Use min_t instead of min to circumvent this compiler error.

Fix follow error with gcc 5.4:
  mm/vmscan.c: In function `read_ctrl_pos':
  mm/vmscan.c:3166:728: error: call to `__compiletime_assert_887' declared with attribute error: min(tier, 4U - 1) signedness error

Link: https://lkml.kernel.org/r/62726950F697595A+20250507040827.1147510-1-wangyuli@uniontech.com
Fixes: 37a260870f2c ("mm/mglru: rework type selection")
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-signedness-error-for-gcc-54
+++ a/mm/vmscan.c
@@ -3163,7 +3163,7 @@ static void read_ctrl_pos(struct lruvec
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier % MAX_NR_TIERS; i <= min_t(int, tier, MAX_NR_TIERS - 1); i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

mm-vmscan-avoid-signedness-error-for-gcc-54.patch
ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch
treewide-fix-typo-previlege.patch

