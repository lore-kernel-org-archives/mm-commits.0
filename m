From: akpm@linux-foundation.org
Subject: + quota-remove-compatibility-function-sb_any_quota_enabled.patch added to -mm tree
Date: Mon, 27 Oct 2008 22:56:12 -0700
Message-ID: <200810280556.m9S5uCL5013456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbYJ1GAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: remove compatibility function sb_any_quota_enabled()
has been added to the -mm tree.  Its filename is
     quota-remove-compatibility-function-sb_any_quota_enabled.patch

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
Subject: quota: remove compatibility function sb_any_quota_enabled()
From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quotaops.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/quotaops.h~quota-remove-compatibility-function-sb_any_quota_enabled include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-remove-compatibility-function-sb_any_quota_enabled
+++ a/include/linux/quotaops.h
@@ -116,9 +116,6 @@ static inline int sb_any_quota_active(st
 	       sb_has_quota_active(sb, GRPQUOTA);
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * Operations supported for diskquotas.
  */
@@ -262,9 +259,6 @@ static inline int sb_any_quota_active(st
 	return 0;
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * NO-OP when quota not configured.
  */
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort.patch
ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort.patch
quota-add-callbacks-for-allocating-and-destroying-dquot-structures.patch
quota-increase-size-of-variables-for-limits-and-inode-usage.patch
quota-remove-bogus-optimization-in-check_idq-and-check_bdq.patch
quota-make-_suspended-just-a-flag.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits.patch
ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
ext4-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
quota-remove-compatibility-function-sb_any_quota_enabled.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch

