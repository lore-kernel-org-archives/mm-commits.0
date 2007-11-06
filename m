From: akpm@linux-foundation.org
Subject: - dump-stack-during-sysctl-registration-failure.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:51:56 -0800
Message-ID: <200711060551.lA65puGY007134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbXKFFw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:52:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Dump stack during sysctl registration failure
has been removed from the -mm tree.  Its filename was
     dump-stack-during-sysctl-registration-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dump stack during sysctl registration failure
From: Alexey Dobriyan <adobriyan@gmail.com>

Let's make immediately obvious from where sysctl comes from and messages
itself more noticeable.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sysctl_check.c~dump-stack-during-sysctl-registration-failure kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~dump-stack-during-sysctl-registration-failure
+++ a/kernel/sysctl_check.c
@@ -1432,6 +1432,7 @@ static void set_fail(const char **fail, 
 		printk(KERN_ERR "sysctl table check failed: ");
 		sysctl_print_path(table);
 		printk(" %s\n", *fail);
+		dump_stack();
 	}
 	*fail = str;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
