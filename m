Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BF11A2644
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311947; cv=none; b=fKQ2PF+weDHwNYmYwqQXzs0yHlheCrN/mHgbRNkoRcwFdtGjwaRl46C/u1p0RZQBc/DQmpvuiASOp8VSH6qf/N2pozmnSybZjuHME6WIlymWZeM/xx9eE7b5U69tcS9LyCbk/P2b/fq8Y3jB+94tIaz9QaWHYc17VociHULVLEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311947; c=relaxed/simple;
	bh=sVRKSnxFz8lz/35cA8oJE/tzIhgXDHEK8n+2UmAjCJ4=;
	h=Date:To:From:Subject:Message-Id; b=Xfm/WYRHFRiqXYNdUfqF9Denc2CDqhVE0X6SD9zxvKnFJmbhvM/t6m15dVNJchYAw7MyvapLqmq2lc8tIIOZKnz3+esmpX8eAA7anPpToYHd9B7PzNudCqgDebkOuJyifo48zb7fAvP2O3tGnGwm5HC5eCKTQ7uzzOyrPUP52kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YAZeVZoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YAZeVZoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94D3C4CEC2;
	Mon,  2 Sep 2024 21:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311946;
	bh=sVRKSnxFz8lz/35cA8oJE/tzIhgXDHEK8n+2UmAjCJ4=;
	h=Date:To:From:Subject:From;
	b=YAZeVZoCt8pQO2wDm3Y6C/8tNe0CLBzURSvOScBv13spDQv46pcbMSA1B/BVoVVCq
	 YUwbkNBCx33AoA0x5Y3FtlmmPnrvvCDEK+g72y4ESQDedOVrEK5lES4YAaa13hL8TJ
	 uFlQTsY6vnm+3afsRwBC3kXPEV71mWyUFpf51oVk=
Date: Mon, 02 Sep 2024 14:19:06 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-zram-add-documentation-for-algorithm-parameters.patch added to mm-unstable branch
Message-Id: <20240902211906.B94D3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/zram: add documentation for algorithm parameters
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-zram-add-documentation-for-algorithm-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-zram-add-documentation-for-algorithm-parameters.patch

This patch will later appear in the mm-unstable branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Documentation/zram: add documentation for algorithm parameters
Date: Mon, 2 Sep 2024 19:56:11 +0900

Document brief description of compression algorithms' parameters:
compression level and pre-trained dictionary.

Link: https://lkml.kernel.org/r/20240902105656.1383858-24-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   45 +++++++++++++++---
 1 file changed, 38 insertions(+), 7 deletions(-)

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
@@ -277,7 +308,7 @@ a single line of text and contains the f
 		Unit: 4K bytes
  ============== =============================================================
 
-9) Deactivate
+10) Deactivate
 =============
 
 ::
@@ -285,7 +316,7 @@ a single line of text and contains the f
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-10) Reset
+11) Reset
 =========
 
 	Write any positive value to 'reset' sysfs node::
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

lib-zstd-export-api-needed-for-dictionary-support.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch
zram-introduce-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_params-structure.patch
zram-recalculate-zstd-compression-params-once.patch
zram-introduce-algorithm_params-device-attribute.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch
zram-support-priority-parameter-in-recompression.patch

