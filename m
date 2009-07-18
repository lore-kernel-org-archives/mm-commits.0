From: akpm@linux-foundation.org
Subject: + gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch added to -mm tree
Date: Fri, 17 Jul 2009 17:05:05 -0700
Message-ID: <200907180005.n6I055Ev029197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756024AbZGRAFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 20:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, david-b@pacbell.net, dsilvers@simtec.co.uk, ext-jani.1.nikula@nokia.com


The patch titled
     gpio.h: fix warning for GENERIC_GPIO=n
has been added to the -mm tree.  Its filename is
     gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch

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
Subject: gpio.h: fix warning for GENERIC_GPIO=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build for CONFIG_GENERIC_GPIO=n, which causes this warning:

include/linux/gpio.h:93: warning: 'struct device' declared inside parameter list
include/linux/gpio.h:93: warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Daniel Silverstone <dsilvers@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gpio.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/gpio.h~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix include/linux/gpio.h
--- a/include/linux/gpio.h~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix
+++ a/include/linux/gpio.h
@@ -12,6 +12,8 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 
+struct device;
+
 /*
  * Some platforms don't support the GPIO programming interface.
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
maintainers-coalesce-name-and-email-address-lines.patch
lis3-add-power-management-functions-fix.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
reiser4-export-remove_from_page_cache-fix.patch

