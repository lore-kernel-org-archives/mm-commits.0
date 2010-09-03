From: akpm@linux-foundation.org
Subject: + proc-vmcore-fix-seeking.patch added to -mm tree
Date: Fri, 03 Sep 2010 13:59:07 -0700
Message-ID: <201009032059.o83Kx79s011995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab0ICU7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 16:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, caiqian@redhat.com, fweisbec@gmail.com, stable@kernel.org


The patch titled
     /proc/vmcore: fix seeking
has been added to the -mm tree.  Its filename is
     proc-vmcore-fix-seeking.patch

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
Subject: /proc/vmcore: fix seeking
From: Arnd Bergmann <arnd@arndb.de>

Commit 73296bc611 "procfs: Use generic_file_llseek in /proc/vmcore" broke
seeking on /proc/vmcore.  This changes it back to use default_llseek in
order to restore the original behaviour.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: CAI Qian <caiqian@redhat.com>
Tested-by: CAI Qian <caiqian@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/vmcore.c~proc-vmcore-fix-seeking fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~proc-vmcore-fix-seeking
+++ a/fs/proc/vmcore.c
@@ -163,7 +163,7 @@ static ssize_t read_vmcore(struct file *
 
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
-	.llseek		= generic_file_llseek,
+	.llseek		= default_llseek,
 };
 
 static struct vmcore* __init get_new_element(void)
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
proc-vmcore-fix-seeking.patch

