From: akpm@linux-foundation.org
Subject: + sysctl-check-for-bogus-modes.patch added to -mm tree
Date: Thu, 29 May 2008 09:01:29 -0700
Message-ID: <200805291601.m4TG1TFG010035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbYE2QCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 12:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@parallels.com, ebiederm@xmission.com


The patch titled
     sysctl: check for bogus modes
has been added to the -mm tree.  Its filename is
     sysctl-check-for-bogus-modes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: check for bogus modes
From: Alexey Dobriyan <adobriyan@parallels.com>

Catch, e. g., 644/0644 typo.

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sysctl_check.c~sysctl-check-for-bogus-modes kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-check-for-bogus-modes
+++ a/kernel/sysctl_check.c
@@ -1532,6 +1532,8 @@ int sysctl_check_table(struct nsproxy *n
 			sysctl_check_leaf(namespaces, table, &fail);
 		}
 		sysctl_check_bin_path(table, &fail);
+		if (table->mode > 0777)
+			set_fail(&fail, table, "bogus .mode");
 		if (fail) {
 			set_fail(&fail, table, NULL);
 			error = -EINVAL;
_

Patches currently in -mm which might be from adobriyan@parallels.com are

sysctl-check-for-bogus-modes.patch

