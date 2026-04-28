Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972342D879E
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777388237; cv=none; b=Nlt1KxXCArz/iXbFSJ+ATeiggMjjFuGtP8cMK/w0V2EtcHHFSY7jERbWDJf2sf0hwZetXTMEkC6kl0LfsRXHV1xJSEWrJ9HO4d+ikgdGoQeSvB/jfihSZAPgpW7IsB/4lqTbW2luq1M952zxtM13vzCiCf9m69bXbl5vLuJUkcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777388237; c=relaxed/simple;
	bh=Mg3hcQc/sm87a1p5s+5lox+jPRIO4UV6zr5YWgLCJDM=;
	h=Date:To:From:Subject:Message-Id; b=ppYofz9oq9CGPKWWxZfPg7OH/6tLAOEjj+GUUI40wwo7AGDQYnmZjCwzevPXj0PCXVptR1WUNn6xq44dqAF1L5ZwmOmiaWHwLiFiRMeBw6Cg8Dxf4uSzWowLhbajPY9hZpSF7phSuP1UJrN0LtzsEbZL9RLXdD1NljQKl5LPcCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=spxUGMrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="spxUGMrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DECC2BCAF;
	Tue, 28 Apr 2026 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777388236;
	bh=Mg3hcQc/sm87a1p5s+5lox+jPRIO4UV6zr5YWgLCJDM=;
	h=Date:To:From:Subject:From;
	b=spxUGMrqDEx9rtt3h0mQ/69JWFac4wfYBkVQozRdAgLgGfHVvG09eqCm9L3Dw2We9
	 uiRRVkrUUXughfomwXQCBJolGiolnLjiv9XRHso1UL2cm1hGXaPKzQ8i6K/KITbN94
	 XMvcys+//P/PHqHMUg0mNkmvL8AGybCIQ6w1FXmw=
Date: Tue, 28 Apr 2026 07:57:15 -0700
To: mm-commits@vger.kernel.org,ruirui.yang@linux.dev,pratyush@kernel.org,pasha.tatashin@soleen.com,ebiederm@xmission.com,baoquan.he@linux.dev,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-kexec-list-to-live-update-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20260428145716.68DECC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add kexec@ list to LIVE UPDATE ENTRY
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-kexec-list-to-live-update-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-kexec-list-to-live-update-entry.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add kexec@ list to LIVE UPDATE ENTRY
Date: Tue, 28 Apr 2026 15:48:33 +0300

Link: https://lore.kernel.org/20260428124833.1903302-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-kexec-list-to-live-update-entry
+++ a/MAINTAINERS
@@ -14894,6 +14894,7 @@ LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pratyush Yadav <pratyush@kernel.org>
+L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
_

Patches currently in -mm which might be from rppt@kernel.org are

sh-fix-fallout-from-zero_page-consolidation.patch
maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch

