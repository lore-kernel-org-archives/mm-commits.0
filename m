From: akpm@linux-foundation.org
Subject: [merged]
 bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:35:29 -0700
Message-ID: <53446ba1.1oTtZqk6p+se2HoX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHVf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:35:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, arnd@arndb.de, josh@joshtriplett.org

Subject: [merged] bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch removed from -mm tree
To: josh@joshtriplett.org,arnd@arndb.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:35:29 -0700


The patch titled
     Subject: bug: when !CONFIG_BUG, make WARN call no_printk to check format and args
has been removed from the -mm tree.  Its filename was
     bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: bug: when !CONFIG_BUG, make WARN call no_printk to check format and args

The stub version of WARN for !CONFIG_BUG completely ignored its format
string and subsequent arguments; make it check them instead, using
no_printk.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/bug.h~bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args
+++ a/include/asm-generic/bug.h
@@ -155,6 +155,7 @@ extern void warn_slowpath_null(const cha
 #ifndef WARN
 #define WARN(condition, format...) ({					\
 	int __ret_warn_on = !!(condition);				\
+	no_printk(format);						\
 	unlikely(__ret_warn_on);					\
 })
 #endif
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch

