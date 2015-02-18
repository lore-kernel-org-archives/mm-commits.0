From: akpm@linux-foundation.org
Subject: [merged]
 kexec-remove-never-used-member-destination-in-kimage.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:02 -0800
Message-ID: <54e4eb46.psFrtaA+ENqmy538%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbbBRTnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove never used member destination  in kimage
has been removed from the -mm tree.  Its filename was
     kexec-remove-never-used-member-destination-in-kimage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: remove never used member destination  in kimage

struct kimage has a member destination which is used to store the real
destination address of each page when load segment from user space buffer
to kernel.  But we never retrieve the value stored in kimage->destination,
so this member variable in kimage and its assignment operation are
redundent code.

I guess for_each_kimage_entry just does the work that kimage->destination
is expected to do.

So in this patch just make a cleanup to remove it.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 --
 kernel/kexec.c        |    4 ----
 2 files changed, 6 deletions(-)

diff -puN include/linux/kexec.h~kexec-remove-never-used-member-destination-in-kimage include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-remove-never-used-member-destination-in-kimage
+++ a/include/linux/kexec.h
@@ -122,8 +122,6 @@ struct kimage {
 	kimage_entry_t *entry;
 	kimage_entry_t *last_entry;
 
-	unsigned long destination;
-
 	unsigned long start;
 	struct page *control_code_page;
 	struct page *swap_page;
diff -puN kernel/kexec.c~kexec-remove-never-used-member-destination-in-kimage kernel/kexec.c
--- a/kernel/kexec.c~kexec-remove-never-used-member-destination-in-kimage
+++ a/kernel/kexec.c
@@ -856,8 +856,6 @@ static int kimage_set_destination(struct
 
 	destination &= PAGE_MASK;
 	result = kimage_add_entry(image, destination | IND_DESTINATION);
-	if (result == 0)
-		image->destination = destination;
 
 	return result;
 }
@@ -869,8 +867,6 @@ static int kimage_add_page(struct kimage
 
 	page &= PAGE_MASK;
 	result = kimage_add_entry(image, page | IND_SOURCE);
-	if (result == 0)
-		image->destination += PAGE_SIZE;
 
 	return result;
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

origin.patch

