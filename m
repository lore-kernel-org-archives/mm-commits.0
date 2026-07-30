Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB94831A807;
	Thu, 30 Jul 2026 00:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785372207; cv=none; b=HpTO7lT5AQFE1AoWfvb0tZWMQ50b27d18gYRZS1DE68U/EriV+pEmXI85HjMEgGv0WhvWt67DOQupPsPDqjcvrbtcXcCdq/jg0VPTVd04knoY0I8aRdjIpkaS6Y8/q9sTIjU8PgQdT4QyrBIqpZNSAI6UBBAStJJ5c372xaMQLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785372207; c=relaxed/simple;
	bh=B+XNrHkc/kM1y/IBeJU+KnZsHiTLSR2VYRwoHlNUVkU=;
	h=Date:To:From:Subject:Message-Id; b=u3NVxqOPt33ggsNc56AjUdJRC3VcyurcyeMc3YnFZUX17Z8F0Jo6w5KenzDml21PZmbcpZyUWiuqI2QSogrLuPabqYP28+UkYlQ1hkx91BsWnxlgHo5dqe3HQnXe/VnQBSJ8b/vQ2cR/h7j6b/ANXezllFRJvMlGeuappCxrDlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c60/tV99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c60/tV99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEFF1F000E9;
	Thu, 30 Jul 2026 00:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785372206;
	bh=Nl5Y4bJAvi3jkfxwzlmhI5NoU9BgpWNB0MPjCCUbcD0=;
	h=Date:To:From:Subject;
	b=c60/tV99t1eyt88LUHqLW3b8yccgz1v3OYQ0bZYjNzXFpRHg+d/OrvYpnKEFEuRff
	 vmCiP143/vLHaZnF4wGjTtMi4mq2R4N3So0iWnAbBjXUaUOPh4QpyEg46gZgyyBLQ0
	 Ul4GDBJL6TfjymbjvKHmbCLNxEtDrh0mfe6GzsTc=
Date: Wed, 29 Jul 2026 17:43:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,haoqinhuang7@gmail.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-validate-deflate-params.patch added to mm-new branch
Message-Id: <20260730004326.7FEFF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: validate deflate params
has been added to the -mm mm-new branch.  Its filename is
     zram-validate-deflate-params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-validate-deflate-params.patch

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
Subject: zram: validate deflate params
Date: Wed, 29 Jul 2026 13:57:36 +0900

We must validate user-supplied deflate winbits before we pass it to
zlib_deflate_workspacesize(), which triggers BUG_ON() if winbits value is
outside of valid ranges.

Link: https://lore.kernel.org/20260729045745.775973-3-senozhatsky@chromium.org
Fixes: dc75a0d93bd5 ("zram: support deflate-specific params")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_deflate.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/backend_deflate.c~zram-validate-deflate-params
+++ a/drivers/block/zram/backend_deflate.c
@@ -24,8 +24,16 @@ static int deflate_setup_params(struct z
 {
 	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = Z_DEFAULT_COMPRESSION;
-	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET)
+	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET) {
 		params->deflate.winbits = DEFLATE_DEF_WINBITS;
+	} else {
+		s32 wb = params->deflate.winbits;
+
+		if ((wb < -15 || wb > -9) && (wb < 9 || wb > 15)) {
+			pr_err("invalid deflate winbits: %d\n", wb);
+			return -EINVAL;
+		}
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

documentation-zram-remove-sections-numbering.patch
zram-set-default-primary-compressor-in-zram_destroy_comps.patch
zram-validate-deflate-params.patch

