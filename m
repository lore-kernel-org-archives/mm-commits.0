Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C6616F265
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978413; cv=none; b=frSbczaHAbplmI2v/OuOcOu3iotUE7cmlpds418NDpsS9UsQ/KzDBQgfe5JxwNmvFKuyiulb1x0Fsg6Rz6O/hc+Ohfy+JOAsggAaeyZIBZKtlsP1KlAMlvdKCAqxKwG5XloLRB0ooLU2gIg/pqcRM0ILJDjEWusJi7ey/kctT/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978413; c=relaxed/simple;
	bh=OMsPoHA+dy9jRC+YpH7rbxY00A9BoiJ8lJWMgyf4kqk=;
	h=Date:To:From:Subject:Message-Id; b=DfozdJfWBOC6dAtYxWmKzy1Dcbam1fiIyRMpV571pzoZZ5WNuj778htZXxWCllzylCSsCpM3oGHod8hvJy8TqYpKJvq610W3dKUfGYFVdhAmqMHhtkvK39P71YFkmu3JQqUJLLw86tZaFcIE8S90124yEbzxda5fFh9C+50RONQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xnJb0UQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xnJb0UQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ACFC4CEF4;
	Sun, 20 Jul 2025 02:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978412;
	bh=OMsPoHA+dy9jRC+YpH7rbxY00A9BoiJ8lJWMgyf4kqk=;
	h=Date:To:From:Subject:From;
	b=xnJb0UQzjO7g+mI+9QtEOAnGX/cbyeo7Xzkj/wIzWPpmH42EdAl25Qfr0nwEc8as5
	 Q5he0wi9BWG9HJCSskgLOzoi0xD+hDjuLY0cUuCr48sI0ubUAv8zjqkseikW1gpD71
	 tpcp+3JZl+Ol1AMUe2iuOuVbpQRqh6RYf8uwz5Gc=
Date: Sat, 19 Jul 2025 19:26:52 -0700
To: mm-commits@vger.kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,leon@kernel.org,david@redhat.com,jgg@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-update-maintainers-entry-for-hmm.patch removed from -mm tree
Message-Id: <20250720022652.D6ACFC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update MAINTAINERS entry for HMM
has been removed from the -mm tree.  Its filename was
     mm-update-maintainers-entry-for-hmm.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Leon Romanovsky <leon@kernel.org>
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


