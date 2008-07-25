From: akpm@linux-foundation.org
Subject: - sysctl-check-for-bogus-modes.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:19 -0700
Message-ID: <200807252302.m6PN2J9r003816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400AbYGYXC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@parallels.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: check for bogus modes
has been removed from the -mm tree.  Its filename was
     sysctl-check-for-bogus-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: check for bogus modes
From: Alexey Dobriyan <adobriyan@parallels.com>

Catch, e. g., 644/0644 typo.

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
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

origin.patch

