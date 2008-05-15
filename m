From: akpm@linux-foundation.org
Subject: + add-a-warn-macro-this-is-warn_on-printk-arguments-fix-2.patch added to -mm tree
Date: Thu, 15 May 2008 16:43:00 -0700
Message-ID: <200805152343.m4FNh05j016564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761153AbYEOXnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com


The patch titled
     Fix WARN() for the !CONFIG_BUG case
has been added to the -mm tree.  Its filename is
     add-a-warn-macro-this-is-warn_on-printk-arguments-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix WARN() for the !CONFIG_BUG case
From: Arjan van de Ven <arjan@infradead.org>

For the CONFIG_BUG=n case we need to provide a stub WARN() macro;
do this in the same style as WARN_ON() is done.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/asm-generic/bug.h~add-a-warn-macro-this-is-warn_on-printk-arguments-fix-2 include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-a-warn-macro-this-is-warn_on-printk-arguments-fix-2
+++ a/include/asm-generic/bug.h
@@ -77,6 +77,14 @@ extern void warn_slowpath(const char *fi
 	unlikely(__ret_warn_on);					\
 })
 #endif
+
+#ifndef WARN
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
_

Patches currently in -mm which might be from arjan@infradead.org are

linux-next.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-unionfs.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix-2.patch

