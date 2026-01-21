Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6B335CB6D
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966025; cv=none; b=s95q7Cc3UfkWoO5r7k6uWxNHksRNilo5au3fNQIBb22siPlckr+vZam3v1wY9c/xQkWyDXLteTvik6yg1FMx4JVhy+qZpVP3LTSkRnetP82KFe+KhHy3gSeoGGOkezS0tvTzz5ov68bgs89O+Wm2GOr+zwa21OXE82/TE8yK09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966025; c=relaxed/simple;
	bh=RMZyUmVP8L0RQoC9Vgw6qTAsZPCQ043+1LLeHsu5P74=;
	h=Date:To:From:Subject:Message-Id; b=SbGa/CTi5+aq3llo72/7kRNmZ83iQRhAnaBVWwS9wNYNvJWX4lvWgFZt2mBCi1RDGknW9wKxTVjkjkv9UR3SwJp7EyEXwDjGxwTbplcyhZhQbsc53wrR7rjelEdaY9t4e/0+PieKG8jalQ39WKP54R2u2+nVmZj22XkoORbMLio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mGJ6acSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mGJ6acSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FABC16AAE;
	Wed, 21 Jan 2026 03:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966024;
	bh=RMZyUmVP8L0RQoC9Vgw6qTAsZPCQ043+1LLeHsu5P74=;
	h=Date:To:From:Subject:From;
	b=mGJ6acSu7QsDDKD28yKHo2X+lSttEuTOE0LrQ/v3r0Y6NNJUt2a69tPO8JWVOoIwX
	 4mzmm6c1Yf4gxRJchMvNMaN/vsGN5IuVp4EnwveMrw902dQJ95wAav81gJ5ekeuDiV
	 guTY8Q5p5Sbsc5KPTbaKvVOF2UyJ1nNtOZzA7n8o=
Date: Tue, 20 Jan 2026 19:27:04 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-document-writeback_batch_size.patch removed from -mm tree
Message-Id: <20260121032704.D6FABC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: document writeback_batch_size
has been removed from the -mm tree.  Its filename was
     zram-document-writeback_batch_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

