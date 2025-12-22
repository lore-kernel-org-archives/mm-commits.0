Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35E722068F
	for <mm-commits@vger.kernel.org>; Mon, 22 Dec 2025 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766426046; cv=none; b=aoNy2VaFjZ3NVrdqiIWaNUsJpAo3Ibt9EWGPqTSkmTItZQFdUfIQRE/MePOil/J3OhRIbZbbUq5iDWC/syy8LnF18qZ5iY/ot/mL4RbQu2ronatO4RZhdXzq/u+3eY3R6SgGX4qsOP3TbkYwDBzHy+oKzp4eVdLtsgOdZB+ZPwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766426046; c=relaxed/simple;
	bh=9jw7qjbIz9nN2QH02e3agd+e7ceBiusK1l9yoCUPSC0=;
	h=Date:To:From:Subject:Message-Id; b=uySFR86SIr0plY4yqR2h100o3yK80Qz3024AXV1UTd1syNGP9vmCkOHPDYXuUXmgPc0ZWIgS9X0EmI5YBeNIgs8C5YmjoeDRfNU3h3JdFNM4AureshK5LXjegIqA7kzJQRIBUdcVMYOBw12XAcCC9zbwY8Edx33TLXPes8BIaWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rCL/kiqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rCL/kiqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1A8C4CEF1;
	Mon, 22 Dec 2025 17:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766426044;
	bh=9jw7qjbIz9nN2QH02e3agd+e7ceBiusK1l9yoCUPSC0=;
	h=Date:To:From:Subject:From;
	b=rCL/kiqEXMDKebrow1qp0ka7aqZp5CO6nlH2fnoqhZHfaIUjb5u0BGX/QfyTTkYVU
	 gSJfy+8KqL6v1yXuozTbqhY7LqMH4qOzQyaWldVqcjeL+YCxHi+V3jxddR1xK8iOv2
	 OZkiWFflP0w9GeodTCbaJaKd3bpm8rpQtmDys89w=
Date: Mon, 22 Dec 2025 09:54:03 -0800
To: mm-commits@vger.kernel.org,k.lourenco@criteo.com,david@kernel.org,klourencodev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fadvise-validate-offset-in-generic_fadvise.patch added to mm-unstable branch
Message-Id: <20251222175404.4D1A8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/fadvise: validate offset in generic_fadvise
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fadvise-validate-offset-in-generic_fadvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fadvise-validate-offset-in-generic_fadvise.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kevin Lourenco <klourencodev@gmail.com>
Subject: mm/fadvise: validate offset in generic_fadvise
Date: Mon, 22 Dec 2025 15:18:17 +0100

When converted to (u64) for page calculations, a negative offset can
produce extremely large page indices.  This may lead to issues in certain
advice modes (excessive readahead or cache invalidation)

offsets are normally non-negative, but the API does not guarantee this. 
Since 'len' is already validated, checking 'offset' here is reasonable to
prevent potential system instability.

Link: https://lkml.kernel.org/r/20251222141817.13335-1-klourencodev@gmail.com
Signed-off-by: Kevin Lourenco <k.lourenco@criteo.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/fadvise.c~mm-fadvise-validate-offset-in-generic_fadvise
+++ a/mm/fadvise.c
@@ -43,7 +43,7 @@ int generic_fadvise(struct file *file, l
 		return -ESPIPE;
 
 	mapping = file->f_mapping;
-	if (!mapping || len < 0)
+	if (!mapping || len < 0 || offset < 0)
 		return -EINVAL;
 
 	bdi = inode_to_bdi(mapping->host);
_

Patches currently in -mm which might be from klourencodev@gmail.com are

mm-damon-fix-typos-in-comments.patch
mm-fix-minor-spelling-mistakes-in-comments.patch
mm-fadvise-validate-offset-in-generic_fadvise.patch

