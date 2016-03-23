From: akpm@linux-foundation.org
Subject: [merged]
 amdkfd-use-in_compat_syscall-to-check-open-caller-type.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:40:55 -0700
Message-ID: <56f2d527.GV5NQh4+majqwVam%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbcCWRk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, airlied@linux.ie, oded.gabbay@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/amd/amdkfd: use in_compat_syscall to check open() caller type
has been removed from the -mm tree.  Its filename was
     amdkfd-use-in_compat_syscall-to-check-open-caller-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: drivers/gpu/drm/amd/amdkfd: use in_compat_syscall to check open() caller type

amdkfd wants to know syscall type, not task type.  Check directly.

Unfortunately, amdkfd is making nasty assumptions that a process' bitness
is a well-defined constant thing.  This isn't the case on x86.  I don't
know how much this matters, but this patch has no effect on generated code
on x86, so amdkfd is equally broken with and without this patch.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/amd/amdkfd/kfd_chardev.c~amdkfd-use-in_compat_syscall-to-check-open-caller-type drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c~amdkfd-use-in_compat_syscall-to-check-open-caller-type
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -107,7 +107,7 @@ static int kfd_open(struct inode *inode,
 	if (iminor(inode) != 0)
 		return -ENODEV;
 
-	is_32bit_user_mode = is_compat_task();
+	is_32bit_user_mode = in_compat_syscall();
 
 	if (is_32bit_user_mode == true) {
 		dev_warn(kfd_device,
diff -puN drivers/gpu/drm/amd/amdkfd/kfd_process.c~amdkfd-use-in_compat_syscall-to-check-open-caller-type drivers/gpu/drm/amd/amdkfd/kfd_process.c
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c~amdkfd-use-in_compat_syscall-to-check-open-caller-type
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -311,7 +311,7 @@ static struct kfd_process *create_proces
 		goto err_process_pqm_init;
 
 	/* init process apertures*/
-	process->is_32bit_user_mode = is_compat_task();
+	process->is_32bit_user_mode = in_compat_syscall();
 	if (kfd_init_apertures(process) != 0)
 		goto err_init_apretures;
 
_

Patches currently in -mm which might be from luto@kernel.org are


