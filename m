From: akpm@linux-foundation.org
Subject: +
 kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch added to
 -mm tree
Date: Wed, 02 Dec 2015 13:44:09 -0800
Message-ID: <565f6629.hsvUHsSO5tMjBqm9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbbLBVoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: set KEXEC_TYPE_CRASH before sanity_check_segment_list()
has been added to the -mm tree.  Its filename is
     kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch

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
Subject: kexec: set KEXEC_TYPE_CRASH before sanity_check_segment_list()

sanity_check_segment_list() checks KEXEC_TYPE_CRASH flag to ensure all the
segments of the loaded crash kernel are within the kernel crash resource
limits, so set the flag beforehand.

Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/kexec.c~kexec-set-kexec_type_crash-before-sanity_check_segment_list kernel/kexec.c
--- a/kernel/kexec.c~kexec-set-kexec_type_crash-before-sanity_check_segment_list
+++ a/kernel/kexec.c
@@ -63,16 +63,16 @@ static int kimage_alloc_init(struct kima
 	if (ret)
 		goto out_free_image;
 
-	ret = sanity_check_segment_list(image);
-	if (ret)
-		goto out_free_image;
