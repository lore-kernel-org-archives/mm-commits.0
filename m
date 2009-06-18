From: akpm@linux-foundation.org
Subject: [merged] documentation-fix-inconsistent-description-of-futex-list_op_pending.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:46 -0700
Message-ID: <200906182247.n5IMlkod006828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758558AbZFRW6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, mingo@redhat.com, tglx@linuxtronix.de, mm-commits@vger.kernel.org


The patch titled
     futex: documentation: fix inconsistent description of futex list_op_pending
has been removed from the -mm tree.  Its filename was
     documentation-fix-inconsistent-description-of-futex-list_op_pending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: documentation: fix inconsistent description of futex list_op_pending
From: Matt Helsley <matthltc@us.ibm.com>

Strictly speaking list_op_pending points to the 'lock entry', not the
'lock word' (which is actually at 'offset' from 'lock entry').  We can
infer this based on reading the code in kernel/futex.c:

	    struct robust_list __user *entry, *next_entry, *pending;
		...
            if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
                    return;
            ...
            if (pending)
                    handle_futex_death((void __user *)pending + futex_offset,
                                       curr, pip);

Which is also consistent with the rest of the docs on robust futex lists.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linuxtronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/robust-futex-ABI.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/robust-futex-ABI.txt~documentation-fix-inconsistent-description-of-futex-list_op_pending Documentation/robust-futex-ABI.txt
--- a/Documentation/robust-futex-ABI.txt~documentation-fix-inconsistent-description-of-futex-list_op_pending
+++ a/Documentation/robust-futex-ABI.txt
@@ -135,7 +135,7 @@ manipulating this list), the user code m
 protocol on 'lock entry' insertion and removal:
 
 On insertion:
- 1) set the 'list_op_pending' word to the address of the 'lock word'
+ 1) set the 'list_op_pending' word to the address of the 'lock entry'
     to be inserted,
  2) acquire the futex lock,
  3) add the lock entry, with its thread id (TID) in the bottom 29 bits
@@ -143,7 +143,7 @@ On insertion:
  4) clear the 'list_op_pending' word.
 
 On removal:
- 1) set the 'list_op_pending' word to the address of the 'lock word'
+ 1) set the 'list_op_pending' word to the address of the 'lock entry'
     to be removed,
  2) remove the lock entry for this lock from the 'head' list,
  2) release the futex lock, and
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

origin.patch

