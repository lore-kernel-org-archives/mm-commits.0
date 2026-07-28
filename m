Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEAD3806C2
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785211597; cv=none; b=i1fn6wMmA1VH8UaiC3HsAouPkiv5yy21lyF8sLYV+Wj4NUdupdUt/bT3op38+Zj4OpbnhfOEFyn295YFdnOoGbNshGEHHZmN7rIu0k9LiZvk9Xsj6vQfHKYbUfFTnz4mzAUfYIQT2SGPy6+uaHDVOJrjVLXRThAKDLIG1w/cP1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785211597; c=relaxed/simple;
	bh=5mqeztEzrHPlJ4L9JDfEsG5wHoiRIMKsiS1+Mm/RxLI=;
	h=Date:To:From:Subject:Message-Id; b=ULZTrUfzGEI9Bu8cqbxFAfWMBcX/pYAzVmSNJ6zstAxDjuJ/lviEOhmrEQ1o8mfSfTcxYiMDNkPzXxnvbLmuP69bEKOtLm8bB7WPGHWB59LrdYpvrGkA18M2NtcQeH+9hTXmquPkfgdOWFUdmGdBt0eewHVnVsfptJonS4d4bKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=doqoAA5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="doqoAA5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904731F000E9;
	Tue, 28 Jul 2026 04:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785211595;
	bh=GBawX+ig1Vw9DGz/ItuObBcyIDLIrq/uyiZ6YuajREg=;
	h=Date:To:From:Subject;
	b=doqoAA5RDE3naV1jkHJpdCQLUMBXb243Zc5nhr1F+wb/N8yKT2DinPiGTyI9QaeRU
	 psRBrEUD8+qe1SO9wUxxPG+R7uaUqZCVUZ+lTjiYYUXdyAogNusyleZSVHBMG6NFl5
	 BEogmsFxO6hEWaRu8Im3NHh+Lt+XDvUNMUFHI1TM=
Date: Mon, 27 Jul 2026 21:06:34 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,corbet@lwn.net,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-zram-remove-sections-numbering.patch added to mm-new branch
Message-Id: <20260728040635.904731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: zram: remove sections numbering
has been added to the -mm mm-new branch.  Its filename is
     documentation-zram-remove-sections-numbering.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-zram-remove-sections-numbering.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Documentation: zram: remove sections numbering
Date: Tue, 28 Jul 2026 11:12:11 +0900

Those numbers are difficult to maintain and in fact
we can refer to sections by their names (in html).

Link: https://lore.kernel.org/20260728021229.181627-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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

documentation-zram-remove-sections-numbering.patch

