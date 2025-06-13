Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCED2F433F
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 04:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749789460; cv=none; b=TqboJzsmg7eoW6Y4enV4hKF9RbmB79IISFoYGMtY7Fw5MY/IxwkkBOpahO3WvWvqieo1jYBeeLyBODF1A+V3ngw+gHT/xwXQJeciHbxTuzGma8KnGh3BArYWQ4zBIqUUDUUxOw3XyzOQ3f3c4fYQd1aBuwg92wqVy2NcIvHs/hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749789460; c=relaxed/simple;
	bh=+tV8fgYfrddQeHuRIVcgawWv0ITFphAOWRXKlmfBKzw=;
	h=Date:To:From:Subject:Message-Id; b=pryy5ou8XidJIccLLf/7TWwN72pYwz8tRs02VZmEzSTxT1Cxy8JKlTe8OPfUcnE0Bb1+D6OApkMy3dPNAt5vX310QQcuoQYaKCFrj5aOtQki73Mjl0Kr9IMRnEWrp2QuffsoaSov1oC1/2yLRTTE3AcobaNQTsRkoGTnMLw1nQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qjpRfHtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qjpRfHtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DBDC4CEE3;
	Fri, 13 Jun 2025 04:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749789459;
	bh=+tV8fgYfrddQeHuRIVcgawWv0ITFphAOWRXKlmfBKzw=;
	h=Date:To:From:Subject:From;
	b=qjpRfHtKKs6oRU3oa80pHpWw7V/AnMp5up7sj35zLwWOk2ksmeEILxxurEuaFugpv
	 Z4Z2bqWurALYwwd+ZvegutwCCYw9SJa47ExCB+0s3Gbqyu4zyZfS4MmMlZOkvwB9Qf
	 X6jOZIJSWOY5z6HLUNHI1a00Nc016ERZBdzpMeGo=
Date: Thu, 12 Jun 2025 21:37:38 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch removed from -mm tree
Message-Id: <20250613043739.70DBDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix
has been removed from the -mm tree.  Its filename was
     mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch

This patch was dropped because it was folded into mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix
Date: Mon Jun  9 06:17:45 PM PDT 2025

export compat_vma_mmap_prepare tp fix build

ERROR: modpost: "compat_vma_mmap_prepare" [fs/coda/coda.ko] undefined!
ERROR: modpost: "compat_vma_mmap_prepare" [drivers/gpu/drm/i915/i915.ko] undefined!

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/util.c~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix
+++ a/mm/util.c
@@ -1170,3 +1170,4 @@ int compat_vma_mmap_prepare(struct file
 
 	return 0;
 }
+EXPORT_SYMBOL(compat_vma_mmap_prepare);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch

