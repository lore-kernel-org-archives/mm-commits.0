From: akpm@linux-foundation.org
Subject: + anondev-switch-to-ida.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:59:47 -0700
Message-ID: <200808282359.m7SNxlB7021170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498AbYH1X7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     anondev: switch to IDA
has been added to the -mm tree.  Its filename is
     anondev-switch-to-ida.patch

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
Subject: anondev: switch to IDA
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/super.c~anondev-switch-to-ida fs/super.c
--- a/fs/super.c~anondev-switch-to-ida
+++ a/fs/super.c
@@ -682,7 +682,7 @@ void emergency_remount(void)
  * filesystems which don't use real block-devices.  -- jrs
  */
 
-static DEFINE_IDR(unnamed_dev_idr);
+static DEFINE_IDA(unnamed_dev_ida);
 static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
 
 int set_anon_super(struct super_block *s, void *data)
@@ -691,10 +691,10 @@ int set_anon_super(struct super_block *s
 	int error;
 
  retry:
-	if (idr_pre_get(&unnamed_dev_idr, GFP_ATOMIC) == 0)
+	if (ida_pre_get(&unnamed_dev_ida, GFP_ATOMIC) == 0)
 		return -ENOMEM;
 	spin_lock(&unnamed_dev_lock);
-	error = idr_get_new(&unnamed_dev_idr, NULL, &dev);
+	error = ida_get_new(&unnamed_dev_ida, &dev);
 	spin_unlock(&unnamed_dev_lock);
 	if (error == -EAGAIN)
 		/* We raced and lost with another CPU. */
@@ -704,7 +704,7 @@ int set_anon_super(struct super_block *s
 
 	if ((dev & MAX_ID_MASK) == (1 << MINORBITS)) {
 		spin_lock(&unnamed_dev_lock);
-		idr_remove(&unnamed_dev_idr, dev);
+		ida_remove(&unnamed_dev_ida, dev);
 		spin_unlock(&unnamed_dev_lock);
 		return -EMFILE;
 	}
@@ -720,7 +720,7 @@ void kill_anon_super(struct super_block 
 
 	generic_shutdown_super(sb);
 	spin_lock(&unnamed_dev_lock);
-	idr_remove(&unnamed_dev_idr, slot);
+	ida_remove(&unnamed_dev_ida, slot);
 	spin_unlock(&unnamed_dev_lock);
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
anondev-init-idr-statically.patch
anondev-switch-to-ida.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

