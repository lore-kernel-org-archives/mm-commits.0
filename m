From: akpm@linux-foundation.org
Subject: [merged] remove-stale-entry-for-generated-versionh-file-in-gitignore.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:00 -0800
Message-ID: <20121218200300.9B818100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45051 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:02 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so125130yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jonathan.austin@arm.com, kevin.petit@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: .gitignore: remove stale entry for generated version.h
has been removed from the -mm tree.  Its filename was
     remove-stale-entry-for-generated-versionh-file-in-gitignore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

