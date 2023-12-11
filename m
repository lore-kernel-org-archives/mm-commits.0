Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513F93C21
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z36GW0Ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7EDC433C7;
	Mon, 11 Dec 2023 00:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256073;
	bh=ei+tbcoqgivKOGJNbvba8iReBmBxym2D3mZ7EbHV+ek=;
	h=Date:To:From:Subject:From;
	b=Z36GW0EpK20anfnPQ20HTMXeBw3GusbsBjLy4FG3Yt3Xv+4jc6Pe2wrWQjKExLrMN
	 oS7gCbWxQFmlJi9/bk1fF7nONKeHZaz/5xqMnZPj9hx3pY19u0bCAKyqh+3qdc8Yod
	 4U92SFdWdXTQDrKq//WnXUA4YlgrsUmAD5ty63sU=
Date: Sun, 10 Dec 2023 16:54:32 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,dmaluka@chromium.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-tweak-writeback-config-help.patch removed from -mm tree
Message-Id: <20231211005433.1B7EDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: tweak writeback config help
has been removed from the -mm tree.  Its filename was
     zram-tweak-writeback-config-help.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: tweak writeback config help
Date: Wed, 15 Nov 2023 11:42:13 +0900

Writeback is for incompressible and idle zram pages.

Link: https://lkml.kernel.org/r/20231115024223.4133148-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dmytro Maluka <dmaluka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-tweak-writeback-config-help
+++ a/drivers/block/zram/Kconfig
@@ -59,8 +59,8 @@ config ZRAM_WRITEBACK
        bool "Write back incompressible or idle page to backing device"
        depends on ZRAM
        help
-	 With incompressible page, there is no memory saving to keep it
-	 in memory. Instead, write it out to backing device.
+	 This lets zram entries (incompressible or idle pages) be written
+	 back to a backing device, helping save memory.
 	 For this feature, admin should set up backing device via
 	 /sys/block/zramX/backing_dev.
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

checkpatch-do-not-require-an-empty-line-before-error-injection.patch

