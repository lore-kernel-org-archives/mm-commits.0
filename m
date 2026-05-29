Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ADB370AC2
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027627; cv=none; b=fXZBZCuS81hNcclnG8Bgz5Fejo2xy69jYBMBY6XUlTVNnHdhAT35WyZe5sw514Bo6p2ASlqqI8spXgjrQCyOS+6lkGFBfXR6eE/x64B7+mHO2yI8cpOXP6ntH+CRY9gvS4bgfrDLrgtt/R9QrlP/KfbaDHyVE1yd0Kf8HKIcKpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027627; c=relaxed/simple;
	bh=nPrrvEAKOc7/AgrNFCqKnHcJ27U4f07qEG4TxHohhJc=;
	h=Date:To:From:Subject:Message-Id; b=CG4aZQU+h+zNyMEcgmvDD+j+ZgMwujOzxOuXaJBIYeukJ/XiiRN+zAMo0oQMgE8Jqm8JpV/FSZPpHfSkGHFtTAQ5XxG+ihgjKNHopXrjZ9qQrCYipNmO1ocAZhT7ySaEdQ4asaRCiw7ZNyb7k5hL8DAa5y2F/JgHkv1c+6lOpCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uV2dc2Ci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uV2dc2Ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887941F00898;
	Fri, 29 May 2026 04:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027625;
	bh=jjQ2wbcAbNP0Tg0li6mrIVWWnLfRTNhomqi+cti/PtA=;
	h=Date:To:From:Subject;
	b=uV2dc2CiDy9IYsxFJMTr5MCtYzFSG1YvlE+zw8G3xF1ECpJdJMFa9PH/LMkuq6tVh
	 jmZq+bvpPJXwi7XRLdPnLAaVr88mEDDHg3jTco9RVVTSIajZotFTpo1+P2ti/UzmJC
	 53Vks3VHMILFP/s+6hCTDqmzdSkJzR2fvfml3Jgw=
Date: Thu, 28 May 2026 21:07:05 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,stf_xl@wp.pl,pabeni@redhat.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuba@kernel.org,horms@kernel.org,glider@google.com,elver@google.com,edumazet@google.com,dvyukov@google.com,davem@davemloft.net,allison.henderson@oracle.com,airlied@gmail.com,achender@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-managed-use-special-gfp_t-format-specifier.patch removed from -mm tree
Message-Id: <20260529040705.887941F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/managed: use special gfp_t format specifier
has been removed from the -mm tree.  Its filename was
     drm-managed-use-special-gfp_t-format-specifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: drm/managed: use special gfp_t format specifier
Date: Thu, 26 Mar 2026 12:31:57 +0000

Patch series "treewide: fixup gfp_t printks", v2.

Use vprintf()'s special gfp_t conversion in a few places.


This patch (of 3):

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Link: https://lore.kernel.org/20260326-gfp64-v2-0-d916021cecdf@google.com
Link: https://lore.kernel.org/20260326-gfp64-v2-1-d916021cecdf@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Allison Collins <allison.henderson@oracle.com>
Cc: Allison Henderson <achender@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_managed.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_managed.c~drm-managed-use-special-gfp_t-format-specifier
+++ a/drivers/gpu/drm/drm_managed.c
@@ -232,8 +232,8 @@ void *drmm_kmalloc(struct drm_device *de
 
 	dr = alloc_dr(NULL, size, gfp, dev_to_node(dev->dev));
 	if (!dr) {
-		drm_dbg_drmres(dev, "failed to allocate %zu bytes, %u flags\n",
-			       size, gfp);
+		drm_dbg_drmres(dev, "failed to allocate %zu bytes, %pGg\n",
+			       size, &gfp);
 		return NULL;
 	}
 	dr->node.name = kstrdup_const("kmalloc", gfp);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch
mm-page_alloc-drop-a-misleading-__always_inline.patch
mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch
mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch

