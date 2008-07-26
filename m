From: akpm@linux-foundation.org
Subject: - kernel-kexecc-make-kimage_terminate-void.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:14:06 -0700
Message-ID: <200807262114.m6QLE61M019670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757508AbYGZVOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, ebiederm@xmission.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     kernel/kexec.c: make 'kimage_terminate' void
has been removed from the -mm tree.  Its filename was
     kernel-kexecc-make-kimage_terminate-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/kexec.c: make 'kimage_terminate' void
From: WANG Cong <xiyou.wangcong@gmail.com>

Since kimage_terminate() always returns 0, make it void.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN kernel/kexec.c~kernel-kexecc-make-kimage_terminate-void kernel/kexec.c
--- a/kernel/kexec.c~kernel-kexecc-make-kimage_terminate-void
+++ a/kernel/kexec.c
@@ -589,14 +589,12 @@ static void kimage_free_extra_pages(stru
 	kimage_free_page_list(&image->unuseable_pages);
 
 }
-static int kimage_terminate(struct kimage *image)
+static void kimage_terminate(struct kimage *image)
 {
 	if (*image->entry != 0)
 		image->entry++;
 
 	*image->entry = IND_DONE;
