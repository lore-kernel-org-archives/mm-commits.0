Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB71539AF2
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957157; cv=none; b=dWsXZ6CH4U0zq1ru3eLtnVbounlzk97X6sYHPN1sU67m9d4n2gy6LWj1hEBQ/u1YfmqxNl/macO7eIY98eNEVRFePi7fPLOt0lCldzZK3NBFr5aHN8mgszTngCOdRlWk2e4taGIxRn3+JX5VZd6o0XUUpMDqRd2/zBzdQ2f+vQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957157; c=relaxed/simple;
	bh=vhFgqfX+qnLS6D8Y9dvZ8vGI355Ya3tswDGxGS+P14o=;
	h=Date:To:From:Subject:Message-Id; b=V1CgyE7IgZCIhRUxV9loviiRLdhQtzCSjlyxqDEucgNFK69r0cDZ86AesJgV+qiuOgHhsYw4soszTG2JnsoGDnwGzRN+dvaI594Tu9zwYGEX4vWqrt7IV+tUq5/DtTSfnNOc6gERaNB8yRLupsmDGb+3MIalnBIGJFlQM48zz1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ruAkIWiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ruAkIWiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92ACC113CC;
	Mon,  6 May 2024 00:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957157;
	bh=vhFgqfX+qnLS6D8Y9dvZ8vGI355Ya3tswDGxGS+P14o=;
	h=Date:To:From:Subject:From;
	b=ruAkIWiu9FLpUOykAb9gUa0JGSrf+MiYCs0GNuD9fsYzkbT6FtpEUUfAuFDUs1DOS
	 vy8uoi6u2XMMICXg7myJQjWIuFXRZU5Awc/NyfvMCE9vuheKdLtu4BhuNa7br1A/GI
	 8WpqWtz1HbR5CdGQ//UJ3gkjj2tqUzKyDDPl6k38=
Date: Sun, 05 May 2024 17:59:17 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid.patch removed from -mm tree
Message-Id: <20240506005917.A92ACC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug_vm_pgtable: test pmd_leaf() behavior with pmd_mkinvalid()
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/debug_vm_pgtable: test pmd_leaf() behavior with pmd_mkinvalid()
Date: Wed, 1 May 2024 15:44:39 +0100

An invalidated pmd should still cause pmd_leaf() to return true.  Let's
test for that to ensure all arches remain consistent.

Link: https://lkml.kernel.org/r/20240501144439.1389048-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid
+++ a/mm/debug_vm_pgtable.c
@@ -982,6 +982,7 @@ static void __init pmd_thp_tests(struct
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
 	WARN_ON(!pmd_trans_huge(pmd_mkinvalid(pmd_mkhuge(pmd))));
 	WARN_ON(!pmd_present(pmd_mkinvalid(pmd_mkhuge(pmd))));
+	WARN_ON(!pmd_leaf(pmd_mkinvalid(pmd_mkhuge(pmd))));
 #endif /* __HAVE_ARCH_PMDP_INVALIDATE */
 }
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


