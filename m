From: akpm@linux-foundation.org
Subject: + drivers-dax-avoiding-potential-deadlock.patch added to -mm tree
Date: Tue, 11 Apr 2017 13:58:48 -0700
Message-ID: <58ed4388.wIith/0hou0FNUjS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753547AbdDKU6t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2017 16:58:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pushkar.iit@gmail.com, dan.j.williams@intel.com, dave.jiang@intel.com, jthumshirn@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/dax/dax.c: avoid potential deadlock
has been added to the -mm tree.  Its filename is
     drivers-dax-avoiding-potential-deadlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dax-avoiding-potential-deadlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dax-avoiding-potential-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Subject: drivers/dax/dax.c: avoid potential deadlock

dax_dev_huge_fault() returns without releasing rcu_read_lock().  Make code
change to avoid this situation

Link: http://lkml.kernel.org/r/1491888405-7772-1-git-send-email-pushkar.iit@gmail.com
Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dax/dax.c~drivers-dax-avoiding-potential-deadlock drivers/dax/dax.c
--- a/drivers/dax/dax.c~drivers-dax-avoiding-potential-deadlock
+++ a/drivers/dax/dax.c
@@ -590,7 +590,7 @@ static int dax_dev_huge_fault(struct vm_
 		rc = __dax_dev_pud_fault(dax_dev, vmf);
 		break;
 	default:
-		return VM_FAULT_FALLBACK;
+		rc = VM_FAULT_FALLBACK;
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from pushkar.iit@gmail.com are

drivers-dax-avoiding-potential-deadlock.patch
drivers-dax-changing-rc-value.patch
mm-include-linux-migrateh-fixing-checkpatch-warning-regarding-function-definition.patch

