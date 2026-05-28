Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7FE2F9D85
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 20:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001336; cv=none; b=lgjziOhkNa2xNFoMvuZERo38/M6Nm9+iXVRbUZUeHeQ23QCGx70HqqnfXkiQwTmi/X99ixfDshDJ777A4VLVfvDVS9VA8EWI8b1dXhVGBc4PiyONmVspJsl0pvIIZTWeubdWWHjGfXP2VWS4+VVeqzXG/6KxUtgYjtGKyE5xUEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001336; c=relaxed/simple;
	bh=j6szioGAlI8n65HGW+H+ZE3EiDquBWvVgDwp45Vry2U=;
	h=Date:To:From:Subject:Message-Id; b=GmD40Sc7zwBirdqLNo4DWbeXpQ36N289CsCeR36XP7EN3Jwid4skObxOzX7pAA0OIb1dL565a4u2O+0poR8cXEKSpuMsNYR2wH+UwHZsXHMHxuxHcs6nw7y8Vj4bA4onK9EnLQ4+mmm4TNgn8tPrnscfmqLcsMv/W1t+bGjP400=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mjF8vSmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mjF8vSmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF661F00A3A;
	Thu, 28 May 2026 20:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780001335;
	bh=+x7YNzGY3COTjx+VfPwpak1We8df1/dGY+CYGCPVnio=;
	h=Date:To:From:Subject;
	b=mjF8vSmV2ry6PuBt3Kt9FSgwZDmv+ICpKdi7NXZub+Nrc1a8DGrzDb1auIi20kiJF
	 EundQJZ4L3/eoRKGqh6gqI+WtLNwvA1ocwQbesCA+vQdMMT5hjfPhRUq24hdstAY/d
	 OpIr11e11yIVlq1Ky8t/+U492iHi4tbT1CNQiHAc=
Date: Thu, 28 May 2026 13:48:54 -0700
To: mm-commits@vger.kernel.org,osalvador@kernel.org,ljs@kernel.org,liam@infradead.org,bmasney@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-vmrst-to-memory-management-core.patch added to mm-unstable branch
Message-Id: <20260528204855.4DF661F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add vm.rst to memory management core
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-vmrst-to-memory-management-core.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-vmrst-to-memory-management-core.patch

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
From: Brian Masney <bmasney@redhat.com>
Subject: MAINTAINERS: add vm.rst to memory management core
Date: Thu, 28 May 2026 09:56:14 -0400

The vm.rst file is currently not listed in the MAINTAINERS file, so let's
go ahead and add to the MM core subsystem so that the maintainers are CCed
when changes to the documentation are proposed.

Link: https://lore.kernel.org/20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-vmrst-to-memory-management-core
+++ a/MAINTAINERS
@@ -16781,6 +16781,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/sysctl/vm.rst
 F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
_

Patches currently in -mm which might be from bmasney@redhat.com are

maintainers-add-vmrst-to-memory-management-core.patch

