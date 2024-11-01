Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402461CEACE
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730485756; cv=none; b=CFFEFkp/lUzMSZEQk8kDq9joppiSHSrlD1YBZQUqoM5JK6EcRksEupLAL0HYINhOpI+2/4m3VCcwEi07svF5N1sRRP4os/L8K+FaSYB35E/+n+p+GLcFFucxk1/cgq+9QUKgQtXsMuBixiOOJWXSFrtYnwB2s+k+F7nQh317PFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730485756; c=relaxed/simple;
	bh=0/5P0HR69y3C1J0fz8bOLBqX8PNd8mp4ZVpGBcB93AQ=;
	h=Date:To:From:Subject:Message-Id; b=XLEIWuFMMbdI9/38tLPPvRL11ysLOf7krZimk8NsUw/RKqkndqx5+22U9pVZfPHErrVYbMcIOUVMz+S35rHOU+cWLs7h+7phBFbs0KTkWleNBhQKQjCOKxve/fGWamRM4ZI5jlbnerNspJ1JBanWPYDfUV0AA3Ndu481P1S+bSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ooWW6A/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ooWW6A/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD61C4CECD;
	Fri,  1 Nov 2024 18:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730485755;
	bh=0/5P0HR69y3C1J0fz8bOLBqX8PNd8mp4ZVpGBcB93AQ=;
	h=Date:To:From:Subject:From;
	b=ooWW6A/uE4PKRLr0nl89tZI91K2IqHDLB2UMjihtQzEVwlKQb589MXh8B9djb/uwT
	 sliOLO9CfU4s5wysy3UIyk130ZxdXs6xL7G+6DWcKjFcq3O/Uh1MYyc2+GAkOoqsgj
	 RapD2b4bNmqkMv7V3Rc2jFQQ+wRG04QxjdIt5zoI=
Date: Fri, 01 Nov 2024 11:29:15 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-strscpy-instead-of-strcpy.patch added to mm-unstable branch
Message-Id: <20241101182915.BBD61C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: use strscpy() instead of strcpy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-strscpy-instead-of-strcpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-strscpy-instead-of-strcpy.patch

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
From: Maíra Canal <mcanal@igalia.com>
Subject: mm: huge_memory: use strscpy() instead of strcpy()
Date: Fri, 1 Nov 2024 13:54:09 -0300

Replace strcpy() with strscpy() in mm/huge_memory.c

strcpy() has been deprecated because it is generally unsafe, so help to
eliminate it from the kernel source.

Link: https://github.com/KSPP/linux/issues/88
Link: https://lkml.kernel.org/r/20241101165719.1074234-7-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-strscpy-instead-of-strcpy
+++ a/mm/huge_memory.c
@@ -969,7 +969,7 @@ static int __init setup_thp_anon(char *s
 
 	if (!str || strlen(str) + 1 > PAGE_SIZE)
 		goto err;
-	strcpy(str_dup, str);
+	strscpy(str_dup, str);
 
 	always = huge_anon_orders_always;
 	madvise = huge_anon_orders_madvise;
@@ -4167,7 +4167,7 @@ static ssize_t split_huge_pages_write(st
 
 		tok = strsep(&buf, ",");
 		if (tok) {
-			strcpy(file_path, tok);
+			strscpy(file_path, tok);
 		} else {
 			ret = -EINVAL;
 			goto out;
_

Patches currently in -mm which might be from mcanal@igalia.com are

mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch
mm-shmem-control-thp-support-through-the-kernel-command-line.patch
mm-move-get_order_from_str-to-internalh.patch
mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter.patch
mm-huge_memory-use-strscpy-instead-of-strcpy.patch

