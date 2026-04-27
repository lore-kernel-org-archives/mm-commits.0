Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A2B3090D9
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294524; cv=none; b=Lju6LNntpdiMu4RElHK7x34+sODSxuLGqc5gR6ZsMedp8WqIarQLarbrUVfTHZyASHmtd/ZK+8+g7npflj3Z4ps/D2welZdYNByqYx1DjJz6lbQZ5ORnb4TE73NtocG1xwb7AJk2CQ94QF2w7PT1NlU+4ADuzdt2KjMLHN022y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294524; c=relaxed/simple;
	bh=047SUESbGoYrSl/+8LXAmrXbXvjwHN/SIiHzvJuQ3Y8=;
	h=Date:To:From:Subject:Message-Id; b=fzWzZ0OX1g2n9tuevAX8pOzCnOD5zuj3vK3xwC7hhTSzAJ5CHX7BRE8hulmEaKDIGDxVhohHsvBQyAe3yZxkOC3dpvraq69XGNfeeHWWiocPCvT9Cv3jJ/9fctqHsxCM+7qRo7wPL4BAiidKtTdPDcUkB/JQIvMjTcWS0IetUNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kp0gsDWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kp0gsDWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E7EC2BCB4;
	Mon, 27 Apr 2026 12:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294524;
	bh=047SUESbGoYrSl/+8LXAmrXbXvjwHN/SIiHzvJuQ3Y8=;
	h=Date:To:From:Subject:From;
	b=Kp0gsDWut8s7PWEm/cRuXX6t67GnKpVCXlHqt5zSAEonMrAIO3g8nc7dgCvA8EXEL
	 6j9SSYYSbLWNOvxbPKqoOwUt3VSP2AoDRo+fggpZ5tQp6uyjrQ6ZQ3DrepL7FiLUhZ
	 8fflRJaj7iwl+yOo/SW1z/HIhDvPnUEl65jPgdZc=
Date: Mon, 27 Apr 2026 05:55:23 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,dyoung@redhat.com,baoquan.he@linux.dev,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-stale-kdump-project-url.patch removed from -mm tree
Message-Id: <20260427125524.00E7EC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove stale kdump project URL
has been removed from the -mm tree.  Its filename was
     maintainers-remove-stale-kdump-project-url.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: MAINTAINERS: remove stale kdump project URL
Date: Sat, 18 Apr 2026 13:32:26 +0530

The kdump project URL in MAINTAINERS points to
http://lse.sourceforge.net/kdump/, but it is no longer maintained.

Remove this outdated link to avoid confusion and keep the file
up to date.

Discussion to remove this link:
https://lore.kernel.org/all/e1e9e200-17d7-4ae9-b0eb-71300f4eb1ac@linux.ibm.com/

Link: https://lore.kernel.org/20260418080226.40415-1-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-stale-kdump-project-url
+++ a/MAINTAINERS
@@ -13860,7 +13860,6 @@ M:	Pratyush Yadav <pratyush@kernel.org>
 R:	Dave Young <ruirui.yang@linux.dev>
 L:	kexec@lists.infradead.org
 S:	Maintained
-W:	http://lse.sourceforge.net/kdump/
 F:	Documentation/admin-guide/kdump/
 F:	fs/proc/vmcore.c
 F:	include/linux/crash_core.h
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are


