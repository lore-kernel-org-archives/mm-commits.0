Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043E84687
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 01:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724203668; cv=none; b=TasKOQGs6HmuPDxIkvXRzThj+b+d4mztOxov4qi0XaJZWQVjgBDjw6oleK1J12Lc4XAjGLu3WcyLMDaQDuletbjRi6GlFIiZNZpPCVkhH9q5SRckcni/FPUnsojUzUxGO1NYdDPKNzAgt1iqwje2nmozINTJkRfZ3wVqelFMRFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724203668; c=relaxed/simple;
	bh=S4JDsduh3wuWVaAklDVCPBAWO4ZPmmhovRBxPmFEdfo=;
	h=Date:To:From:Subject:Message-Id; b=AKdFCdMjJ+7TFIqcwc5fvgUqlEBIFhaNTYLktp3StYTtuFN1+wTUc/HhNfgUdw0Z+UGA6wHIB1eRd3nsQZgg6slF39IDeMGwQ3C1E1/WdL7h9FOfLSU8ZcfS2+Dnzjt4viD6slC9ZY4iMPiRzky64nJ8K02RSxkIF9XwORUghmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=txiT48Bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="txiT48Bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC1EC4AF0B;
	Wed, 21 Aug 2024 01:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724203667;
	bh=S4JDsduh3wuWVaAklDVCPBAWO4ZPmmhovRBxPmFEdfo=;
	h=Date:To:From:Subject:From;
	b=txiT48Box4Kc8Ly4/ujuA6AYx+K6cdN+SyQ+VJsV8m6BQ/XnHNu91vyc8BGImiCO6
	 gGlun0nE6k1BEwZbKZ952wsAylgVYrs1gzl1zYTewTr2mta8IhrBnsmMA/fUCadX0x
	 C6IlGRWa8O9UxJhi2csASuSGySUCmQ9WoYr4p53Y=
Date: Tue, 20 Aug 2024 18:27:47 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch added to mm-unstable branch
Message-Id: <20240821012747.AEC1EC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shrinker: use min() to improve shrinker_debugfs_scan_write()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch

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
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: mm: shrinker: use min() to improve shrinker_debugfs_scan_write()
Date: Tue, 20 Aug 2024 06:22:55 +0200

Use the min() macro to simplify the shrinker_debugfs_scan_write() function
and improve its readability.

Link: https://lkml.kernel.org/r/20240820042254.99115-2-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shrinker_debug.c~mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write
+++ a/mm/shrinker_debug.c
@@ -114,7 +114,7 @@ static ssize_t shrinker_debugfs_scan_wri
 	int nid;
 	char kbuf[72];
 
-	read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
+	read_len = min(size, sizeof(kbuf) - 1);
 	if (copy_from_user(kbuf, buf, read_len))
 		return -EFAULT;
 	kbuf[read_len] = '\0';
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

lib-test_hmm-use-min-to-improve-dmirror_exclusive.patch
mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch
lib-checksum-use-array_size-to-improve-assert_setup_correct.patch
ocfs2-use-max-to-improve-ocfs2_dlm_seq_show.patch

