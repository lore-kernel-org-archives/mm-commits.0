From: akpm@linux-foundation.org
Subject: + drm-simplify-kcalloc-call-to-kzalloc.patch added to -mm tree
Date: Mon, 27 Apr 2009 12:01:57 -0700
Message-ID: <200904271901.n3RJ1vlM000984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018AbZD0TER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 15:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, airlied@linux.ie, eric@anholt.net


The patch titled
     drm: simplify kcalloc() call to kzalloc().
has been added to the -mm tree.  Its filename is
     drm-simplify-kcalloc-call-to-kzalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: simplify kcalloc() call to kzalloc().
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Calls to kcalloc() for a single element can be simplified to calls to
kzalloc().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/drm_gem.c~drm-simplify-kcalloc-call-to-kzalloc drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-simplify-kcalloc-call-to-kzalloc
+++ a/drivers/gpu/drm/drm_gem.c
@@ -133,7 +133,7 @@ drm_gem_object_alloc(struct drm_device *
 
 	BUG_ON((size & (PAGE_SIZE - 1)) != 0);
 
-	obj = kcalloc(1, sizeof(*obj), GFP_KERNEL);
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 
 	obj->dev = dev;
 	obj->filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
drm-simplify-kcalloc-call-to-kzalloc.patch
makefile-make-prepare-should-be-make-modules_prepare.patch
kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch
mm-rewrite-some-tests-with-is_power_of_2-for-clarity.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

