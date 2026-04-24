Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E11630E85B
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 15:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777044361; cv=none; b=Wx1uYDdqLDK6XI2i4NbnHFPTDAF+KoMe9dbedkMk157iX2xNXoa/rKc9hl2HtjlD5zAA1GFOICxpp1CfIY8sNoBB7QqRLLEwvgzt98lrzHM9H4M9wg++I6CLKhY54bY5NcLTMHKp2AxYc9ubZpSATN7ZiKip+R3WtXAuohWamek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777044361; c=relaxed/simple;
	bh=XJlX9QIelZ+uZDHRS64EbOdcDIKnZ/+fWt5KKv8KLAE=;
	h=Date:To:From:Subject:Message-Id; b=F2LXPqK5dQ3vR4oCo/gBY03738AA31+2Vikw0c2VFv6JAQlORB8TVrCM/QpsellDx6ueJgbP1fneN2SmXiQuRLb2jJIr4u29MnsLb1fNZ8A4DPUsBx1z6nkW5QKBPniaH0LbC8Ip5B4LW8EiqU4vP1xnknerO0GVr8gvEApHSD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pj/ebPuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pj/ebPuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE2CC19425;
	Fri, 24 Apr 2026 15:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777044360;
	bh=XJlX9QIelZ+uZDHRS64EbOdcDIKnZ/+fWt5KKv8KLAE=;
	h=Date:To:From:Subject:From;
	b=Pj/ebPuCPeNhQw8rbi/arbIvT4ATJsXtaTzBaD7+c2qbCOMwWWKwg4WkwibMnJ8qn
	 vp1KTm4Jt3BorKELmDOQXM4+ks02qcQxEHfQ9wsqCWiQwlgV9ae5R7F12pDS4ctwKO
	 VvcPXB0zFJQg2k+bWQ1A8jwFCW/9+rPmxFZbYKhU=
Date: Fri, 24 Apr 2026 08:26:00 -0700
To: mm-commits@vger.kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch removed from -mm tree
Message-Id: <20260424152600.AFE2CC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
has been removed from the -mm tree.  Its filename was
     mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Thu, 2 Apr 2026 16:59:32 -0700

Patch series "fix MAP_DROPPABLE not supported errno".

Mark Brown reported seeing a regression in -next on 32 bit arm with the
mlock selftests.  Before exiting and marking the tests failed, the
following message was logged after an attempt to create a MAP_DROPPABLE
mapping:

Bail out! mmap error: Unknown error 524

It turns out error 524 is ENOTSUPP which is an error that userspace is not
supposed to see, but it indicates in this instance that MAP_DROPPABLE is
not supported.

The first patch changes the errno returned to EOPNOTSUPP.  The second
patch is a second version of a prior patch to introduce selftests to
verify locking behavior with droppable mappings with the additional change
to skip the tests when MAP_DROPPABLE is not supported.


This patch (of 2):

On configs where MAP_DROPPABLE is not supported (currently any 32-bit
config except for PPC32), mmap fails with errno set to ENOTSUPP.  However,
ENOTSUPP is not a standard error value that userspace knows about.  The
acceptable userspace-visible errno to use is EOPNOTSUPP.  checkpatch.pl
has a warning to this effect.

Link: https://lore.kernel.org/20260402235933.10588-1-anthony.yznaga@oracle.com
Link: https://lore.kernel.org/20260402235933.10588-2-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand <david@kernel.org>
Reported-by: Mark Brown <broonie@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-fix-mmap-errno-value-when-map_droppable-is-not-supported
+++ a/mm/mmap.c
@@ -504,7 +504,7 @@ unsigned long do_mmap(struct file *file,
 			break;
 		case MAP_DROPPABLE:
 			if (VM_DROPPABLE == VM_NONE)
-				return -ENOTSUPP;
+				return -EOPNOTSUPP;
 			/*
 			 * A locked or stack area makes no sense to be droppable.
 			 *
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

