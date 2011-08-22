From: akpm@linux-foundation.org
Subject: + printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel.patch added to -mm tree
Date: Mon, 22 Aug 2011 16:25:35 -0700
Message-ID: <201108222325.p7MNPZuW013233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820Ab1HVXZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 19:25:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, yanmin.zhang@intel.com


The patch titled
     printk: add module parameter ignore_loglevel to control ignore_loglevel
has been added to the -mm tree.  Its filename is
     printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel.patch

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
Subject: printk: add module parameter ignore_loglevel to control ignore_loglevel
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>

We are enabling some power features on medfield.  To test suspend-2-RAM
conveniently, we need turn on/off ignore_loglevel frequently without
rebooting.

Add a module parameter, so users can change it by:
/sys/module/printk/parameters/ignore_loglevel

Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/printk.c~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel kernel/printk.c
--- a/kernel/printk.c~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel
+++ a/kernel/printk.c
@@ -532,6 +532,7 @@ static int __init ignore_loglevel_setup(
 }
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
+module_param_named(ignore_loglevel, ignore_loglevel, bool, S_IRUGO | S_IWUSR);
 
 /*
  * Write out chars from start to end - 1 inclusive
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

origin.patch
printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel.patch

