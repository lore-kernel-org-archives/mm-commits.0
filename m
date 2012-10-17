From: akpm@linux-foundation.org
Subject: [merged] drm-fix-radeon-printk-format-warnings.patch removed from -mm tree
Date: Wed, 17 Oct 2012 14:17:24 -0700
Message-ID: <20121017211725.0BB335C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47937 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab2JQVR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 17:17:27 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so489002eek.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 14:17:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm: fix radeon printk format warnings
has been removed from the -mm tree.  Its filename was
     drm-fix-radeon-printk-format-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
olpc-fix-olpc-xo1-scic-build-errors.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch
mutex-subsystem-synchro-test-module-fix-3.patch

