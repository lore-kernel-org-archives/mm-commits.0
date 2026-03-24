Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922541684BE
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394172; cv=none; b=sVNn0R9ED4x92ma1NolD9Vwr4SUWqT6mH6lMaeG6t3LXjW3EGyEqRUtw9g8vKkiv4FpPWXMVy9eM4I/8sS7JKIQxjUAuObB0UfNwENOuXk37QRvTsGSvyGOIbGcspRUOiOwtA6COhNSLMtGYOBqrl9eu0naRCafiB0HK10Oj+Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394172; c=relaxed/simple;
	bh=lRrZ+WLj7kHWULr5rZTEt1UQtk2q+hVi4r3AGbEc3KY=;
	h=Date:To:From:Subject:Message-Id; b=VtzRHCb9+qNvcyVL9nJq1brpogSGo6y1vvqvIEoNeyssDUtlVtc+uCJcmFiN11gtvn0wMvD7s61XaBllO+tVVjkIHxeITwgdsiiVuV/kOeVGkWfgZoHBg92mEe5EVea+XoNR7Mq2CiiNzzIJUB9exxBnDK0yl7jjnLXIOg7u+ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g1XN/f1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1XN/f1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32507C19424;
	Tue, 24 Mar 2026 23:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394172;
	bh=lRrZ+WLj7kHWULr5rZTEt1UQtk2q+hVi4r3AGbEc3KY=;
	h=Date:To:From:Subject:From;
	b=g1XN/f1h3ST/cECiKPJNzmA7XiTBKLxBvbmSgfYEo6kL0l3jz+2t/igwr5ApzPLAW
	 Z6zu34Zm/3K28wTx6VDnrUUp8DqHZTgOjczuILHOa239pSD6LaTzmUK+8rbWPMxIQ/
	 N4uXKki1HyplmNUUV18/oToCNSIlb5BWOzEjD5hg=
Date: Tue, 24 Mar 2026 16:16:11 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,usama.arif@linux.dev,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch removed from -mm tree
Message-Id: <20260324231612.32507C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch

This patch was dropped because it was folded into mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix
Date: Mon Mar  9 12:35:33 PM PDT 2026

fix comment typo, per Usama.  Reflow comment to 80 cols

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix
+++ a/mm/memcontrol.c
@@ -4059,8 +4059,9 @@ free_objcg:
 		if (pn && pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
 			/*
-			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
-			 * from being called agagin in __mem_cgroup_free().
+			 * Reset pn->orig_objcg to NULL to prevent
+			 * obj_cgroup_put() from being called again in
+			 * __mem_cgroup_free().
 			 */
 			pn->orig_objcg = NULL;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

