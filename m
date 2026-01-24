Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD45A945
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 01:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769217500; cv=none; b=I4QGDCd0P8acczhGv6/0qJZX96Sh0IlHdwY1h3dmAsReE71/GIoVPxqZZ/8EgvYd8PjXPKZ4ZuwTa6OmPcFzu0NkY0LiHX+8TBjC2bu86gdY05aycTrWhi4r9ITyG19ZXe54SSUtrOxMNK9wbwYFN4xf+Th5JLd7h1IIyjN71tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769217500; c=relaxed/simple;
	bh=s2StH9DtXQsPvt7uqL8ts+NifoC3SpzH6YZcWGuTKjI=;
	h=Date:To:From:Subject:Message-Id; b=KyRIXdgihtPWeg7S45PepMs7/kkESmyTL5nXDTUIICsWnswYX+QhudTnKLtNFOcLNLoEvad9inscZXC7jGra4xIMg4KpAIIn5Bj4I1qDZ1kwbm2fnmqTIOcaS/u1zjnmW0UIFXYABOxqmwpmLKLrBZ65EmYq1oKwFdqSnMWF80A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TyrCT0zL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TyrCT0zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89650C4CEF1;
	Sat, 24 Jan 2026 01:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769217499;
	bh=s2StH9DtXQsPvt7uqL8ts+NifoC3SpzH6YZcWGuTKjI=;
	h=Date:To:From:Subject:From;
	b=TyrCT0zLBY2lNfAATzfyWmnyRKG8DIc0gDDO0djGc80SYTLfXYQkzjlSC50oVKqNl
	 2ABNIoEL9iymtzJXyOKUqu77E8+aTjcRwzrv86eOsIvX9gv85BHcpPGOGLFpDZKRyW
	 /LCsFRVrBEsjY4ki4xAarn6YvYWj9Nrh1yeqNrik=
Date: Fri, 23 Jan 2026 17:18:18 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-khugepaged-make-khugepaged_collapse_control-static.patch removed from -mm tree
Message-Id: <20260124011819.89650C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: make khugepaged_collapse_control static
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-make-khugepaged_collapse_control-static.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: make khugepaged_collapse_control static
Date: Sun, 18 Jan 2026 19:23:01 +0000

The global variable 'khugepaged_collapse_control' is not used outside of
mm/khugepaged.c.  Make it static to limit its scope.

Link: https://lkml.kernel.org/r/20260118192253.9263-14-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-static
+++ a/mm/khugepaged.c
@@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
+static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static-fix.patch

