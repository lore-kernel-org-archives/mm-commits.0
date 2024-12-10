Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4020641C64;
	Tue, 10 Dec 2024 01:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733795869; cv=none; b=YQKW5woMDIcxOfS7Lm93EMz4Ct0ilzq46Dz9lx8McBLkjA+iDVNxGYYlO6PScJ7+o/8xO6cgfGJrasXT7I+MDQa38/dsl+CmJzpK4jBjaNWqLCC2T7DEM1ysn5vny+Xcfq58p4tfe+PaseB3bAJUmLjVXmbAGFlPjGs24jdVS3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733795869; c=relaxed/simple;
	bh=U5ssiB5H02E9VimE9BIqWx26rlVNNDNOjqi4UqsNVd0=;
	h=Date:To:From:Subject:Message-Id; b=rYip7hw5EQca3IrSVqyHwHJ09+CmU3hFlq++DtnkqPIza+6h2Ns+NaDGUupovFIckF/r9Xy5CZ14gdCNF4x8oFrysYMHe9ZobVlt9FQhve1sqpRJ3lRPYSW2pwfnYWw5RPZXBUXmze/lH6PhlU0tsRHVt1tm7x/d2mhvulH7jj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xe/kozEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xe/kozEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9181CC4CED1;
	Tue, 10 Dec 2024 01:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733795868;
	bh=U5ssiB5H02E9VimE9BIqWx26rlVNNDNOjqi4UqsNVd0=;
	h=Date:To:From:Subject:From;
	b=Xe/kozEKvZmZE6W8WCxSsWjAuSp+ujzFZJCdfU9MRJNG2Sh74OT2QQtJUEgZRGlOc
	 +zkctyfTN3tabiV7Kd1ilGz+VvLONBXcc1P3ueYMgqYV8EeRwE1uQZvKMq6ack4Fbo
	 PKW1FPoQpIHH2GktcTEyungDcx8Bv5dzUCYt+hL0=
Date: Mon, 09 Dec 2024 17:57:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,deshengwu@tencent.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch added to mm-hotfixes-unstable branch
Message-Id: <20241210015748.9181CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: refuse to use zero sized block device as backing device
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch

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
Subject: zram: refuse to use zero sized block device as backing device
Date: Tue, 10 Dec 2024 00:57:15 +0800

Patch series "zram: fix backing device setup issue", v2.

This series fixes two bugs of backing device setting:

- ZRAM should reject using a zero sized (or the uninitialized ZRAM
  device itself) as the backing device.
- Fix backing device leaking when removing a uninitialized ZRAM
  device.


This patch (of 2):

Setting a zero sized block device as backing device is pointless, and one
can easily create a recursive loop by setting the uninitialized ZRAM
device itself as its own backing device by (zram0 is uninitialized):

    echo /dev/zram0 > /sys/block/zram0/backing_dev

It's definitely a wrong config, and the module will pin itself, kernel
should refuse doing so in the first place.

By refusing to use zero sized device we avoided misuse cases including
this one above.

Link: https://lkml.kernel.org/r/20241209165717.94215-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20241209165717.94215-2-ryncsn@gmail.com
Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Desheng Wu <deshengwu@tencent.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-refuse-to-use-zero-sized-block-device-as-backing-device
+++ a/drivers/block/zram/zram_drv.c
@@ -614,6 +614,12 @@ static ssize_t backing_dev_store(struct
 	}
 
 	nr_pages = i_size_read(inode) >> PAGE_SHIFT;
+	/* Refuse to use zero sized device (also prevents self reference) */
+	if (!nr_pages) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	bitmap_sz = BITS_TO_LONGS(nr_pages) * sizeof(long);
 	bitmap = kvzalloc(bitmap_sz, GFP_KERNEL);
 	if (!bitmap) {
_

Patches currently in -mm which might be from kasong@tencent.com are

zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch
zram-fix-uninitialized-zram-not-releasing-backing-device.patch

