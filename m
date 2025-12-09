Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD82030594F;
	Tue,  9 Dec 2025 19:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308378; cv=none; b=EcTQl9L0ihtuhonBw4vN0eYeq5Yqax7x0lUzRE1HCrXSbZFT+uIq3QZHUFBcB+opGJWjBUwIvdtVTrV63Sa6+Z0GH3sQFC3nsGrFYyoQZEb/ZoarvT68mExuoBTgu6vddeLuNcohP8qrLAtzVfavaa3UXprqBjry9gOYQQ7lHnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308378; c=relaxed/simple;
	bh=iKYKhXuzyfXyRx8i5PQVTi8dF9Ut6Gabes+HpGudnNY=;
	h=Date:To:From:Subject:Message-Id; b=oBFoskaKnXwyFDdHsXNZSA07QTs595j270uN2rhkGWOVpqIDZHKdXgTKp29oOd48dOBCmzXlvaUo1eh5kcDtm/dduioY0meLJOoirxhzLW6RgZCZm4MUqW7PC6t7nB7ZkaBrfciorshLVRQ3jNyafjNi8YfAFcDy44ngvmbL8kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ueqhrVZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ueqhrVZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67514C4CEF5;
	Tue,  9 Dec 2025 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308378;
	bh=iKYKhXuzyfXyRx8i5PQVTi8dF9Ut6Gabes+HpGudnNY=;
	h=Date:To:From:Subject:From;
	b=ueqhrVZCiVX5JNtfdzNz7fL24XZXiyoPI5yBMJ5Mb0Zrb+JAXTMnA+g+I0egMwQwZ
	 RA7BkbdTkWXJN0d0jWH+Ql53wBSBtChKnXUNT1QPpmgZlP7XgZz3eUm4DXJCQPln9+
	 4mjnA6FhLlthivapMCfd8oBrazTU7tIuNykEFdPU=
Date: Tue, 09 Dec 2025 11:26:17 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ritesh.list@gmail.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages.patch removed from -mm tree
Message-Id: <20251209192618.67514C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
has been removed from the -mm tree.  Its filename was
     powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
Date: Tue, 21 Oct 2025 12:06:06 +0200

Let's properly adjust BALLOON_MIGRATE like the other drivers.

Note that the INFLATE/DEFLATE events are triggered from the core when
enqueueing/dequeueing pages.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251021100606.148294-3-david@redhat.com
Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/cmm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/pseries/cmm.c~powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages
+++ a/arch/powerpc/platforms/pseries/cmm.c
@@ -532,6 +532,7 @@ static int cmm_migratepage(struct balloo
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 	balloon_page_insert(b_dev_info, newpage);
+	__count_vm_event(BALLOON_MIGRATE);
 	b_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 
_

Patches currently in -mm which might be from david@redhat.com are


