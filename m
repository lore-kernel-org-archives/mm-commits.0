Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53662581
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 06:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733554227; cv=none; b=uX1OS2dXm8f0n8Q6QB0mR0gJdLGax58GOuYMFxV7BL+yKApAgMzMu36gcBmubbyX65aaOQOR1mdnPB6ponkYknUuVPKBQ6CGXK1TlnFE5RJil+plEETo+TpN6NKhKrGAuE0hD77NtRnciak4RSTJ8WdA9d6lEPWmpGd8ghbs/6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733554227; c=relaxed/simple;
	bh=aQyC0GHW8bmhO46triyQBbBxlzG5FKzsc0GYexXzs0A=;
	h=Date:To:From:Subject:Message-Id; b=M9Y+zzCCqyidGM1z66rcYSzUsbiIrr7yYwWSLGTnht/1KilmKMmooFdpi5Li7aV0TU6b9grrsQXDsas/UzMooXwuHfhR01k+5vGBS3Yh3vUFOzHjtlXyaHCq8rQ+EVprjHNInggnpALU1y0db5eEmd8inKr+zAOBbGWYTh7jfAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sEd49APl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sEd49APl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1C5C4CECD;
	Sat,  7 Dec 2024 06:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733554225;
	bh=aQyC0GHW8bmhO46triyQBbBxlzG5FKzsc0GYexXzs0A=;
	h=Date:To:From:Subject:From;
	b=sEd49APlFhxmuTrkjvXZhHHnW5jhV8t4AK5igNfOo+LwAsov4KH1Cz+POn7yiGX9W
	 lMf1rXr0shxCAnXHrIYoYtCuUbKGCl5dc8uo665DfOrROyLVQ//l5Erm95bsEgkvli
	 /jOr7JaeoXq5TkQcRazF6Y489UFOskxi6ofvkVeM=
Date: Fri, 06 Dec 2024 22:50:24 -0800
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,linux@weissschuh.net,joel.granados@kernel.org,avagin@google.com,akpm@linux-foundation.org,mengensun@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20241207065025.3C1C5C4CECD@smtp.kernel.org>
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
Date: Fri, 6 Dec 2024 12:13:47 +0800

Although kfree is a non-sleep function, it is possible to enter a long
chain of calls probabilistically, so it looks better to move kfree from
alloc_ucounts() out of the critical zone of ucounts_lock.

Link: https://lkml.kernel.org/r/1733458427-11794-1-git-send-email-mengensun@tencent.com
Signed-off-by: MengEn Sun <mengensun@tencent.com>
Reviewed-by: YueHong Wu <yuehongwu@tencent.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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

