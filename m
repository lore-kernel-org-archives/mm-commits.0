From: akpm@linux-foundation.org
Subject: [patch 048/111] firmware: provide infrastructure to make fw
 caching optional
Date: Tue, 02 Aug 2016 14:04:25 -0700
Message-ID: <57a10ad9.ceG9tmDmtLPt4DAR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbcHBVRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, markivx@codeaurora.org, broonie@kernel.org, gregkh@linuxfoundation.org, ming.lei@canonical.com, stephen.boyd@linaro.org, zohar@linux.vnet.ibm.com

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
