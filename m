Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C62E1726
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765851600; cv=none; b=PolPE0KX1IKoSNP4FVCtd8liDIZ6PTyf+lQkyIe6/ZNcmV6jepgXebSHx1kjmvl2h0/Yl599eviCqCis/UpDjjsMl98bWU9nHA2Q7/CZSUgFcc1AieZrxiBQ+SRGZOiKKMG6o6kwXx+nxMoxWWcPRW1wxqSvwr5LdCt+opiF0Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765851600; c=relaxed/simple;
	bh=2UDyFADOrCIkFSYxgzgh6cW/oHrnGfqO1NC9uulD7T4=;
	h=Date:To:From:Subject:Message-Id; b=INV7QLJ95vvNX0/fD612gBrib1UvslN8rD4b6ZCGRMwQy3pg1qzPSh+wB62XdZ4mlox2awSS+F2XbPJHYPs0o5aq4baffubSVpEGEq4hx1H5cfmc/yydVxBCuDxNZ5yE0F3nWM/wmTc0JaFnQ4T+PuKC42L20iinn0nF33aeygI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YOFiPLof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YOFiPLof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5978EC4CEF5;
	Tue, 16 Dec 2025 02:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765851600;
	bh=2UDyFADOrCIkFSYxgzgh6cW/oHrnGfqO1NC9uulD7T4=;
	h=Date:To:From:Subject:From;
	b=YOFiPLofHfEG9St3LhSJaFNME+D4OeX96n+VNyEGiS0M8tbrqfgkiSOfFhjTWI07e
	 F9//d0B/vJwkw3TtbTz+NfZUUOxazm2ZA9D7IIX7Uzjx0oVjqQmYLa0wE+qH07v2se
	 1XZMbaJbpdOwC7kDhv8Mb4plFop05T/2aMgvjSd4=
Date: Mon, 15 Dec 2025 18:19:59 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-document-writeback_batch_size.patch added to mm-new branch
Message-Id: <20251216022000.5978EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: document writeback_batch_size
has been added to the -mm mm-new branch.  Its filename is
     zram-document-writeback_batch_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-document-writeback_batch_size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: document writeback_batch_size
Date: Mon, 1 Dec 2025 18:47:50 +0900

Add missing writeback_batch_size documentation.

Link: https://lkml.kernel.org/r/20251201094754.4149975-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram  |    7 +++++++
 Documentation/admin-guide/blockdev/zram.rst |   11 ++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-block-zram~zram-document-writeback_batch_size
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -157,3 +157,10 @@ Contact:	Richard Chang <richardycc@googl
 Description:
 		The writeback_compressed device atrribute toggles compressed
 		writeback feature.
+
+What:		/sys/block/zram<id>/writeback_batch_size
+Date:		November 2025
+Contact:	Sergey Senozhatsky <senozhatsky@chromium.org>
+Description:
+		The writeback_batch_size device atrribute sets the maximum
+		number of in-flight writeback operations.
--- a/Documentation/admin-guide/blockdev/zram.rst~zram-document-writeback_batch_size
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -214,6 +214,8 @@ mem_limit         	WO	specifies the maxi
 writeback_limit   	WO	specifies the maximum amount of write IO zram
 				can write out to backing device as 4KB unit
 writeback_limit_enable  RW	show and set writeback_limit feature
+writeback_batch_size	RW	show and set maximum number of in-flight
+				writeback operations
 writeback_compressed	RW	show and set compressed writeback feature
 comp_algorithm    	RW	show and change the compression algorithm
 algorithm_params	WO	setup compression algorithm parameters
@@ -223,7 +225,6 @@ backing_dev	  	RW	set up backend storage
 idle		  	WO	mark allocated slot as idle
 ======================  ======  ===============================================
 
-
 User space is advised to use the following files to read the device statistics.
 
 File /sys/block/zram<id>/stat
@@ -447,6 +448,14 @@ this feature, execute::
 Note that this feature should be configured before the `zramX` device is
 initialized.
 
+Depending on backing device storage type, writeback operation may benefit
+from a higher number of in-flight write requests (batched writes).  The
+number of maximum in-flight writeback operations can be configured via
+`writeback_batch_size` attribute.  To change the default value (which is 32),
+execute::
+
+	$ echo 64 > /sys/block/zramX/writeback_batch_size
+
 If admin wants to measure writeback count in a certain period, they could
 know it via /sys/block/zram0/bd_stat's 3rd column.
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch

