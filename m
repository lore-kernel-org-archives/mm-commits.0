Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25A28F5C
	for <mm-commits@vger.kernel.org>; Mon,  1 Apr 2024 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991825; cv=none; b=CZlnhQmgOuYo0MgPrgo3vZx9SL/HMeLM/7xogcad7ij5H8dNS2Zp4rgnbNpI9x0rICS0ZONcc1tLhmaxxNXaDkZ5zss82ElJCWgOwPBamA/nuQ48pdVlmPXC/1mJb14aR7nFPDxeFbdIQS0vrXJCkQOVVZdU3DhvQo0E5CqMTlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991825; c=relaxed/simple;
	bh=qaOUxaaKNEiktLLPEin3HNDBeJS1c4Oz2wEGIXg091c=;
	h=Date:To:From:Subject:Message-Id; b=rUJL0nqJ42fthkMxtTeNOVG2pQcfZN63gi/w4r1z1erqqRl/XoZsF7Vp2Et3HwBtHDxFdBnuYZ3IUov9Ie8jiwKBgoRTbRQeX4nfQ455taahtFxHSiFuEVu4OzKoHXR8OEhwUuJfwsgbiEEptCl1mheDZnmqB02MfZV0zmNwz0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9eV9v/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9eV9v/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7FBC433C7;
	Mon,  1 Apr 2024 17:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711991824;
	bh=qaOUxaaKNEiktLLPEin3HNDBeJS1c4Oz2wEGIXg091c=;
	h=Date:To:From:Subject:From;
	b=p9eV9v/wHFQnqE6FlRbdie6VUW/nHvaybXnenUGYUsF9XcM9GalZfNvLlJYPRQ6gB
	 XTzij0ubHrh6g9FFhdQie1dAjB51EscMTkN8zaJ6E9qJgM3qcL5Qq89jpuIc5x7LMj
	 RZ82HcaQZHNkqQ92w/lKvY0eRqiu6kH/nM8oBD+4=
Date: Mon, 01 Apr 2024 10:17:03 -0700
To: mm-commits@vger.kernel.org,j.granados@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch added to mm-nonmm-unstable branch
Message-Id: <20240401171704.9D7FBC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc: remove the now superfluous sentinel element from ctl_table array
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Joel Granados <j.granados@samsung.com>
Subject: ipc: remove the now superfluous sentinel element from ctl_table array
Date: Thu, 28 Mar 2024 16:57:52 +0100

This commit comes at the tail end of a greater effort to remove the empty
elements at the end of the ctl_table arrays (sentinels) which will reduce
the overall build time size of the kernel and run time memory bloat by ~64
bytes per sentinel (further information Link :
https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/)

Remove the sentinels from ipc_sysctls and mq_sysctls

Link: https://lkml.kernel.org/r/20240328-jag-sysctl_remset_misc-v1-5-47c1463b3af2@samsung.com
Signed-off-by: Joel Granados <j.granados@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    1 -
 ipc/mq_sysctl.c  |    1 -
 2 files changed, 2 deletions(-)

--- a/ipc/ipc_sysctl.c~ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/ipc/ipc_sysctl.c
@@ -178,7 +178,6 @@ static struct ctl_table ipc_sysctls[] =
 		.extra2		= SYSCTL_INT_MAX,
 	},
 #endif
-	{}
 };
 
 static struct ctl_table_set *set_lookup(struct ctl_table_root *root)
--- a/ipc/mq_sysctl.c~ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/ipc/mq_sysctl.c
@@ -64,7 +64,6 @@ static struct ctl_table mq_sysctls[] = {
 		.extra1		= &msg_maxsize_limit_min,
 		.extra2		= &msg_maxsize_limit_max,
 	},
-	{}
 };
 
 static struct ctl_table_set *set_lookup(struct ctl_table_root *root)
_

Patches currently in -mm which might be from j.granados@samsung.com are

memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch
initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch
ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

