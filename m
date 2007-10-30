From: akpm@linux-foundation.org
Subject: + dump-stack-during-sysctl-registration-failure.patch added to -mm tree
Date: Tue, 30 Oct 2007 11:10:36 -0700
Message-ID: <200710301810.l9UIAakJ020712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbXJ3SLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ebiederm@xmission.com


The patch titled
     Dump stack during sysctl registration failure
has been added to the -mm tree.  Its filename is
     dump-stack-during-sysctl-registration-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

dump-stack-during-sysctl-registration-failure.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
