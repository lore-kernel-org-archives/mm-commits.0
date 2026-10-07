Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE302F8EAA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334246; cv=none; b=pDRV+aa5V3u2O1IppWIWVM/Yhkj5P8VCUWkLrzr3vv3N5ELdw4S7sMlRP3z98n084JRRbD21i+vu1tfK+AibLyic70DrVgEtj0MtJuydPprIhjY+N/jI7/YT06CUKMZ4pqfdjeMjK8HzpQrPt4wyWen/vUwOZrsl42p+6GOVsR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334246; c=relaxed/simple;
	bh=3mEuTrOlaXIO54LUdZLqiVq2VKO1xCQY3feztt8SQ1c=;
	h=Date:To:From:Subject:Message-Id; b=iG5jIsv9W/yzDjSDNK0rls2TATaiegyv5XaZlWJO5M6wj2jZUAOmDdL+wN+KiHp12IK/g/HIz5aAR0pqPFn/RS2AOSjZqSm+qPpqHgtqhv6Rb06P1fvWravynBjrgQLffzeZiQQX6C4hckoNkdOHNFWkPVfR1JdbmCft1uyz1V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PmNKAMhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PmNKAMhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BC81F0089B;
	Wed,  7 Oct 2026 00:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334244;
	bh=kum6WjDuLx62exlxctPX9aBSm1RSdVMM94/Y7iv+Vpk=;
	h=Date:To:From:Subject;
	b=PmNKAMhsc8EL97eqOV2P6hWa/i3+w3YHxUg18m05aqvVte6iQTDy1utnRux+na6T3
	 oGd6Mgg36ijVKL8WymKzBEbTs2GlH9KEgO8TdcptQqrGlVYvmKsi9UDID5JJML/Ae4
	 ekPjPRyBQuS7Yd3IeX3WWx0/9JB92xLF+aFVeMEk=
Date: Tue, 06 Oct 2026 17:50:44 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-fix-the-comment-about-which-sizes-share-a-slot.patch removed from -mm tree
Message-Id: <20261007005044.D4BC81F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: fix the comment about which sizes share a slot
has been removed from the -mm tree.  Its filename was
     percpu-fix-the-comment-about-which-sizes-share-a-slot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: percpu: fix the comment about which sizes share a slot
Date: Wed, 19 Aug 2026 01:48:30 +0900

A percpu allocation is at least PCPU_MIN_ALLOC_SIZE bytes, and
__pcpu_size_to_slot() returns 1 for sizes below 16 bytes and 2 for sizes
from 16 to 31 bytes.

So fix the wrong comment.

Link: https://lore.kernel.org/20260818164831.3138490-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~percpu-fix-the-comment-about-which-sizes-share-a-slot
+++ a/mm/percpu.c
@@ -100,7 +100,7 @@
 
 /*
  * The slots are sorted by the size of the biggest continuous free area.
- * 1-31 bytes share the same slot.
+ * [PCPU_MIN_ALLOC_SIZE..15] bytes share the same slot.
  */
 #define PCPU_SLOT_BASE_SHIFT		5
 /* chunks in slots below this are subject to being sidelined on failed alloc */
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-swapops-remove-unused-is_hwpoison_entry.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

