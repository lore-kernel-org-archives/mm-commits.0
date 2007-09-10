From: akpm@linux-foundation.org
Subject: + store-__setup_str_-in-a-more-compact-way.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:51:53 -0700
Message-ID: <200709100851.l8A8prX1016080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755920AbXIJIv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com


The patch titled
     store __setup_str_* in a more compact way
has been added to the -mm tree.  Its filename is
     store-__setup_str_-in-a-more-compact-way.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: store __setup_str_* in a more compact way
From: "Jan Beulich" <jbeulich@novell.com>

__setup_str_* are referenced only during boot, hence there's no need to
waste image space for aligning these strings (with the aim of improving
performance).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/init.h~store-__setup_str_-in-a-more-compact-way include/linux/init.h
--- a/include/linux/init.h~store-__setup_str_-in-a-more-compact-way
+++ a/include/linux/init.h
@@ -159,7 +159,7 @@ struct obs_kernel_param {
  * obs_kernel_param "array" too far apart in .init.setup.
  */
 #define __setup_param(str, unique_id, fn, early)			\
-	static char __setup_str_##unique_id[] __initdata = str;	\
+	static char __setup_str_##unique_id[] __initdata __aligned(1) = str; \
 	static struct obs_kernel_param __setup_##unique_id	\
 		__attribute_used__				\
 		__attribute__((__section__(".init.setup")))	\
_

Patches currently in -mm which might be from jbeulich@novell.com are

revert-x86_64-mm-intel_cacheinfo-adjustments.patch
fix-x86_64-mm-unwinder.patch
floppy-tolerate-dma-channel-unavailability.patch
cleanup-floppyh.patch
handle-recursive-calls-to-bust_spinlocks.patch
store-__setup_str_-in-a-more-compact-way.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
