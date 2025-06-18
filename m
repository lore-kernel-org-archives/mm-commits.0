Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9541465A5
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750286078; cv=none; b=in/oz3yegdMEcC6sK3JZYqRrsy4c3Tv9KsgByZ7xObmi09s2A4bhP5qTJGd7zMDAuUhgu2Z9HcZ0rPkoLDIY3LlrL4EiXoRbD50QZQHoj+kPubM4myC4xH9yL8A2mJSJtZ/66dNuJ/f7pQR9P8xKQwbSNzdpY91DQddxTz+plHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750286078; c=relaxed/simple;
	bh=+rG/wyi6MHGR6XI7lD8YVhtq2l636IjqLkk+VuserYU=;
	h=Date:To:From:Subject:Message-Id; b=GzHMb/yrWDRlVzH9c4vHXMAk6u48extyXewI7/wkVdAg2ejVudJc6vpmpwcy9RwR+843pSOZIrCXHze70yuHMEqWKmHFQ1JaXrvrx+CDyseOBr0XnWt1ecc64Nu5Ku+hQAFHKjgktb9LaqCcrrIHR6t/51FTGYlefBWLL54kR5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=agaJs+9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="agaJs+9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BB2C4CEE7;
	Wed, 18 Jun 2025 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750286077;
	bh=+rG/wyi6MHGR6XI7lD8YVhtq2l636IjqLkk+VuserYU=;
	h=Date:To:From:Subject:From;
	b=agaJs+9D4YX6wNef0msDh0rTFIBUg11IOL/uBeEjoT97nZDpq3/NKm3SPPvOfTFLv
	 e7xxeRpaWSKy7sN9+KUuTlO3VgB/E4ZCi2UuwHVZL/QgHV3BzzMvcNWaaw7oRcBp11
	 ui0xWg/ZMud40BHbPzpx+MnljZXXxKkApJb976hc=
Date: Wed, 18 Jun 2025 15:34:37 -0700
To: mm-commits@vger.kernel.org,stephen.s.brennan@oracle.com,kbingham@kernel.org,jan.kiszka@siemens.com,benjamin.berg@intel.com,johannes.berg@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-move-mnt_-constants-to-gdb-parsed.patch added to mm-nonmm-unstable branch
Message-Id: <20250618223437.C3BB2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts: gdb: move MNT_* constants to gdb-parsed
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-move-mnt_-constants-to-gdb-parsed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-move-mnt_-constants-to-gdb-parsed.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Johannes Berg <johannes.berg@intel.com>
Subject: scripts: gdb: move MNT_* constants to gdb-parsed
Date: Wed, 18 Jun 2025 15:46:02 +0200

Since these are now no longer defines, but in an enum.

Link: https://lkml.kernel.org/r/20250618134629.25700-2-johannes@sipsolutions.net
Fixes: 101f2bbab541 ("fs: convert mount flags to enum")
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-move-mnt_-constants-to-gdb-parsed
+++ a/scripts/gdb/linux/constants.py.in
@@ -73,12 +73,12 @@ if IS_BUILTIN(CONFIG_MODULES):
     LX_GDBPARSED(MOD_RO_AFTER_INIT)
 
 /* linux/mount.h */
-LX_VALUE(MNT_NOSUID)
-LX_VALUE(MNT_NODEV)
-LX_VALUE(MNT_NOEXEC)
-LX_VALUE(MNT_NOATIME)
-LX_VALUE(MNT_NODIRATIME)
-LX_VALUE(MNT_RELATIME)
+LX_GDBPARSED(MNT_NOSUID)
+LX_GDBPARSED(MNT_NODEV)
+LX_GDBPARSED(MNT_NOEXEC)
+LX_GDBPARSED(MNT_NOATIME)
+LX_GDBPARSED(MNT_NODIRATIME)
+LX_GDBPARSED(MNT_RELATIME)
 
 /* linux/threads.h */
 LX_VALUE(NR_CPUS)
_

Patches currently in -mm which might be from johannes.berg@intel.com are

scripts-gdb-move-mnt_-constants-to-gdb-parsed.patch

