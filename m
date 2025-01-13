Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B21B14F9EB
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742147; cv=none; b=svMso4gojlK/fhkOX60GKyvTHZaWMsEdHyHcxTqaLY3yRsMLpdejXfTza6DXfEsje0vsMrWSbARbCYN5LGt397+fZofHvUSi6xuQU/eoJ/I2IpSnZ9vuT6m6ZWHDAHMij9n6aTEI51cD/ByJ7N0tWBKB8//kvmUn9sJkC3I2K+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742147; c=relaxed/simple;
	bh=oxXTGDHXDWkk8Z00woyriu0u7dRJPNImDO8RP489OKE=;
	h=Date:To:From:Subject:Message-Id; b=qrKNq4fy2YZSiM0bq9UuudIZnSK+drPt8js6O/qqh9RZXcnRxc21DX6vUyEhSuJVSD5W2WTidiHv/wfCB+ffQsrbmGLnNTQjCAt6KjfJezgeyI/B7jW1HAt3s0+SLG5NnAQyUoiea22rVUM8nv6hH48uey+6HTpAiK3ce4vUcJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZoOwIZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZoOwIZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF5AC4CED6;
	Mon, 13 Jan 2025 04:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742147;
	bh=oxXTGDHXDWkk8Z00woyriu0u7dRJPNImDO8RP489OKE=;
	h=Date:To:From:Subject:From;
	b=zZoOwIZaomD74Na9+J1QOoStwm0ZPKToJNzkn/6YoD02e4pMKJXKiGmpsi/pVSMlH
	 h+7Y6Jf2wgi1YxEX9YRSEUOj+DluttnM5v5kJIsSKRVE5P5UGxSdE71MGKXL2ErFb4
	 938pX8fPju9tgMALQrra4a5jgQZ+VVSyeA81dCq8=
Date: Sun, 12 Jan 2025 20:22:26 -0800
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,linux@weissschuh.net,joel.granados@kernel.org,avagin@google.com,akpm@linux-foundation.org,mengensun@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch removed from -mm tree
Message-Id: <20250113042227.0CF5AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucounts: move kfree() out of critical zone protected by ucounts_lock
has been removed from the -mm tree.  Its filename was
     ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


