From: akpm@linux-foundation.org
Subject: + kernel-kexecc-make-kimage_terminate-void.patch added to -mm tree
Date: Tue, 24 Jun 2008 13:50:54 -0700
Message-ID: <200806242050.m5OKosev005396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbYFXUu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 16:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, ebiederm@xmission.com, wangcong@zeuux.org


The patch titled
     kernel/kexec.c: make 'kimage_terminate' void
has been added to the -mm tree.  Its filename is
     kernel-kexecc-make-kimage_terminate-void.patch

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
