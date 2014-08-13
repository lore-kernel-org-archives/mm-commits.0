From: akpm@linux-foundation.org
Subject: + scripts-tagssh-fix-regex-syntax-for-etags.patch added to -mm
 tree
Date: Wed, 13 Aug 2014 15:20:48 -0700
Message-ID: <53ebe4c0.KhlwpsxgSZsSP4Jb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:38209 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaHMWUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 18:20:49 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so54655yha.2
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 15:20:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rhapsodist@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: fix regex syntax for etags
has been added to the -mm tree.  Its filename is
     scripts-tagssh-fix-regex-syntax-for-etags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-fix-regex-syntax-for-etags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-fix-regex-syntax-for-etags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-tagssh-fix-regex-syntax-for-etags.patch

