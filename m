From: akpm@linux-foundation.org
Subject: +
 kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4.patch added to -mm tree
Date: Tue, 26 Jan 2016 19:41:56 -0800
Message-ID: <56a83c84.X3vKYlWwEv1CIgh/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbcA0Dl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, mhuang@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4
has been added to the -mm tree.  Its filename is
     kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4

Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Minfei Huang <mhuang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec_file.c~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4 kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4
+++ a/kernel/kexec_file.c
@@ -382,7 +382,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 exchange:
 	image = xchg(dest_image, image);
 out:
-	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
+	if ((flags & KEXEC_FILE_ON_CRASH) && kexec_crash_image)
 		arch_kexec_protect_crashkres();
 
 	mutex_unlock(&kexec_mutex);
_

Patches currently in -mm which might be from xlpang@redhat.com are

kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch
kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4.patch
kexec-provide-arch_kexec_protectunprotect_crashkres.patch
kexec-provide-arch_kexec_protectunprotect_crashkres-v4.patch

