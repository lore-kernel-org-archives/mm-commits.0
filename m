Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C662FE598
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766100538; cv=none; b=EkqzAkRu2CvoyO+rMCVRBCYdblgwQGgwG3J88u+MuIjQoY3YQAggG0G0MFZRT4GQBvcCl7hbENRRhnd7YwOQv1FJ7JHqreCddOqH9XrnYrG2aH2AjAZSx3dJQV4EOSQrq7GqiiyjUVTLepB9LFReISmaOMdHO0nEoVs6vipwx8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766100538; c=relaxed/simple;
	bh=2hO0TV/dZx9vIGTwNE/6O/6n50B2yeiO6IGz+KoDS7c=;
	h=Date:To:From:Subject:Message-Id; b=IzWAIkzc+SUFumY7IeYdos5abuo2w0TeqqQDMruWGsdd1CqF1nUN0gyUX831YaYIv9JafSHkFRBKCxM2WVr3Uozily5IKC9HFOGsAtOuVumVZ/6ZuCgJGu4K3PqKWlLxMvsfMJUy8NnQGLr0f42E3mJnDeckb6/NncBgBSKrfZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pi9iI41j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pi9iI41j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ECDC116D0;
	Thu, 18 Dec 2025 23:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766100538;
	bh=2hO0TV/dZx9vIGTwNE/6O/6n50B2yeiO6IGz+KoDS7c=;
	h=Date:To:From:Subject:From;
	b=Pi9iI41jB/qiqhUToZBarkHjSuco8Fb7aCToNxnDR+VyOv/eCyUadOW+P9kQMRLUU
	 dOxxyq9GUW7FwJQ8Sf/us3jCcBv1ytoaVERJh5rQRaqeitzvsYBIsgmw9LjGCHS1LX
	 BuFMSdPXoqCDRuEFTZFU4dT8y480gGG2ldymwbZE=
Date: Thu, 18 Dec 2025 15:28:57 -0800
To: mm-commits@vger.kernel.org,sparse@chrisli.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparse-update-maintainers-info.patch added to mm-hotfixes-unstable branch
Message-Id: <20251218232858.14ECDC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparse: update MAINTAINERS info
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     sparse-update-maintainers-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparse-update-maintainers-info.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: sparse: update MAINTAINERS info
Date: Wed, 17 Dec 2025 22:09:21 -0800

Chris Li is back as sparse maintainer.

See https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=67f0a03cee4637e495151c48a02be642a158cbbb

Link: https://lkml.kernel.org/r/20251218060921.995516-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christopher Li <sparse@chrisli.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~sparse-update-maintainers-info
+++ a/MAINTAINERS
@@ -24575,7 +24575,7 @@ F:	drivers/tty/vcc.c
 F:	include/linux/sunserialcore.h
 
 SPARSE CHECKER
-M:	"Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>
+M:	Chris Li <sparse@chrisli.org>
 L:	linux-sparse@vger.kernel.org
 S:	Maintained
 W:	https://sparse.docs.kernel.org/
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-leafopsh-correct-kernel-doc-function-param-names.patch
sparse-update-maintainers-info.patch
kernelh-drop-hexh-and-update-all-hexh-users.patch

