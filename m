Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A794C73
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560062; cv=none; b=RiEjhUdVD8pmXeRy/bP+W+h/rr5AeEEvSz2ui7vHKE/dFsYCU9GwtVN1YqBMz479Ptxq9mE8IRO4O7H3ETNIm4gLG1ZdaHhZdOamHnj5PqKf9eR41KEGvSSO2kmqIhcoTO2JltlnVa3QEHgQNNKoc0hTnXuhKWG4eT1LSk1UjsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560062; c=relaxed/simple;
	bh=CqxlI4aWgiXw9upGcRrHq4pf8e+r9o1VXT3TZs0d56E=;
	h=Date:To:From:Subject:Message-Id; b=IKlFKWVoMAfLoylm2RjLJnUyJywuuqVIt+eYbasXb1HxUrVoZsQGoYSeRwFAWGe/xqLICInSBtQgVosOGt2vnh7pi9ciKF6W35mWqMNiQXlnz6z+Uk8g1tzgIohaq4RmzgzcZaBcKQzCPylJxxrKqIH7/sYq+TRokIyW/Ax4qvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=soHgbCpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="soHgbCpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C323EC433B1;
	Thu, 22 Feb 2024 00:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560061;
	bh=CqxlI4aWgiXw9upGcRrHq4pf8e+r9o1VXT3TZs0d56E=;
	h=Date:To:From:Subject:From;
	b=soHgbCpLsD+AXdl+lIAOB0eq5ERqbO+ghgCQyu7vMrb2Zz0iJDPh8e6UiqzitVRtZ
	 GwTVgp4BJCBVowgtvLMzjLubAJxD3upBk1Um+Z4UdCnA3JvqUPngQITNGPIy+fzNWy
	 7+it6t9rcDUt0IrbLjgjiPkIjwKhiHbHNPFDOzZI=
Date: Wed, 21 Feb 2024 16:01:01 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-enable-mhp_memmap_on_memory.patch removed from -mm tree
Message-Id: <20240222000101.C323EC433B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390: enable MHP_MEMMAP_ON_MEMORY
has been removed from the -mm tree.  Its filename was
     s390-enable-mhp_memmap_on_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: s390: enable MHP_MEMMAP_ON_MEMORY
Date: Mon, 8 Jan 2024 14:27:47 +0100

Enable MHP_MEMMAP_ON_MEMORY to support "memmap on memory".
memory_hotplug.memmap_on_memory=true kernel parameter should be set in
kernel boot option to enable the feature.

Link: https://lkml.kernel.org/r/20240108132747.3238763-6-sumanthk@linux.ibm.com
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/Kconfig~s390-enable-mhp_memmap_on_memory
+++ a/arch/s390/Kconfig
@@ -113,6 +113,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are


