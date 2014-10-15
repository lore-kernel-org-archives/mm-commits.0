From: akpm@linux-foundation.org
Subject: + kexec-remove-unnecessary-kern_err-from-kexecc.patch added to
 -mm tree
Date: Wed, 15 Oct 2014 13:51:29 -0700
Message-ID: <543ede51.c6nk7MxY7LtaMFZi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaJOUv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 16:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove unnecessary KERN_ERR from kexec.c
has been added to the -mm tree.  Its filename is
     kexec-remove-unnecessary-kern_err-from-kexecc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-remove-unnecessary-kern_err-from-kexecc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-remove-unnecessary-kern_err-from-kexecc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kexec-remove-unnecessary-kern_err-from-kexecc.patch
linux-next.patch

