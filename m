Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CAE218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189570; cv=none; b=CboqZwUX96ptMZJoOA1ZbxwR4RyPICqiz8uvsGmyHqucrTYWWGsZO2m4AU/tlUTSsXjjGSm6EzZFpYB/KIUvBH3VPWVN3OSxQgGzUrgqHXVo01aY+UasZjiJBHdK5xbD1Uws2TuyQcSaWiK3gDDc4oUg3d8xJIZ7+G0Faouo6NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189570; c=relaxed/simple;
	bh=LKpQ2TrbwhQqb9RW5ofdacg6M/v+scfAT77W1hpUb24=;
	h=Date:To:From:Subject:Message-Id; b=HoT6CB8x71h2o7dRCJixTfJMlsY7W7rlMQvluWjMmIEA/Uqzvd1511RHOLe8NO1lV4ydxmBN7sQ6nuB58Sol7ZgtGuNHdWnDMRbDA2d5Z/6TGlOCbyilQt70ptPiN1ZBlkSSrSCdM190okS7gq5U/W1Js06Lvsak693EfB2DLUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ao4THyCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ao4THyCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1CFC4CEEC;
	Mon, 17 Mar 2025 05:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189570;
	bh=LKpQ2TrbwhQqb9RW5ofdacg6M/v+scfAT77W1hpUb24=;
	h=Date:To:From:Subject:From;
	b=ao4THyCF6BB5/qaXxXtnKM1mJhRRxj7fP5yyDo729DAsNTv9BLcgmGERYMBKzRySe
	 UheJQRdP9pYtesFRU4GJjQ+xgqaQ/PGhQPkBxRw7MGJPeveZR4QfurEMijxja7iFyS
	 XWulXjrH9g27w41hAGiptCqHM4ZfdOG1afnQi+mo=
Date: Sun, 16 Mar 2025 22:32:49 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset.patch removed from -mm tree
Message-Id: <20250317053250.6A1CFC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: signal: avoid clearing TIF_SIGPENDING in recalc_sigpending() if unset
has been removed from the -mm tree.  Its filename was
     signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: signal: avoid clearing TIF_SIGPENDING in recalc_sigpending() if unset
Date: Mon, 3 Mar 2025 14:49:08 +0100

Clearing is an atomic op and the flag is not set most of the time.

When creating and destroying threads in the same process with the pthread
family, the primary bottleneck is calls to sigprocmask which take the
process-wide sighand lock.

Avoiding the atomic gives me a 2% bump in start/teardown rate at 24-core
scale.

[akpm@linux-foundation.org: add unlikely() as well]
Link: https://lkml.kernel.org/r/20250303134908.423242-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/signal.c~signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset
+++ a/kernel/signal.c
@@ -176,9 +176,10 @@ static bool recalc_sigpending_tsk(struct
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current) && !freezing(current))
-		clear_thread_flag(TIF_SIGPENDING);
-
+	if (!recalc_sigpending_tsk(current) && !freezing(current)) {
+		if (unlikely(test_thread_flag(TIF_SIGPENDING)))
+			clear_thread_flag(TIF_SIGPENDING);
+	}
 }
 EXPORT_SYMBOL(recalc_sigpending);
 
_

Patches currently in -mm which might be from mjguzik@gmail.com are


