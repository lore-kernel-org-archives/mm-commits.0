From: akpm@linux-foundation.org
Subject: [folded] kexec-premit-reduction-of-the-reserved-memory-size-fix.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:37:23 -0800
Message-ID: <200912160037.nBG0bNKs023838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755852AbZLPAi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:38:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, error27@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kexec-premit-reduction-of-the-reserved-memory-size-fix
has been removed from the -mm tree.  Its filename was
     kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

This patch was dropped because it was folded into kexec-premit-reduction-of-the-reserved-memory-size.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec-premit-reduction-of-the-reserved-memory-size-fix
From: Cong Wang <amwang@redhat.com>

kernel/ksysfs.c: In function `kexec_crash_size_show':
kernel/ksysfs.c:106: warning: format `%lu' expects type `long unsigned int', but argument 3 has type `size_t'

Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ksysfs.c~kexec-premit-reduction-of-the-reserved-memory-size-fix kernel/ksysfs.c
--- a/kernel/ksysfs.c~kexec-premit-reduction-of-the-reserved-memory-size-fix
+++ a/kernel/ksysfs.c
@@ -103,7 +103,7 @@ KERNEL_ATTR_RO(kexec_crash_loaded);
 static ssize_t kexec_crash_size_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", crash_get_memory_size());
+	return sprintf(buf, "%zu\n", crash_get_memory_size());
 }
 static ssize_t kexec_crash_size_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
ipc-remove-unreachable-code-in-semc.patch
ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

