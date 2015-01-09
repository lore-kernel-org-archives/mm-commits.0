From: akpm@linux-foundation.org
Subject: + ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch added to -mm tree
Date: Fri, 09 Jan 2015 15:35:27 -0800
Message-ID: <54b065bf.UF40w2SGctLlkPVM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbbAIXf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 18:35:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix snprintf format specifier in dlmdebug.c
has been added to the -mm tree.  Its filename is
     ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: fix snprintf format specifier in dlmdebug.c

Use snprintf format specifier "%lu" instead of "%ld" for argument of type
'unsigned long'.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdebug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdebug.c~ocfs2-fix-snprintf-format-specifier-in-dlmdebugc fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-fix-snprintf-format-specifier-in-dlmdebugc
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -406,7 +406,7 @@ static int debug_purgelist_print(struct
 	}
 	spin_unlock(&dlm->spinlock);
 
-	out += snprintf(buf + out, len - out, "Total on list: %ld\n", total);
+	out += snprintf(buf + out, len - out, "Total on list: %lu\n", total);
 
 	return out;
 }
@@ -464,7 +464,7 @@ static int debug_mle_print(struct dlm_ct
 	spin_unlock(&dlm->master_lock);
 
 	out += snprintf(buf + out, len - out,
-			"Total: %ld, Longest: %ld\n", total, longest);
+			"Total: %lu, Longest: %lu\n", total, longest);
 	return out;
 }
 
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch
ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch
ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
ocfs2-implement-ocfs2_direct_io_write.patch

