From: akpm@linux-foundation.org
Subject: [merged]
 kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:00:13 -0800
Message-ID: <56a162fd.iU2ssK7IlHYOIdbz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbcAUXAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:00:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: set KEXEC_TYPE_CRASH before sanity_check_segment_list()
has been removed from the -mm tree.  Its filename was
     kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Baoquan He <bhe@redhat.com>
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
