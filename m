Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEB01D270A
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 23:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848450; cv=none; b=RvaIykj1bKkLFCJW1VDNK/79PP3x6qx8z1I4qV464Amb9OkgFHEw/PuwlivFc7njPY7dwhhp5Tzv7P7r0CI5yefyz+00Ng5ovJmJ3kZrBKKqb5G/OBDnF6jN74UU+rRidNeOQNs+SBCdXR2s0gObdvxJN+UZjzysZMgpbom6x+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848450; c=relaxed/simple;
	bh=Tg+oUgvRFSE18w7hZfbmBFMGHRZe03N7sEqqqT94IkE=;
	h=Date:To:From:Subject:Message-Id; b=Zfe2xpkeBz5WiO0pwwRvQTme8qio5D2mJkTeUaFgupOnpW7lI8+dnbKi2ki1U40F444a5jq+Aj7u/8LRTE90oM5tGvRcsI2cZKbu3AkMt7xOvjR9aGeurpdmlMP6REz9v7J4WQoa02cBjUo92ZWRkQ8GWW4K7tZPQPi83kqMjRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V/eYM7jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V/eYM7jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DF8C4CECF;
	Tue,  5 Nov 2024 23:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730848449;
	bh=Tg+oUgvRFSE18w7hZfbmBFMGHRZe03N7sEqqqT94IkE=;
	h=Date:To:From:Subject:From;
	b=V/eYM7jkkr0cg3KIwbEg4yQ7VzZI+lxRHTwmKDN5eGr+GgqoLoofg2mRraX/DM07S
	 0gXVcKjX1uIOCufmay7FV+N+Q1toVyohCqFR5Kf8eH6mIOF9smKqrzrwawV8G57bLC
	 80wKs7ACHjvl8QwK3bSaXPeAiyvBpGm8v6GbeP2o=
Date: Tue, 05 Nov 2024 15:14:08 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,geert@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-zram_def_comp-should-depend-on-zram.patch added to mm-unstable branch
Message-Id: <20241105231409.84DF8C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: ZRAM_DEF_COMP should depend on ZRAM
has been added to the -mm mm-unstable branch.  Its filename is
     zram-zram_def_comp-should-depend-on-zram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-zram_def_comp-should-depend-on-zram.patch

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
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: zram: ZRAM_DEF_COMP should depend on ZRAM
Date: Tue, 5 Nov 2024 12:50:35 +0100

When Compressed RAM block device support is disabled, the
CONFIG_ZRAM_DEF_COMP symbol still ends up in the generated config file:

    CONFIG_ZRAM_DEF_COMP="unset-value"

While this causes no real harm, avoid polluting the config file by
adding a dependency on ZRAM.

Link: https://lkml.kernel.org/r/64e05bad68a9bd5cc322efd114a04d25de525940.1730807319.git.geert@linux-m68k.org
Fixes: 917a59e81c342f47 ("zram: introduce custom comp backends API")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

zram-zram_def_comp-should-depend-on-zram.patch

