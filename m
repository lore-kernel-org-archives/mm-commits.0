Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBAB205132
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374587; cv=none; b=NoagTjTOiWjBPOoRAOL5WJlikoqCuUPMjE7FkWGc4biWCoi425FghK1o9OQ3KdjI7VY174gvuo8gNzezDH5Bx29D2eovssB4ssH7y+J4gIT7LHfumn3sZf3otWDqbD1WopvaSXiAr5WiA6ecX0+/XQxlGbL01zdoLsrrOYNLQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374587; c=relaxed/simple;
	bh=ppWVdDQy6QX0TO1oltJP7mVPPcKF8/981Gl6U1cVsXY=;
	h=Date:To:From:Subject:Message-Id; b=LHtya5Cfo1n9SDG80aJWQv795jjpEb0Uzc7v+Q8fSTqNeToHw8CrP/XmaN75MZlUzVd9AX7zpHvWeR2DZn4N/v/zIKSCmlrCJyDO8Z4HIpe66OhfRJNQVMkQe9c7Cr8DzPTBY970jGpEgC+syo1FpV+hmbccJa3aIe/RNY5P7LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=drAx5kN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="drAx5kN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442CBC4CECF;
	Tue, 12 Nov 2024 01:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374587;
	bh=ppWVdDQy6QX0TO1oltJP7mVPPcKF8/981Gl6U1cVsXY=;
	h=Date:To:From:Subject:From;
	b=drAx5kN6u6EdxshD1mMIPJXlEOWtik0ZGe8Cr+6gcPKAUaKe2DkbcUAhcQy64dE8i
	 mD9Hibzxsw5cIEuVM6zrn+x58moeZkxy05XjnpWauya152R1cO1RGSOaiJtSphCifS
	 s3+KIKA4Fto4Cc4OKyzT6nWr+PbS+Ry0xDVb/3A8=
Date: Mon, 11 Nov 2024 17:23:06 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,geert@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-zram_def_comp-should-depend-on-zram.patch removed from -mm tree
Message-Id: <20241112012307.442CBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: ZRAM_DEF_COMP should depend on ZRAM
has been removed from the -mm tree.  Its filename was
     zram-zram_def_comp-should-depend-on-zram.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: zram: ZRAM_DEF_COMP should depend on ZRAM
Date: Tue, 5 Nov 2024 12:50:35 +0100

When Compressed RAM block device support is disabled, the
CONFIG_ZRAM_DEF_COMP symbol still ends up in the generated config file:

    CONFIG_ZRAM_DEF_COMP="unset-value"

While this causes no real harm, avoid polluting the config file by
adding a dependency on ZRAM.

Link: https://lkml.kernel.org/r/64e05bad68a9bd5cc322efd114a04d25de525940.1730807319.git.geert@linux-m68k.org
Fixes: 917a59e81c34 ("zram: introduce custom comp backends API")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/zram/Kconfig~zram-zram_def_comp-should-depend-on-zram
+++ a/drivers/block/zram/Kconfig
@@ -94,6 +94,7 @@ endchoice
 
 config ZRAM_DEF_COMP
 	string
+	depends on ZRAM
 	default "lzo-rle" if ZRAM_DEF_COMP_LZORLE
 	default "lzo" if ZRAM_DEF_COMP_LZO
 	default "lz4" if ZRAM_DEF_COMP_LZ4
_

Patches currently in -mm which might be from geert@linux-m68k.org are


