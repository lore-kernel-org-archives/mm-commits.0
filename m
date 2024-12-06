Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73911E871
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733447433; cv=none; b=XpQpypnO9CWpTyyJsV1RAibgXG235dNKvhu4k3DET4+hskjvUOEoiNKunQSvpZamU2Pwwp5xkFrUaHvdDAoxBQu6ElFWWQlUTmrwKRGahXuO34ZlbpfkXk13tFlnxZCkfoU5GPAXYO+vAs5N3nKq1qWJnZ6ML25GmjZIkEC/Q7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733447433; c=relaxed/simple;
	bh=ZvIxtY4FB+gTolmiECbtKmLz89BGfWfeybVDf5qn3Wc=;
	h=Date:To:From:Subject:Message-Id; b=iWCjmcuyc7mmd7qFlei1lfD8TG6FQcGNIj/fbXktJHVHgjR89AD+jtm/X+/FLBrbihFD0NYkNYA2TUOlAULWK1m6wUR7Ha/D++24bhjhk5i8dnEk66iWeZzh+GJQn0yHDcVmXq8WUzwP/hwlOe55RVtJRmYfnd74QZnHmWpNPAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s2EspGo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s2EspGo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E886C4CED1;
	Fri,  6 Dec 2024 01:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733447433;
	bh=ZvIxtY4FB+gTolmiECbtKmLz89BGfWfeybVDf5qn3Wc=;
	h=Date:To:From:Subject:From;
	b=s2EspGo6PQpiDSI9XR1/NMULUS2A/exXaZHPWpzwIgFn/SErVs3wE0gblij/Jl6iQ
	 +MXKJmaDjeJGudWq3lyZjERJaAYLNVZFAspmF2q1gJSwu0pMIVsUmi8xF3TBbfrnn5
	 a55ObCV+QOcZ01ZI11ptl+JorI98HCHztW/bjVM0=
Date: Thu, 05 Dec 2024 17:10:32 -0800
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,linux@weissschuh.net,joel.granados@kernel.org,avagin@google.com,mengensun@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch removed from -mm tree
Message-Id: <20241206011033.4E886C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucounts: move kfree() out of critical zone protected by ucounts_lock
has been removed from the -mm tree.  Its filename was
     ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch

This patch was dropped because an updated version will be issued

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


