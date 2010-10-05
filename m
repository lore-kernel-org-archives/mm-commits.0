From: akpm@linux-foundation.org
Subject: + cgroups-add-check-for-strcpy-destination-string-overflow.patch added to -mm tree
Date: Tue, 05 Oct 2010 13:08:35 -0700
Message-ID: <201010052008.o95K8ZsC017162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab0JEUIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 16:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-eugeny.kuznetsov@nokia.com, EXT-Eugeny.Kuznetsov@nokia.com, menage@google.com


The patch titled
     cgroups: add check for strcpy destination string overflow
has been added to the -mm tree.  Its filename is
     cgroups-add-check-for-strcpy-destination-string-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add check for strcpy destination string overflow
From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>

Function "strcpy" is used without check for maximum allowed source string
length and could cause destination string overflow.  Check for string
length is added before using "strcpy".  Function now is return error if
source string length is more than a maximum.

akpm: presently considered NotABug, but add the check for general
future-safeness and robustness.

Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cgroup.c~cgroups-add-check-for-strcpy-destination-string-overflow kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-check-for-strcpy-destination-string-overflow
+++ a/kernel/cgroup.c
@@ -1921,6 +1921,8 @@ static int cgroup_release_agent_write(st
 				      const char *buffer)
 {
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
+	if (strlen(buffer) >= PATH_MAX)
+		return -EINVAL;
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 	strcpy(cgrp->root->release_agent_path, buffer);
_

Patches currently in -mm which might be from ext-eugeny.kuznetsov@nokia.com are

cgroups-add-check-for-strcpy-destination-string-overflow.patch

