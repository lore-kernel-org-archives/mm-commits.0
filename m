From: akpm@linux-foundation.org
Subject: +
 firmware-provide-infrastructure-to-make-fw-caching-optional.patch added to
 -mm tree
Date: Tue, 07 Jun 2016 13:26:26 -0700
Message-ID: <57572df2.TY1tqgXgOx7G5AIX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcFGU01 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 16:26:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markivx@codeaurora.org, broonie@kernel.org, gregkh@linuxfoundation.org, ming.lei@canonical.com, stephen.boyd@linaro.org, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware: provide infrastructure to make fw caching optional
has been added to the -mm tree.  Its filename is
     firmware-provide-infrastructure-to-make-fw-caching-optional.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-provide-infrastructure-to-make-fw-caching-optional.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-provide-infrastructure-to-make-fw-caching-optional.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vikram Mulukutla <markivx@codeaurora.org>
Subject: firmware: provide infrastructure to make fw caching optional

Some low memory systems with complex peripherals cannot afford to have the
relatively large firmware images taking up valuable memory during suspend
and resume.  Change the internal implementation of firmware_class to
disallow caching based on a configurable option.  In the near future,
variants of request_firmware will take advantage of this feature.

Link: http://lkml.kernel.org/r/20160607164741.31849-3-stephen.boyd@linaro.org
[stephen.boyd@linaro.org: Drop firmware_desc design and use flags]
Signed-off-by: Vikram Mulukutla <markivx@codeaurora.org>
Signed-off-by: Stephen Boyd <stephen.boyd@linaro.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/base/firmware_class.c~firmware-provide-infrastructure-to-make-fw-caching-optional drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-provide-infrastructure-to-make-fw-caching-optional
+++ a/drivers/base/firmware_class.c
@@ -112,6 +112,7 @@ static inline long firmware_loading_time
 #define FW_OPT_FALLBACK		0
 #endif
 #define FW_OPT_NO_WARN	(1U << 3)
+#define FW_OPT_NOCACHE	(1U << 4)
 
 struct firmware_cache {
 	/* firmware_buf instance will be added into the below list */
@@ -1065,14 +1066,16 @@ static int assign_firmware_buf(struct fi
 	 * should be fixed in devres or driver core.
 	 */
 	/* don't cache firmware handled without uevent */
-	if (device && (opt_flags & FW_OPT_UEVENT))
+	if (device && (opt_flags & FW_OPT_UEVENT) &&
+	    !(opt_flags & FW_OPT_NOCACHE))
 		fw_add_devm_name(device, buf->fw_id);
 
 	/*
 	 * After caching firmware image is started, let it piggyback
 	 * on request firmware.
 	 */
-	if (buf->fwc->state == FW_LOADER_START_CACHE) {
+	if (!(opt_flags & FW_OPT_NOCACHE) &&
+	    buf->fwc->state == FW_LOADER_START_CACHE) {
 		if (fw_cache_piggyback_on_request(buf->fw_id))
 			kref_get(&buf->ref);
 	}
_

Patches currently in -mm which might be from markivx@codeaurora.org are

firmware-provide-infrastructure-to-make-fw-caching-optional.patch

