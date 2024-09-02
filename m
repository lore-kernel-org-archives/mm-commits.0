Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC3C3BBD8
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246689; cv=none; b=TD5oHpuTpSFKXv48m/jjewm68gzAY9LvSVfwCARo11xV25A+OYeRKB1dPvPRjMyorm54nK6sIW+QnYay8MpstseHBNLiiykPgt7BmFin0EmLlpB8OLWOZphmIbLlmOIKTClDvB3quAI/S5OBRy934MA5nGmMkzuWVrcQqiD6JdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246689; c=relaxed/simple;
	bh=zd04iSGWeHUz1qw6l0/S9YnfuFCZx0R9BTN8IrDvUJ0=;
	h=Date:To:From:Subject:Message-Id; b=nYRa49Qpg91tKby1nMEf87z2eG3ogC4rARZtqdZ2e8dYJvlsn4s5qCbz+m5TbtejNGiT4Ow80MuqQH+UitxMazJbWIjnkexpNneKAkfRJMHJOFy+GpMJG9phaczbZdXDHNOxjDXkVMrg9Otqyc0TBbGcYCiEQTujZBdrcoklQrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rD4GScii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rD4GScii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1638DC4CEC3;
	Mon,  2 Sep 2024 03:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246689;
	bh=zd04iSGWeHUz1qw6l0/S9YnfuFCZx0R9BTN8IrDvUJ0=;
	h=Date:To:From:Subject:From;
	b=rD4GSciiaKvSfGTOfyW+oOHYQlU18RIhk65VM0+yJKZWZXgKHkeMYaFBcz5RFGrAf
	 mkNy6+oWZe2DtfkOR3cv4HqHXXERG6DVjwT8n530yTMebRHUsCOGCsoHZ485ZhI5BL
	 7bDHdWUjsQHwWTYdA7tC5mdYRmNDygZIEHRUlTxk=
Date: Sun, 01 Sep 2024 20:11:28 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,flintglass@gmail.com,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix.patch removed from -mm tree
Message-Id: <20240902031129.1638DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix.patch

This patch was dropped because it was folded into mm-zswap-fix-global-shrinker-memcg-iteration.patch

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix
Date: Fri, 2 Aug 2024 21:14:17 -0700

move the spin_lock/unlock() closer to the loop to make the critical
section more obvious, and unify the comments above and below into a single
block.

Link: https://lkml.kernel.org/r/CAJD7tkaScz+SbB90Q1d5mMD70UfM2a-J2zhXDT9sePR7Qap45Q@mail.gmail.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Takero Funaki <flintglass@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix
+++ a/mm/zswap.c
@@ -1335,24 +1335,22 @@ static void shrink_worker(struct work_st
 	 * until the next run of shrink_worker().
 	 */
 	do {
-		spin_lock(&zswap_shrink_lock);
-
 		/*
 		 * Start shrinking from the next memcg after zswap_next_shrink.
 		 * When the offline cleaner has already advanced the cursor,
 		 * advancing the cursor here overlooks one memcg, but this
 		 * should be negligibly rare.
+		 *
+		 * If we get an online memcg, keep the extra reference in case
+		 * the original one obtained by mem_cgroup_iter() is dropped by
+		 * zswap_memcg_offline_cleanup() while we are shrinking the
+		 * memcg.
 		 */
+		spin_lock(&zswap_shrink_lock);
 		do {
 			memcg = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
 			zswap_next_shrink = memcg;
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
-		/*
-		 * Note that if we got an online memcg, we will keep the extra
-		 * reference in case the original reference obtained by mem_cgroup_iter
-		 * is dropped by the zswap memcg offlining callback, ensuring that the
-		 * memcg is not killed when we are reclaiming.
-		 */
 		spin_unlock(&zswap_shrink_lock);
 
 		if (!memcg) {
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-fix-global-shrinker-memcg-iteration.patch

