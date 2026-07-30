Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E89342509
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 20:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442735; cv=none; b=DrZt1ByCj2Eg9jF7LpAMeQfS/0gLdGkED/tW5BDavpMc7pj7EBpnz/Wo5Fxr63BCNq3/8aULrTZwq53oys9nuEtIIxH7c4lvh8IdLBSz0TIPSq+T6n81wDE6RX5BVivYags04M52btssQggqe0CMKfyDAXfY0XSZxXGVnyeNhxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442735; c=relaxed/simple;
	bh=roWMw+O8Upzw69lKn4zUpDETT6AXPH3FryeXp7JLwhI=;
	h=Date:To:From:Subject:Message-Id; b=MbCU7muih0R5NPfgyp46lpTMSUalob7Q26gMaS+dVjUTqqebjQZzWl+4TVCVz1zFVqmC7R1cdhUJSlEi1KE9d7oYnkVtDfIp7kCcgsKxfAiYfW1sMJtsdeBtmNMGRfjOjCOHWKVl2ytQuiiuTdWfRdUD7LjpvHcRKYBo1H570bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vvFxdBbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vvFxdBbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23101F000E9;
	Thu, 30 Jul 2026 20:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785442733;
	bh=/BJH3a2Q6nOn2V3FozE4i1fnS8W1i0vwst3F1GoAiVw=;
	h=Date:To:From:Subject;
	b=vvFxdBbxFLexYXwzyGpM9f/bewJ9dH6NEOE65XHfyNWwjqoSc3+jBbMzK5RWw3UiE
	 q/nKTAYprAgWAjzhuMKvbkoRrDkrFTkn9W7IQHqdMW++vXWg1FyG2C9msgkRBX0wYE
	 xs9M2Jin2TuNPB4NLDZ9hJjZgmMsLaBTBl/3FxNQ=
Date: Thu, 30 Jul 2026 13:18:53 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,corbet@lwn.net,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-zram-correct-algo-parameters-configuration-documentation.patch added to mm-unstable branch
Message-Id: <20260730201853.D23101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: zram: correct algo parameters configuration documentation
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-zram-correct-algo-parameters-configuration-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-zram-correct-algo-parameters-configuration-documentation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: Documentation: zram: correct algo parameters configuration documentation
Date: Thu, 30 Jul 2026 16:51:46 +0900

zram has always reset all previously set parameters for the given
algorithm in comp_params_store().  Make documentation more clear and
explicitly state that all relevant/necessary parameters should be set in
one configuration write.

Link: https://lore.kernel.org/20260730075158.1339787-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   34 +++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-zram-correct-algo-parameters-configuration-documentation
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -109,14 +109,41 @@ path to the `dict` along with other para
 	#pass path to pre-trained zstd dictionary
 	echo "algo=zstd dict=/etc/dictionary" > /sys/block/zram0/algorithm_params
 
+	#pass path to pre-trained zstd dictionary and compression level
+	echo "algo=zstd level=8 dict=/etc/dictionary" > \
+		/sys/block/zram0/algorithm_params
+
 	#same, but using algorithm priority
+	echo "algo=zstd priority=1" > /sys/block/zram0/recomp_algorithm
 	echo "priority=1 dict=/etc/dictionary" > \
 		/sys/block/zram0/algorithm_params
 
-	#pass path to pre-trained zstd dictionary and compression level
+Each write to `algorithm_params` replaces the entire set of parameters of
+the corresponding algorithm, parameters that are not listed in the write
+are reset to their default values.  Configure all of the parameters of an
+algorithm in one write::
+
+	#WRONG: the second write resets level back to its default value
+	echo "algo=zstd level=8" > /sys/block/zram0/algorithm_params
+	echo "algo=zstd dict=/etc/dictionary" > /sys/block/zram0/algorithm_params
+
+	#RIGHT
 	echo "algo=zstd level=8 dict=/etc/dictionary" > \
 		/sys/block/zram0/algorithm_params
 
+Select the compression algorithm before configuring its parameters.  The
+parameters of one algorithm are not necessarily valid for another one, so
+changing the algorithm of a particular priority resets that priority's
+parameters::
+
+	#WRONG: comp_algorithm write resets the previously configured level
+	echo "level=8" > /sys/block/zram0/algorithm_params
+	echo zstd > /sys/block/zram0/comp_algorithm
+
+	#RIGHT
+	echo zstd > /sys/block/zram0/comp_algorithm
+	echo "algo=zstd level=8" > /sys/block/zram0/algorithm_params
+
 Parameters are algorithm specific: not all algorithms support pre-trained
 dictionaries, not all algorithms support `level`. Furthermore, for certain
 algorithms `level` controls the compression level (the higher the value the
@@ -124,6 +151,11 @@ better the compression ratio, it even ca
 algorithms), for other algorithms `level` is acceleration level (the higher
 the value the lower the compression ratio).
 
+Parameters are handed over to the compression algorithm when the device is
+initialised, hence invalid parameters (or parameters that the selected
+algorithm does not support) are reported by the `disksize` write, and not
+by the `algorithm_params` write that has configured them.
+
 Set Disksize
 ============
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

documentation-zram-remove-sections-numbering.patch
zram-set-default-primary-compressor-in-zram_destroy_comps.patch
zram-validate-deflate-params.patch
documentation-zram-correct-algo-parameters-configuration-documentation.patch

