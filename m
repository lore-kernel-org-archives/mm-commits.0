Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195083C09F7
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068164; cv=none; b=m60vb89rq6EF+GuMJx4OWxSX588T2omjS2tMEumopB5aNI1ehEyZA1mZylarTPj/tN3lUry2vcqHCjPeqetlrRSHUuOx1bl5Ya1aNGBviIudiAYXplzMbptlf/KPW2xcnfx0/7TbdzTefRIFMJ5EuDr4KHWfVs8nBqhJMF1RBLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068164; c=relaxed/simple;
	bh=waOX5C3GMHhKu4MW2LwU6x68rPbIMQick6RCtibYjAg=;
	h=Date:To:From:Subject:Message-Id; b=LhT2irU9+EMTzPWM+dUTRpYaeJJ6IkVX/ITD7EZ++KnjJdDU0kaFpT8R9DkzpvAwFN0HghZ/Ai2zYhp6NKnEtEgcMKJPdcbbMMgOUEDudhSAMU68cTC8upev1jOwfR3Xk3aJngInGpMbnT4TE/wxjY8TlW1ie5w/BDVnkfqiX6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z92M+CdB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z92M+CdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836DD1F00A3A;
	Fri,  7 Aug 2026 02:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068162;
	bh=uh1Nuzmp8Xm9RTYRiEZKBABupfCkwjoPaWPE7+rkqYY=;
	h=Date:To:From:Subject;
	b=z92M+CdBxHq/V5eJg/rIc7qRcSdi2w47Wc+sqOx2Lu4Hq/SlPNieJ1aJARXvSiyJc
	 3MVctoTG1Yx2Chkf7UPpJKGo+9T//LaZ8XYn8J4od3ZLYKkCYCKTXgzvRpKZBhOIKe
	 dIaPSIXaDblTZTM9cUyCp05SBQJnbptob145qd10=
Date: Thu, 06 Aug 2026 19:02:42 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,minchan@kernel.org,corbet@lwn.net,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-zram-remove-sections-numbering.patch removed from -mm tree
Message-Id: <20260807020242.836DD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: zram: remove sections numbering
has been removed from the -mm tree.  Its filename was
     documentation-zram-remove-sections-numbering.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Documentation: zram: remove sections numbering
Date: Tue, 28 Jul 2026 11:12:11 +0900

Those numbers are difficult to maintain and in fact
we can refer to sections by their names (in html).

Link: https://lore.kernel.org/20260728021229.181627-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   40 +++++++++---------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-zram-remove-sections-numbering
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -61,8 +61,8 @@ and, in general case, something like::
 
 should suffice.
 
-1) Load Module
-==============
+Load Module
+===========
 
 ::
 
@@ -73,8 +73,8 @@ This creates 4 devices: /dev/zram{0,1,2,
 num_devices parameter is optional and tells zram how many devices should be
 pre-created. Default: 1.
 
-2) Select compression algorithm
-===============================
+Select compression algorithm
+============================
 
 Using comp_algorithm device attribute one can see available and
 currently selected (shown in square brackets) compression algorithms,
@@ -93,8 +93,8 @@ Examples::
 For the time being, the `comp_algorithm` content shows only compression
 algorithms that are supported by zram.
 
-3) Set compression algorithm parameters: Optional
-=================================================
+Set compression algorithm parameters: Optional
+==============================================
 
 Compression algorithms may support specific parameters which can be
 tweaked for particular dataset. ZRAM has an `algorithm_params` device
@@ -124,8 +124,8 @@ better the compression ratio, it even ca
 algorithms), for other algorithms `level` is acceleration level (the higher
 the value the lower the compression ratio).
 
-4) Set Disksize
-===============
+Set Disksize
+============
 
 Set disk size by writing the value to sysfs node 'disksize'.
 The value can be either in bytes or you can use mem suffixes.
@@ -144,8 +144,8 @@ There is little point creating a zram of
 since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
 size of the disk when not in use so a huge zram is wasteful.
 
-5) Set memory limit: Optional
-=============================
+Set memory limit: Optional
+==========================
 
 Set memory limit by writing the value to sysfs node 'mem_limit'.
 The value can be either in bytes or you can use mem suffixes.
@@ -163,8 +163,8 @@ Examples::
 	# To disable memory limit
 	echo 0 > /sys/block/zram0/mem_limit
 
-6) Activate
-===========
+Activate
+========
 
 ::
 
@@ -174,8 +174,8 @@ Examples::
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-7) Add/remove zram devices
-==========================
+Add/remove zram devices
+=======================
 
 zram provides a control interface, which enables dynamic (on-demand) device
 addition and removal.
@@ -194,8 +194,8 @@ execute::
 
 	echo X > /sys/class/zram-control/hot_remove
 
-8) Stats
-========
+Stats
+=====
 
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
 
@@ -296,16 +296,16 @@ a single line of text and contains the f
 		Unit: 4K bytes
  ============== =============================================================
 
-9) Deactivate
-==============
+Deactivate
+==========
 
 ::
 
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-10) Reset
-=========
+Reset
+=====
 
 	Write any positive value to 'reset' sysfs node::
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-set-default-primary-compressor-in-zram_destroy_comps.patch
zram-validate-deflate-params.patch
documentation-zram-correct-algo-parameters-configuration-documentation.patch
zram-switch-to-unsigned-long-indexing.patch

