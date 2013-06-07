From: akpm@linux-foundation.org
Subject: + ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler.patch
 added to -mm tree
Date: Fri, 07 Jun 2013 14:11:15 -0700
Message-ID: <51b24c73.+az/j2B0p1e9ZlP3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3FGVLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jun 2013 17:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 07 Jun 2013 14:11:15 -0700


The patch titled
     Subject: ocfs2: add missing lockres put in dlm_mig_lockres_handler
has been added to the -mm tree.  Its filename is
     ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: add missing lockres put in dlm_mig_lockres_handler

dlm_mig_lockres_handler() is missing a dlm_lockres_put() on an error path.

Signed-off-by: joyce <xuejiufei@huawei.com>
Reviewed-by: shencanquan <shencanquan@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1404,6 +1404,7 @@ int dlm_mig_lockres_handler(struct o2net
 				     mres->lockname_len, mres->lockname);
 				ret = -EFAULT;
 				spin_unlock(&res->spinlock);
+				dlm_lockres_put(res);
 				goto leave;
 			}
 			res->state |= DLM_LOCK_RES_MIGRATING;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

linux-next.patch
ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler.patch
ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch

