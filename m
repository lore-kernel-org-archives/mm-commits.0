From: akpm@linux-foundation.org
Subject: [wrecked] scripts-tagssh-fix-regex-syntax-for-etags.patch removed from -mm tree
Date: Thu, 21 Aug 2014 13:28:28 -0700
Message-ID: <53f6566c.LSCYwvbgL0iWclkO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:41181 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaHUU2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 16:28:34 -0400
Received: by mail-qg0-f74.google.com with SMTP id a108so790463qge.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 13:28:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rhapsodist@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: fix regex syntax for etags
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-fix-regex-syntax-for-etags.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Sungwook Jung <rhapsodist@gmail.com>
Subject: scripts/tags.sh: fix regex syntax for etags

Fix regexp syntax to run TAGS command correctly regarding below patches.
 - [79c704a] add regular expression replacement pattern for memcg
 - [3005286] add pattern for DEFINE_HASHTABLE

Signed-off-by: Sungwook Jung <rhapsodist@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN scripts/tags.sh~scripts-tagssh-fix-regex-syntax-for-etags scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-fix-regex-syntax-for-etags
+++ a/scripts/tags.sh
@@ -256,14 +256,14 @@ emacs()
 	--regex='/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
 	--regex='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
-	--regex='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'	\
-	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
-	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
-	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+	--regex='/TESTPCGFLAG(\([^,)]*\).*/PageCgroup\1/'	\
+	--regex='/SETPCGFLAG(\([^,)]*\).*/SetPageCgroup\1/'	\
+	--regex='/CLEARPCGFLAG(\([^,)]*\).*/ClearPageCgroup\1/'	\
+	--regex='/TESTCLEARPCGFLAG(\([^,)]*\).*/TestClearPageCgroup\1/' \
 	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
 	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
-	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'\
-	--regex='/DEFINE_HASHTABLE\((\w*)/\1/v/'
+	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/' \
+	--regex='/DEFINE_HASHTABLEE(\([a-z]*[a-z]\)/\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
_

Patches currently in -mm which might be from rhapsodist@gmail.com are


