Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796121F098E
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534537; cv=none; b=RNoMZ8mlCuSZEZB1VrxQgDHTmwhqP2A+capx7zYI+PD42YoABC/wqxHa2bpwA9YFx9fRk4Q2uUjZp1BEbj1HomYqTGY8JldkGxaOWDr/if+2WvmRdnZXZFpwJJ/ywqgkvE3K6TAwDMsK8nsmZ1caJHNMYWTP8798YZCVy4W5z9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534537; c=relaxed/simple;
	bh=leREKYanGDvueXYeOZgl5v25CTd3ZIyc9TyBuv/sXpw=;
	h=Date:To:From:Subject:Message-Id; b=XcymIH+rO8oktxpEMHM161XRHxoQ05/LSKO/750C7XNd6FmXy1VI2HJav4qEWhFNvrdaUSicac30I4SFdi+/zcKfyzaVKX6kOPMSlWQ6355e5dj+oXSg/G/od8FDozdaNFj6xDDVPcb2gUnKefRI8wF1psHiVJKF+H8rJDwe/mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rOKifp/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rOKifp/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D639BC4CEE4;
	Tue,  1 Apr 2025 19:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743534536;
	bh=leREKYanGDvueXYeOZgl5v25CTd3ZIyc9TyBuv/sXpw=;
	h=Date:To:From:Subject:From;
	b=rOKifp/7xw8mEdfOOH7sZmFZt+uDxsaqf/t1/EVFj4M7bOAf+haikNUHji9nGUzg8
	 5FgI5Tz6vrDjzLuwO7fSMioSFzkPbBoUWHR4B6SupHldGhv8dz2B/vkGZIjWeYxkCz
	 8fa7HRC18sX8gwZXqITrMVXilxy+gJZVf2I44b9M=
Date: Tue, 01 Apr 2025 12:08:56 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jeffxu@chromium.org,gor@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mseal-sysmap-enable-s390-fix.patch removed from -mm tree
Message-Id: <20250401190856.D639BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: update supported architectures
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-enable-s390-fix.patch

This patch was dropped because it was folded into mseal-sysmap-enable-s390.patch

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: mseal sysmap: update supported architectures
Date: Mon, 17 Mar 2025 14:19:17 +0100

Add s390 to the list of architectures which support mseal sysmap.

Link: https://lkml.kernel.org/r/20250317131917.1332402-1-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/userspace-api/mseal.rst~mseal-sysmap-enable-s390-fix
+++ a/Documentation/userspace-api/mseal.rst
@@ -143,7 +143,8 @@ Use cases
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
   architecture.
 
-  The following architectures currently support this feature: x86-64 and arm64.
+  The following architectures currently support this feature: x86-64, arm64,
+  and s390.
 
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
_

Patches currently in -mm which might be from hca@linux.ibm.com are

mseal-sysmap-generic-vdso-vvar-mapping.patch
mseal-sysmap-enable-s390.patch

