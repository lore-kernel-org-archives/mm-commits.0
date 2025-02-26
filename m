Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F45258CC1
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 08:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740557351; cv=none; b=PVDpK5HipzrB9n1LpGOU/4RfYn+Fi/VRsrE6jq5uAAv+L7XFkEadGVHKr60FqkXj2D4LYvZt/abhGqiWuQZ3QxCKC31PSjmEGgnbaphaL01PVL+snA3vXk8lD4RupHcrcS9wVLe6fmUaRa9//V+9n7cHU52t58ha2svdI6Uj3N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740557351; c=relaxed/simple;
	bh=YDJIY/sb1N5zzPflqfY2DDeLBgz70EUYu4mms2xjw9s=;
	h=Date:To:From:Subject:Message-Id; b=doDa1jHxNRnSOopIUlI5qZI/wgC4I8/MqMjyWID6F4l3fbFJehCZiuNjTAUpoFTCOOgqOQmn8fHyO/WhZnyLMSLJYwaXkONucwAWR+e3P2LZiKXrQU/KnJI8xR/3xEp6+6qNupHH8zrpHjOg7jL2wfuCNeC8Rk0JbQdCPaBwWhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ney4igez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ney4igez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F028BC4CED6;
	Wed, 26 Feb 2025 08:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740557351;
	bh=YDJIY/sb1N5zzPflqfY2DDeLBgz70EUYu4mms2xjw9s=;
	h=Date:To:From:Subject:From;
	b=ney4igezIWYdAkeMY89LmGqMFEdNmj8l4rlmhOaA1ld3gRGhgDwjebDyt2dv2kvHs
	 PE8l6h9n9SNz6cGdI1L69Jj6azaJiArRmSi/C3uWDRvcG6l1lJVSYMON71jrSMBP1f
	 5S44TU14CcLSnKVBf4hQaccL2n8bw2NUsavoAzp8=
Date: Wed, 26 Feb 2025 00:09:10 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,sunk67188@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch added to mm-unstable branch
Message-Id: <20250226080910.F028BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: use ATOMIC_LONG_INIT to initialize zswap_stored_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch

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
From: Sun YangKai <sunk67188@gmail.com>
Subject: mm: zswap: use ATOMIC_LONG_INIT to initialize zswap_stored_pages
Date: Wed, 26 Feb 2025 16:04:09 +0800

This is currently the only atomic_long_t variable initialized by
ATOMIC_INIT macro found in the kernel by using

	grep -r atomic_long_t | grep ATOMIC_INIT

Link: https://lkml.kernel.org/r/20250226080410.10433-1-sunk67188@gmail.com
Signed-off-by: Sun YangKai <sunk67188@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages
+++ a/mm/zswap.c
@@ -43,7 +43,7 @@
 * statistics
 **********************************/
 /* The number of compressed pages currently stored in zswap */
-atomic_long_t zswap_stored_pages = ATOMIC_INIT(0);
+atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
_

Patches currently in -mm which might be from sunk67188@gmail.com are

mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch

