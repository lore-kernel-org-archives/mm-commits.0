From: akpm@linux-foundation.org
Subject: + printk-add-console_suspend-module-parameter.patch added to -mm tree
Date: Tue, 23 Aug 2011 13:39:04 -0700
Message-ID: <201108232039.p7NKd4DQ005248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756021Ab1HWUjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 16:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com


The patch titled
     printk: add console_suspend module parameter
has been added to the -mm tree.  Its filename is
     printk-add-console_suspend-module-parameter.patch

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
Subject: printk: add console_suspend module parameter
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Return-Path: <yanmin_zhang@linux.intel.com>
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id p7N38YW2023258
	for <akpm@localhost>; Mon, 22 Aug 2011 20:08:34 -0700
Received: from imap1.linux-foundation.org [140.211.169.55]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Mon, 22 Aug 2011 20:08:34 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id p7N35YCE023051
	for <akpm@imap1.linux-foundation.org>; Mon, 22 Aug 2011 20:05:34 -0700
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p7N35Rjc014559
	for <akpm@linux-foundation.org>; Mon, 22 Aug 2011 20:05:28 -0700
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP; 22 Aug 2011 20:05:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="41170840"
Received: from ymzhang.sh.intel.com (HELO [10.239.72.78]) ([10.239.72.78])
  by orsmga001.jf.intel.com with ESMTP; 22 Aug 2011 20:05:26 -0700
Subject: [PATCH V2] printk:add console_suspend module parameter
Reply-To: yanmin_zhang@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 23 Aug 2011 11:04:32 +0800
Message-ID: <1314068672.1749.6.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Received-SPF: none (domain of yanmin_zhang@linux.intel.com does not designate permitted sender hosts)
X-Spam-Status: No, hits=-3.95 required=5 tests=AWL,BAYES_00,OSDL_HEADER_SUBJECT_BRACKETED
X-Spam-Checker-Version: SpamAssassin 3.2.4-osdl_revision__1.47__
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13

We are enabling some power features on medfield. To test suspend-2-RAM
conveniently, we need turn on/off console_suspend_enabled frequently.

Below patch adds a module parameter, so users could change it by:
/sys/module/printk/parameters/console_suspend

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>

---

 Documentation/kernel-parameters.txt |    5 +++++
 kernel/printk.c                     |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 614d038..74446e0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1642,6 +1642,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			debugging driver suspend/resume hooks).  This may
 			not work reliably with all consoles, but is known
 			to work with serial and VGA consoles.
+			To facilitate more flexible debugging, we also add
+			console_suspend, a printk module parameter to control
+			it. Users could use console_suspend (usually
+			/sys/module/printk/parameters/console_suspend) to
+			turn on/off it dynamically.
 
 	noaliencache	[MM, NUMA, SLAB] Disables the allocation of alien
 			caches in the slab allocator.  Saves per-node memory,
diff --git a/kernel/printk.c b/kernel/printk.c
index 836a2ae..b9ef93a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1108,6 +1108,10 @@ static int __init console_suspend_disable(char *str)
 	return 1;
 }
 __setup("no_console_suspend", console_suspend_disable);
+module_param_named(console_suspend, console_suspend_enabled,
+		bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(console_suspend, "suspend console during suspend"
+	" and hibernate operations");
 
 /**
  * suspend_console - suspend the console subsystem
-- 
1.7.1



Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel.patch
printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix.patch
printk-add-console_suspend-module-parameter.patch

