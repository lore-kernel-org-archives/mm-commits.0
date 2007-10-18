From: akpm@linux-foundation.org
Subject: - store-__setup_str_-in-a-more-compact-way.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:43 -0700
Message-ID: <200710180659.l9I6xhTd031013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758452AbXJRHAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:00:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     store __setup_str_* in a more compact way
has been removed from the -mm tree.  Its filename was
     store-__setup_str_-in-a-more-compact-way.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -161,7 +161,7 @@ struct obs_kernel_param {
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

origin.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
