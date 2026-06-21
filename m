Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229B454654
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066743; cv=none; b=qTzCqMk/jB+td0AU9h/eCPlUV1/XqOhQGNIDwH+Xn42EyZcXvWf42vpozFnqjhraaM2k2SaU19SeYvGqVfNTjkeAkk99sAJsG0HBCbu9zgNixrWKM2rHmvTKYvKcDX+/GpyOyBAvNsA7+bCsaLuHR4wl1L2V7apKfE5uat7uJhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066743; c=relaxed/simple;
	bh=KlQUjQPa/q6thxByapT4Hy3VQy4hFTRmJ9vOuIPpWbM=;
	h=Date:To:From:Subject:Message-Id; b=hcd0EXho4WTzMnN7MG/TzJruoDXldNjJOF6bnX6nve5Oj/CL+23jp6b3UxVLEl/ha5ncvrp7/tHSxxiZOOIMHHUM52M8pWmX7ang6yWV0RJcM4UVAtxRFJdXe8dF+Gh+aEY54U1T5W2MlIWjrdFvZb5RjchrXn6Un5vnb2S+z5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nENlMwp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nENlMwp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32D61F00A3A;
	Sun, 21 Jun 2026 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066741;
	bh=i/gv2zp2RUNCXlgy0F83xWMvm5PDcaV/RNv2GxTaXHQ=;
	h=Date:To:From:Subject;
	b=nENlMwp92UMSX1DVbkiVRhXh6mawVVU9HPUPFBXC8UdJQwXfyDpJTuikM8IYnfw6Y
	 J/ArlDotCoyq+74y+uzz1EPihZ8ZNAOTbJo90vAkcMnHJu4lDK+pDek8Sql1sYzFzb
	 mBf5O4LamW+0PQmL8KK+hN2L+PvXvhLK4Y6S2Kyo=
Date: Sun, 21 Jun 2026 11:32:21 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,elfring@users.sourceforge.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-simplify-data-output-in-zs_stats_size_show.patch removed from -mm tree
Message-Id: <20260621183221.D32D61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: simplify data output in zs_stats_size_show()
has been removed from the -mm tree.  Its filename was
     zsmalloc-simplify-data-output-in-zs_stats_size_show.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: zsmalloc: simplify data output in zs_stats_size_show()
Date: Thu, 4 Jun 2026 10:20:03 +0200

Move the specification for a line break from a seq_puts() call to a
seq_printf() call.

The source code was transformed by using the Coccinelle software.

Link: https://lore.kernel.org/126a924b-6f68-43bf-ae5a-449fb93e527b@web.de
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-simplify-data-output-in-zs_stats_size_show
+++ a/mm/zsmalloc.c
@@ -565,8 +565,7 @@ static int zs_stats_size_show(struct seq
 		total_freeable += freeable;
 	}
 
-	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s ", "Total", "");
+	seq_printf(s, "\n %5s %5s ", "Total", "");
 
 	for (fg = ZS_INUSE_RATIO_10; fg < NR_FULLNESS_GROUPS; fg++)
 		seq_printf(s, "%9lu ", inuse_totals[fg]);
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are


