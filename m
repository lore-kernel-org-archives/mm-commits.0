Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D5C1D07BA;
	Tue,  1 Jul 2025 20:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751403346; cv=none; b=E1j98wNUECacZSMfDpcJZVRnYpJC+FlqUgvTBz+itqDBk1gEgeUzrvIkkJVtDI5/Is1evbOGmYWI9Xok8xC8jNCAW7UCUzuOYo0dWfmmto/u7bRoVXvzdHlrzZUYSZ9cm6tCenyWOS8u+D0JRtryPieTkkBT/jhReVgJJkqzJ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751403346; c=relaxed/simple;
	bh=Vs1fBYHjKhjmGj9zUFscYQR5COOQdNFBCFCSWtXEyyk=;
	h=Date:To:From:Subject:Message-Id; b=Tc/tzaDvPa/Y86hYEMVlJKcr8VZD49KGu2w2ZH7PPqekYc14UCzwK/3ir6KCDpav2UkYyejZWN5rQz7+VKjhxWFPHNnFMOaMB8IzWDXp56mnj6njbbWKvTJBeL0wW3wqJ2LVihmQmh4zXdbloiRJjhgJ7NY9SheMyGzyON0OGIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pOA0cWuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pOA0cWuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71599C4CEF1;
	Tue,  1 Jul 2025 20:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751403345;
	bh=Vs1fBYHjKhjmGj9zUFscYQR5COOQdNFBCFCSWtXEyyk=;
	h=Date:To:From:Subject:From;
	b=pOA0cWuhvAv91+SAM99Zus5CWDrcWnbPkWctexJENjSgdVGQAOifVhYdfHEAfDZw2
	 ZUhj+Kkqsrf5K51Lf6b85Wfu4Ou74mr4+TaWXetPBhzzpaN8pfHVGhVd0C0a+yXgbO
	 XtAdGKFCIpL640WBsGX7PUin0phgqpDL3DDLUByU=
Date: Tue, 01 Jul 2025 13:55:44 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,jack@suse.cz,florian.fainelli@broadcom.com,brauner@kernel.org,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-vfs-support-external-dentry-names.patch added to mm-hotfixes-unstable branch
Message-Id: <20250701205545.71599C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts: gdb: vfs: support external dentry names
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-vfs-support-external-dentry-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-vfs-support-external-dentry-names.patch

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
From: Illia Ostapyshyn <illia@yshyn.com>
Subject: scripts: gdb: vfs: support external dentry names
Date: Sun, 29 Jun 2025 02:38:11 +0200

d_shortname of struct dentry only reserves D_NAME_INLINE_LEN characters
and contains garbage for longer names.  Use d_name instead, which always
references the valid name.

Link: https://lore.kernel.org/all/20250525213709.878287-2-illia@yshyn.com/
Link: https://lkml.kernel.org/r/20250629003811.2420418-1-illia@yshyn.com
Fixes: 79300ac805b672a84b64 ("scripts/gdb: fix dentry_name() lookup")
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/vfs.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/vfs.py~scripts-gdb-vfs-support-external-dentry-names
+++ a/scripts/gdb/linux/vfs.py
@@ -22,7 +22,7 @@ def dentry_name(d):
     if parent == d or parent == 0:
         return ""
     p = dentry_name(d['d_parent']) + "/"
-    return p + d['d_shortname']['string'].string()
+    return p + d['d_name']['name'].string()
 
 class DentryName(gdb.Function):
     """Return string of the full path of a dentry.
_

Patches currently in -mm which might be from illia@yshyn.com are

scripts-gdb-vfs-support-external-dentry-names.patch

