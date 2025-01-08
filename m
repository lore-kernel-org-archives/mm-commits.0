Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCA219F117
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736305230; cv=none; b=dH8jBOyiZdXh7yNKDRmmxqJdXZ3caZOVdPKTdmsJaXxuv36ugycE8YefHDio8hYKPwHdhAArLKNULD70jk+ZUmVRgYydytEIadPMgZgIEkNWMQMktxH+O72R+Hb562pyKmts8R721mtepyHSnR2ev/WsKsjgJMIc/srk2W9W4lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736305230; c=relaxed/simple;
	bh=pH3ipvafTMyJQaqZ3Slct8VKmc47OGZYnY4/rkaMy0Y=;
	h=Date:To:From:Subject:Message-Id; b=QjKX561Y4EV2vFkYf+QgYw9ub4P6QV0UBa3JLBKXqtzjCaQsPm/l03OUqWzpLBvtlorJSRBvKIkMOK+5LDc6aIz9ndyOD6zEJ5Zge0s61hJGvSePb5XkYLzKc7IoVcTTkm+0rL8aSXLEUqoPg9DSYuJCvX9aI83iB49uEkVjOgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NMiXPpSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NMiXPpSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD3DC4CED6;
	Wed,  8 Jan 2025 03:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736305229;
	bh=pH3ipvafTMyJQaqZ3Slct8VKmc47OGZYnY4/rkaMy0Y=;
	h=Date:To:From:Subject:From;
	b=NMiXPpSAkEvDhY6vZrSZHvYTQlBEJqddC5h2HTX7GZxWPlFmwhwILrvcVbyN4HvVh
	 MPn2TFchKikyaNiSizB7OR48NKovktpjx0IVPyxnvSRh6TbZN9h2Rnj92sA+QWjzS+
	 MzZOIVP4ONNmJuMXX78V5UBHUFcVb7ClQESCBoWI=
Date: Tue, 07 Jan 2025 19:00:28 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,willy@infradead.org,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250108030029.7FD3DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2
Date: Tue, 7 Jan 2025 17:47:23 -0800


check for -EINVAL in bdi_set_min_bytes() and bdi_set_max_bytes()

Link: https://lkml.kernel.org/r/20250108014723.166637-1-shr@devkernel.io
Reported-by: cheung wall <zzqq0103.hey@gmail.com>
Closes: https://lore.kernel.org/linux-mm/87pll35yd0.fsf@devkernel.io/T/#t
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page-writeback.c~mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2
+++ a/mm/page-writeback.c
@@ -799,6 +799,8 @@ int bdi_set_min_bytes(struct backing_dev
 		return ret;
 
 	min_ratio = bdi_ratio_from_pages(pages);
+	if (min_ratio == -EINVAL)
+		return -EINVAL;
 	return __bdi_set_min_ratio(bdi, min_ratio);
 }
 
@@ -818,6 +820,8 @@ int bdi_set_max_bytes(struct backing_dev
 		return ret;
 
 	max_ratio = bdi_ratio_from_pages(pages);
+	if (max_ratio == -EINVAL)
+		return -EINVAL;
 	return __bdi_set_max_ratio(bdi, max_ratio);
 }
 
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch
mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch

