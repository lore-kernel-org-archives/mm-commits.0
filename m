Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5942119
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 04:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733373341; cv=none; b=ZVA/wp+r/vLYkbdPrWaYko0aADl2tTe6W8vvexJ3xbcl/TlQnZLI/2RLJ/WhaPCa6eOt9iDwE1kSeRWUs6WkyPxLmirdoKQnXrfoJsvpSI4yvIPJyeRbEQgxTCk8i+RRkVbt+XJX2PW7NPO/KHfoJ1IZs/930vh+ndfD/LUNF/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733373341; c=relaxed/simple;
	bh=qoYyx5IBY+MUY2Az+bcAjNQD4dthpH/h/AA+WgyeS9c=;
	h=Date:To:From:Subject:Message-Id; b=pJyZ9vcqRBVaTwjKiLOi/K/HmyCk+cB00frSXz7OBGwjaQnf+sJSCwAZIafb3Pi/FZypIXAiUFmPsJ2HHR9FhsjYMwk3J7QP0dWUJyUnmNW4XYpRy7xswtMKzSx3O3bGqI68gtMU9CH7x9JEDwnLL5VxX4dAiXDI/E9pHj6YPKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h65mEcWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h65mEcWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1078BC4CED6;
	Thu,  5 Dec 2024 04:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733373341;
	bh=qoYyx5IBY+MUY2Az+bcAjNQD4dthpH/h/AA+WgyeS9c=;
	h=Date:To:From:Subject:From;
	b=h65mEcWqCFt2HskUKEAGMvPFEp0vu2JA+ap/LVelVUu69JW//Ngu8XzPIQxLB0PrP
	 2bPs7D94xd92G6Jx88nkTVylzpxSXWgnOs2Z19iCRNaGutGeZmhSI6f4I1kzC7FjwR
	 MjBDfkFltz2Ncv6GVpGAeeJt9QXMDduPfYslo1w0=
Date: Wed, 04 Dec 2024 20:35:40 -0800
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,linux@weissschuh.net,joel.granados@kernel.org,avagin@google.com,mengensun@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20241205043541.1078BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucounts: move kfree() out of critical zone protected by ucounts_lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: MengEn Sun <mengensun@tencent.com>
Subject: ucounts: move kfree() out of critical zone protected by ucounts_lock
Date: Mon, 2 Dec 2024 22:32:45 +0800

Although kfree is a non-sleep function, it is possible to enter a long
chain of calls probabilistically, so it looks better to move kfree from
alloc_ucounts() out of the critical zone of ucounts_lock.

Link: https://lkml.kernel.org/r/1733149965-749-1-git-send-email-mengensun@tencent.com
Signed-off-by: MengEn Sun <mengensun@tencent.com>
Reviewed-by: YueHong Wu <yuehongwu@tencent.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/ucount.c~ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock
+++ a/kernel/ucount.c
@@ -164,8 +164,8 @@ struct ucounts *get_ucounts(struct ucoun
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
-	struct ucounts *ucounts, *new;
 	bool wrapped;
+	struct ucounts *ucounts, *new = NULL;
 
 	spin_lock_irq(&ucounts_lock);
 	ucounts = find_ucounts(ns, uid, hashent);
@@ -182,17 +182,17 @@ struct ucounts *alloc_ucounts(struct use
 
 		spin_lock_irq(&ucounts_lock);
 		ucounts = find_ucounts(ns, uid, hashent);
-		if (ucounts) {
-			kfree(new);
-		} else {
+		if (!ucounts) {
 			hlist_add_head(&new->node, hashent);
 			get_user_ns(new->ns);
 			spin_unlock_irq(&ucounts_lock);
 			return new;
 		}
 	}
+
 	wrapped = !get_ucounts_or_wrap(ucounts);
 	spin_unlock_irq(&ucounts_lock);
+	kfree(new);
 	if (wrapped) {
 		put_ucounts(ucounts);
 		return NULL;
_

Patches currently in -mm which might be from mengensun@tencent.com are

ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch

