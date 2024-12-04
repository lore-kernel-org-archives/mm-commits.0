Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB0B18C900;
	Wed,  4 Dec 2024 21:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733348940; cv=none; b=S5JThKE24qeIWWXqVHvZwNiQxQETL8TA+5ZmzGnCfjVwKPWmevbqhi3iswQOVrc3CBCgMvBORDzVT1AxRuMv9tP0lNz/Jo000IbIT1CrVfx6zLgCgUbhXJtLH4mZLPSVfa2Qk/vPIw/BWYzhBSOpEaHoZYN4eR/9aX2QBACJD6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733348940; c=relaxed/simple;
	bh=35iTGkrXWrjYC67ZrxlborUE0oRYDRPXho2jVcFF1Ws=;
	h=Date:To:From:Subject:Message-Id; b=svROSKYIeJ4KuAbJ673aXYLxom35dtCBy2WVs7UkAJ8pusJVb6P044ijy0/LxUoYbFlgJ04nUfDhZ//RblYf3fRXHKVoJDnTwTeD659BuvPLGM/NFH2ztBC64g5ij0Bqz+TqkCCi6Vsvlu6gumAk3FtAiU0+ewPlK7uWkrSJtpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cow6RH0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cow6RH0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7123BC4CECD;
	Wed,  4 Dec 2024 21:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733348939;
	bh=35iTGkrXWrjYC67ZrxlborUE0oRYDRPXho2jVcFF1Ws=;
	h=Date:To:From:Subject:From;
	b=Cow6RH0xeZi7eW74UxPWn3eQ/NPiiUBJBlsnkeQf/TVuyERL3i3P+LszobZFW8Jts
	 Fa6btR3cNBcyXRKV1kQ+rlZ20dB2VNMtI6wkTFOSME5DPM7JdxrzPtgAuZQsieh8sd
	 KSPu6Mj3MLjP1J8v5RgF/t/6vggSqH9/KFJfL2dw=
Date: Wed, 04 Dec 2024 13:48:58 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,deshengwu@tencent.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch added to mm-hotfixes-unstable branch
Message-Id: <20241204214859.7123BC4CECD@smtp.kernel.org>
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
Date: Thu, 5 Dec 2024 02:02:23 +0800

Patch series "zram: fix backing device setup issue".

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

Link: https://lkml.kernel.org/r/20241204180224.31069-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20241204180224.31069-2-ryncsn@gmail.com
Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Desheng Wu <deshengwu@tencent.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

