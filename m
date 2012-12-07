From: akpm@linux-foundation.org
Subject: + remove-stale-entry-for-generated-versionh-file-in-gitignore.patch added to -mm tree
Date: Fri, 07 Dec 2012 13:48:14 -0800
Message-ID: <20121207214815.1317E200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:52339 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab2LGVsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 16:48:17 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so59935wib.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 13:48:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jonathan.austin@arm.com, kevin.petit@arm.com


The patch titled
     Subject: .gitignore: remove stale entry for generated version.h
has been added to the -mm tree.  Its filename is
     remove-stale-entry-for-generated-versionh-file-in-gitignore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jonathan Austin <jonathan.austin@arm.com>
Subject: .gitignore: remove stale entry for generated version.h

Since userspace headers were moved to generated/uapi it possible to have a
stale copy of linux/version.h at that file's old location.  This causes
confusion after building an older kernel version, then checking out and
building a new one; the old (stale) version header will still get picked
up until it is manually removed.  This upsets the C library.

Since the uapi changes, include/linux/version.h is no longer generated and
should not be ignored, so this patch removes it from .gitignore.

Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
Reported-by: Kevin Petit <kevin.petit@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    1 -
 1 file changed, 1 deletion(-)

diff -puN .gitignore~remove-stale-entry-for-generated-versionh-file-in-gitignore .gitignore
--- a/.gitignore~remove-stale-entry-for-generated-versionh-file-in-gitignore
+++ a/.gitignore
@@ -60,7 +60,6 @@ modules.builtin
 # Generated include files
 #
 include/config
-include/linux/version.h
 include/generated
 arch/*/include/generated
 
_

Patches currently in -mm which might be from jonathan.austin@arm.com are

remove-stale-entry-for-generated-versionh-file-in-gitignore.patch

