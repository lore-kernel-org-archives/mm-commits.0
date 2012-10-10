From: akpm@linux-foundation.org
Subject: + drm-fix-radeon-printk-format-warnings.patch added to -mm tree
Date: Wed, 10 Oct 2012 14:09:19 -0700
Message-ID: <20121010210919.9CADD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42436 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2JJVJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 17:09:20 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so134125qae.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 14:09:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, airlied@linux.ie


The patch titled
     Subject: drm: fix radeon printk format warnings
has been added to the -mm tree.  Its filename is
     drm-fix-radeon-printk-format-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: drm: fix radeon printk format warnings

Fix printk format warnings in gpu/drm/radeon/:

drivers/gpu/drm/radeon/radeon_atpx_handler.c:151:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
drivers/gpu/drm/radeon/radeon_acpi.c:204:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
drivers/gpu/drm/radeon/radeon_acpi.c:488:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_acpi.c         |    4 ++--
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/gpu/drm/radeon/radeon_acpi.c~drm-fix-radeon-printk-format-warnings drivers/gpu/drm/radeon/radeon_acpi.c
--- a/drivers/gpu/drm/radeon/radeon_acpi.c~drm-fix-radeon-printk-format-warnings
+++ a/drivers/gpu/drm/radeon/radeon_acpi.c
@@ -201,7 +201,7 @@ static int radeon_atif_verify_interface(
 
 	size = *(u16 *) info->buffer.pointer;
 	if (size < 12) {
-		DRM_INFO("ATIF buffer is too small: %lu\n", size);
+		DRM_INFO("ATIF buffer is too small: %zu\n", size);
 		err = -EINVAL;
 		goto out;
 	}
@@ -485,7 +485,7 @@ static int radeon_atcs_verify_interface(
 
 	size = *(u16 *) info->buffer.pointer;
 	if (size < 8) {
-		DRM_INFO("ATCS buffer is too small: %lu\n", size);
+		DRM_INFO("ATCS buffer is too small: %zu\n", size);
 		err = -EINVAL;
 		goto out;
 	}
diff -puN drivers/gpu/drm/radeon/radeon_atpx_handler.c~drm-fix-radeon-printk-format-warnings drivers/gpu/drm/radeon/radeon_atpx_handler.c
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c~drm-fix-radeon-printk-format-warnings
+++ a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -148,7 +148,7 @@ static int radeon_atpx_verify_interface(
 
 	size = *(u16 *) info->buffer.pointer;
 	if (size < 8) {
-		printk("ATPX buffer is too small: %lu\n", size);
+		printk("ATPX buffer is too small: %zu\n", size);
 		err = -EINVAL;
 		goto out;
 	}
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
memcg-kmem-fix-build-error-when-config_inet-is-disabled.patch
olpc-fix-olpc-xo1-scic-build-errors.patch
drm-fix-radeon-printk-format-warnings.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

