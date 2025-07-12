Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7396A22094
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358660; cv=none; b=mBRDb+vudlT+kueaYQDbtuD7QtV2tExg9y/EfMJSvoNABpt8UdBIIkcI1/Sh5ElxeGKkXDXdDu8H2GQwwChMmUKCOpE1fW1+76AMP4wrUduD5NIH71hDn++18ycwljzhuLfVc9RIM+gCA+SH7mYn2Io/aN3DUmv55/wue7XxNvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358660; c=relaxed/simple;
	bh=5gSJa5YwCC4/KWdEf/GZcb6i/0vi3arB4+MW7aABYgA=;
	h=Date:To:From:Subject:Message-Id; b=h+aSF/DUqgoZpv8S4rnvdQH9eI4PUDsDXxAohxFmBOxmHn4PFpOhK0ovKzHFoTMDVpoKxQcUxDmjIYID8wOzMFYvJnm/nOkYkCe7NgsEld9oDB0e/DNmj9a0wKHdfKrSBuN/O/V++qTnoouHIXeNQGHOjMoP2BLTOUUGBesN4tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oiZdx3gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oiZdx3gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAB5C4CEEF;
	Sat, 12 Jul 2025 22:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358659;
	bh=5gSJa5YwCC4/KWdEf/GZcb6i/0vi3arB4+MW7aABYgA=;
	h=Date:To:From:Subject:From;
	b=oiZdx3gqiCSuXUTdw2GWLdZvp7oI7nJuHq2w2PDTk750pQGLs+wD7Prb+c8rV1MN+
	 JTqqtxf6/0CFkDEVg1V1g10SpIAEtSozJQk2mFaBGV8TX2GDMkPzwGGYAkz+7odF2F
	 bzisdorNduRS7s2TRwnFYC5aAWfzxsrfylNyvz08=
Date: Sat, 12 Jul 2025 15:17:39 -0700
To: mm-commits@vger.kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,jgg@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-maintainers-entry-for-hmm.patch added to mm-hotfixes-unstable branch
Message-Id: <20250712221739.DBAB5C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update MAINTAINERS entry for HMM
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-update-maintainers-entry-for-hmm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-maintainers-entry-for-hmm.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm: update MAINTAINERS entry for HMM
Date: Fri, 11 Jul 2025 19:34:44 -0300

Jérôme has moved on from RH and has not been looking at HMM patches for
some time. I've made the most changes to the core code in the recent
period and Leon is now working on the HMM side from the RDMA ODP.

Link: https://lkml.kernel.org/r/0-v1-a1df5219c7a3+1d981-hmm_maintainers_jgg@nvidia.com
Closes: https://lore.kernel.org/all/39d43309-9f34-48bc-a9ad-108c607ba175@samsung.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/CREDITS~mm-update-maintainers-entry-for-hmm
+++ a/CREDITS
@@ -1397,6 +1397,10 @@ N: Thomas Gleixner
 E: tglx@linutronix.de
 D: NAND flash hardware support, JFFS2 on NAND flash
 
+N: Jérôme Glisse
+E: jglisse@redhat.com
+D: HMM - Heterogeneous Memory Management
+
 N: Richard E. Gooch
 E: rgooch@atnf.csiro.au
 D: parent process death signal to children
--- a/MAINTAINERS~mm-update-maintainers-entry-for-hmm
+++ a/MAINTAINERS
@@ -11006,7 +11006,8 @@ F:	Documentation/ABI/testing/debugfs-his
 F:	drivers/crypto/hisilicon/zip/
 
 HMM - Heterogeneous Memory Management
-M:	Jérôme Glisse <jglisse@redhat.com>
+M:	Jason Gunthorpe <jgg@nvidia.com>
+M:	Leon Romanovsky <leonro@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/hmm.rst
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-update-maintainers-entry-for-hmm.patch

