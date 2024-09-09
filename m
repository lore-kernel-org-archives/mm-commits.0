Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E589018E35E
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925287; cv=none; b=eP1Os5yqOYGGmiua19J7lbZkBseJsQU6GhW94MDPZMY4/BEO0zjeKK6nUP4KfEGTr8rcQtkpgCSgYFJI7abZPstuSO6Z5ZmM4raK38dEsEiauIJ/gNzHP0JxW6d9RB4Ke2f1cPUmTkTvq4YKjP2D9l4qYwUi+QGwNKgUUu/9nE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925287; c=relaxed/simple;
	bh=wsyS/LuJmRjGhRU9U9yPLp0N89jYJTXfeR4qGS1r55Q=;
	h=Date:To:From:Subject:Message-Id; b=J6aKIW1FiqWSZfXRNmgg2gPfZZrTLGY1TAX/L4RJWMBI8v3Nl/zzPeEAI8MkRtMdZQqR3/99sEIKnPOe9tjsP1rwe2GBM1uh62hzZFQcgl5+Z5CaNHkTcqCw2TJ/nnWtscPVnkjrvbIGDkD4Xhn9ZdBVk8DxB906APpdkOVK/LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0+839iXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0+839iXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC238C4CEC6;
	Mon,  9 Sep 2024 23:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925286;
	bh=wsyS/LuJmRjGhRU9U9yPLp0N89jYJTXfeR4qGS1r55Q=;
	h=Date:To:From:Subject:From;
	b=0+839iXnj0V+1H7QwTmKRV+x9GOyzt6vighAhAp+yQBUXFRdQ6An8z6T8V5j08C29
	 1Ft93WsamwXmMeipkbENWAeUQjYaw8rzLaZ5JB8jYpc5vbZZp1SvlpkG0lZvSvN4Am
	 u4hhw7lPGeUvlPhzOTN7XCq4pRYuyE1i71UF8IGg=
Date: Mon, 09 Sep 2024 16:41:26 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-zram-add-documentation-for-algorithm-parameters.patch removed from -mm tree
Message-Id: <20240909234126.BC238C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/zram: add documentation for algorithm parameters
has been removed from the -mm tree.  Its filename was
     documentation-zram-add-documentation-for-algorithm-parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Documentation/zram: add documentation for algorithm parameters
Date: Mon, 2 Sep 2024 19:56:11 +0900

Document brief description of compression algorithms' parameters:
compression level and pre-trained dictionary.

[senozhatsky@chromium.org: trivial fixup]
  Link: https://lkml.kernel.org/r/20240903063722.1603592-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20240902105656.1383858-24-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   47 ++++++++++++++----
 1 file changed, 39 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-zram-add-documentation-for-algorithm-parameters
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -105,7 +105,38 @@ Examples::
 For the time being, the `comp_algorithm` content shows only compression
 algorithms that are supported by zram.
 
-4) Set Disksize
+4) Set compression algorithm parameters: Optional
+=================================================
+
+Compression algorithms may support specific parameters which can be
+tweaked for particular dataset. ZRAM has an `algorithm_params` device
+attribute which provides a per-algorithm params configuration.
+
+For example, several compression algorithms support `level` parameter.
+In addition, certain compression algorithms support pre-trained dictionaries,
+which significantly change algorithms' characteristics. In order to configure
+compression algorithm to use external pre-trained dictionary, pass full
+path to the `dict` along with other parameters::
+
+	#pass path to pre-trained zstd dictionary
+	echo "algo=zstd dict=/etc/dictioary" > /sys/block/zram0/algorithm_params
+
+	#same, but using algorithm priority
+	echo "priority=1 dict=/etc/dictioary" > \
+		/sys/block/zram0/algorithm_params
+
+	#pass path to pre-trained zstd dictionary and compression level
+	echo "algo=zstd level=8 dict=/etc/dictioary" > \
+		/sys/block/zram0/algorithm_params
+
+Parameters are algorithm specific: not all algorithms support pre-trained
+dictionaries, not all algorithms support `level`. Furthermore, for certain
+algorithms `level` controls the compression level (the higher the value the
+better the compression ratio, it even can take negatives values for some
+algorithms), for other algorithms `level` is acceleration level (the higher
+the value the lower the compression ratio).
+
+5) Set Disksize
 ===============
 
 Set disk size by writing the value to sysfs node 'disksize'.
@@ -125,7 +156,7 @@ There is little point creating a zram of
 since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
 size of the disk when not in use so a huge zram is wasteful.
 
-5) Set memory limit: Optional
+6) Set memory limit: Optional
 =============================
 
 Set memory limit by writing the value to sysfs node 'mem_limit'.
@@ -144,7 +175,7 @@ Examples::
 	# To disable memory limit
 	echo 0 > /sys/block/zram0/mem_limit
 
-6) Activate
+7) Activate
 ===========
 
 ::
@@ -155,7 +186,7 @@ Examples::
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-7) Add/remove zram devices
+8) Add/remove zram devices
 ==========================
 
 zram provides a control interface, which enables dynamic (on-demand) device
@@ -175,7 +206,7 @@ execute::
 
 	echo X > /sys/class/zram-control/hot_remove
 
-8) Stats
+9) Stats
 ========
 
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
@@ -277,15 +308,15 @@ a single line of text and contains the f
 		Unit: 4K bytes
  ============== =============================================================
 
-9) Deactivate
-=============
+10) Deactivate
+==============
 
 ::
 
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-10) Reset
+11) Reset
 =========
 
 	Write any positive value to 'reset' sysfs node::
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

