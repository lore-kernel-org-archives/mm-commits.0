From: akpm@linux-foundation.org
Subject: + kexec-premit-reduction-of-the-reserved-memory-size-fix.patch added to -mm tree
Date: Tue, 24 Nov 2009 14:46:34 -0800
Message-ID: <200911242246.nAOMkYjr004897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934252AbZKXWqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 17:46:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, error27@gmail.com


The patch titled
     kexec-premit-reduction-of-the-reserved-memory-size-fix
has been added to the -mm tree.  Its filename is
     kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

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

linux-next.patch
xtensa-use-generic-sys_pipe.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

