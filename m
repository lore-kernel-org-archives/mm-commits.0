From: akpm@linux-foundation.org
Subject: [merged] kexec-remove-unnecessary-kern_err-from-kexecc.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:09:33 -0800
Message-ID: <548d0d7d.VHu02KH99GRJE8+H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaLNEJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove unnecessary KERN_ERR from kexec.c
has been removed from the -mm tree.  Its filename was
     kexec-remove-unnecessary-kern_err-from-kexecc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: kexec: remove unnecessary KERN_ERR from kexec.c

Remove unnecessary KERN_ERR from pr_err() within kexec.c.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec.c~kexec-remove-unnecessary-kern_err-from-kexecc kernel/kexec.c
--- a/kernel/kexec.c~kexec-remove-unnecessary-kern_err-from-kexecc
+++ a/kernel/kexec.c
@@ -600,7 +600,7 @@ kimage_file_alloc_init(struct kimage **r
 	if (!kexec_on_panic) {
 		image->swap_page = kimage_alloc_control_pages(image, 0);
 		if (!image->swap_page) {
-			pr_err(KERN_ERR "Could not allocate swap buffer\n");
+			pr_err("Could not allocate swap buffer\n");
 			goto out_free_control_pages;
 		}
 	}
_

Patches currently in -mm which might be from standby24x7@gmail.com are

origin.patch
linux-next.patch

