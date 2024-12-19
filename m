Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665498633D;
	Thu, 19 Dec 2024 03:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577530; cv=none; b=OUjvW1/Ww/ncmjhQZ7WTFJcxhzVLOUYAVSHffOaJO1eooVcT4Y1JBAqPCeSyvqIVdqGGNk66s0u/y+8L1lODduvdHj21LIZYI5kCT+DIoO5wu2TG+5LP/oUKWpBuqQsi0l72VaNaW4c3J6TSFXTiDOADP3CWtzodBS3DojX59XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577530; c=relaxed/simple;
	bh=p1oKNeca3TW2XKfan+uYPMF/JbrX+e9tFBWOF9BNgoE=;
	h=Date:To:From:Subject:Message-Id; b=DjXbyJx8+xd9+CdC1kk9cP7ybzODSL/7m1NyNk/z+a/GnAgpjYiD+wd/GYsaJRkZ/FYt/UzsaPWZNNbEHWoiADLArtTWJBctN+2SIjt2OpYZwweVidHf+chz0UFzChIvESi0tV1jWMngekRL7C4rPBs/FtOsXICykxZvONFv1fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPDTxhNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPDTxhNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE764C4CECD;
	Thu, 19 Dec 2024 03:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577530;
	bh=p1oKNeca3TW2XKfan+uYPMF/JbrX+e9tFBWOF9BNgoE=;
	h=Date:To:From:Subject:From;
	b=xPDTxhNjJqWj9ZDTGshL1V8GDUFGYaN0KnMed6uRbbGu9MpjXt7z3SWLTiVyvincC
	 +17boVSV5ItqdIwMsuAMr7P1cHc2Csb7nmye3U8HpUvLCt5lxQXuLPfpl8/cXkHyYI
	 I29PWoZze/4xv6irUJPgZC9C56xl1dLBZWUR4B6Y=
Date: Wed, 18 Dec 2024 19:05:29 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,deshengwu@tencent.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch removed from -mm tree
Message-Id: <20241219030529.DE764C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: refuse to use zero sized block device as backing device
has been removed from the -mm tree.  Its filename was
     zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch

