Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDAC2391A0;
	Wed,  4 Dec 2024 21:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733348941; cv=none; b=mV14QwHC3H60ygcWovZU2w5aSdP324nmU106DrnVVHm0OFg9Xkxgn7A1fPvskbvOeVD5lEipO3ZAnmwqWvvK0w8fPh/e2Km/CV9wUKMcTMuTvhf7DuVYsUMVjXnGJ5FNkXQh9/hGJwa+dZAcHl7A/ZBMilSm7dqGtl4sj86V0VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733348941; c=relaxed/simple;
	bh=P6NIUjOqM5CWx1CaCD7GJ0lLhmeCzFpUgoBSXTYIwqE=;
	h=Date:To:From:Subject:Message-Id; b=tVK4278sg7SlXo6SBM+BVw+9juqyGUUCEFKyFbhYor0G2GzNTUGEYXtrK/KsG9uf7yC/HQl43OxY3xxnnHS4MZ/2mRWNdFjH1upHO8e0bF5hNUuNzqote2ir+RbyD66qydYN/lC9xF6P99gXRZCBGo89Q8mJfTGv+iVdHFtUqcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mWi3Z8yD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mWi3Z8yD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C66C4CEDF;
	Wed,  4 Dec 2024 21:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733348940;
	bh=P6NIUjOqM5CWx1CaCD7GJ0lLhmeCzFpUgoBSXTYIwqE=;
	h=Date:To:From:Subject:From;
	b=mWi3Z8yDzRAdMIr/H8ITUAZgNn6jcZ6LELrSKb4BHO2Ew56f+fYpRYFAkJ9kHH571
	 X9MjLE7IHdxjIS1NupmrB7i7x1tkpHxDo0JOMHUWVvQe8a0coDSE7QnJuuhwRgjj/J
	 LcxXLMbKRX3kcBbIV6gwxdhOMAPPlbE2XKlSwKbw=
Date: Wed, 04 Dec 2024 13:49:00 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,deshengwu@tencent.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-uninitialized-zram-not-releasing-backing-device.patch added to mm-hotfixes-unstable branch
Message-Id: <20241204214900.A9C66C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix uninitialized ZRAM not releasing backing device
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-fix-uninitialized-zram-not-releasing-backing-device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-uninitialized-zram-not-releasing-backing-device.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: zram: fix uninitialized ZRAM not releasing backing device
Date: Thu, 5 Dec 2024 02:02:24 +0800

Setting backing device is done before ZRAM initialization.  If we set the
backing device, then remove the ZRAM module without initializing the
device, the backing device reference will be leaked and the device will be
hold forever.

Fix this by always check and release the backing device when resetting or
removing ZRAM.

Link: https://lkml.kernel.org/r/20241204180224.31069-3-ryncsn@gmail.com
Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Desheng Wu <deshengwu@tencent.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-fix-uninitialized-zram-not-releasing-backing-device
+++ a/drivers/block/zram/zram_drv.c
@@ -2335,6 +2335,9 @@ static void zram_reset_device(struct zra
 	zram->limit_pages = 0;
 
 	if (!init_done(zram)) {
+		/* Backing device could be set before ZRAM initialization. */
+		reset_bdev(zram);
+
 		up_write(&zram->init_lock);
 		return;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch
zram-fix-uninitialized-zram-not-releasing-backing-device.patch

