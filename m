From: akpm@linux-foundation.org
Subject: + wireless-iwlwifi-fix-debugfs_create_bools-error-checking.patch added to -mm tree
Date: Thu, 30 Oct 2008 13:07:13 -0700
Message-ID: <200810302007.m9UK7Ddf016957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbYJ3UHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 16:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaolei@cn.fujitsu.com, emmanuel.grumbach@intel.com, linville@tuxdriver.com, reinette.chatre@intel.com, tomas.winkler@intel.com, yi.zhu@intel.com


The patch titled
     wireless/iwlwifi/: fix debugfs_create_bool()'s error checking
has been added to the -mm tree.  Its filename is
     wireless-iwlwifi-fix-debugfs_create_bools-error-checking.patch

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
Subject: wireless/iwlwifi/: fix debugfs_create_bool()'s error checking
From: Zhao Lei <zhaolei@cn.fujitsu.com>

debugfs_create_bool() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-debugfs.c~wireless-iwlwifi-fix-debugfs_create_bools-error-checking drivers/net/wireless/iwlwifi/iwl-debugfs.c
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c~wireless-iwlwifi-fix-debugfs_create_bools-error-checking
+++ a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -58,7 +58,8 @@
 #define DEBUGFS_ADD_BOOL(name, parent, ptr) do {                        \
 	dbgfs->dbgfs_##parent##_files.file_##name =                     \
 	debugfs_create_bool(#name, 0644, dbgfs->dir_##parent, ptr);     \
-	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name))          \
+	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name)		\
+			|| !dbgfs->dbgfs_##parent##_files.file_##name)	\
 		goto err;                                               \
 } while (0)
 
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are

origin.patch
linux-next.patch
wireless-iwlwifi-fix-debugfs_create_bools-error-checking.patch

