From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4.patch removed from -mm tree
Date: Tue, 22 Mar 2016 11:30:09 -0700
Message-ID: <56f18f31.1iX8cnTssOM/r2Hn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcCVSaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 14:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, mhuang@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4
has been removed from the -mm tree.  Its filename was
     kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory-v4.patch

This patch was dropped because it was folded into kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch

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
@@ -327,7 +327,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
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
kexec-provide-arch_kexec_protectunprotect_crashkres.patch
kexec-provide-arch_kexec_protectunprotect_crashkres-v4.patch

