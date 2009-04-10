From: akpm@linux-foundation.org
Subject: + jbd-update-locking-coments.patch added to -mm tree
Date: Thu, 09 Apr 2009 21:41:54 -0700
Message-ID: <200904100441.n3A4fspd024831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412AbZDJEnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 00:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, tammy000@gmail.com


The patch titled
     jbd: update locking coments
has been added to the -mm tree.  Its filename is
     jbd-update-locking-coments.patch

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
Subject: jbd: update locking coments
From: Jan Kara <jack@suse.cz>

Update information about locking in JBD revoke code.

Reported-by: Lin Tan <tammy000@gmail.com>.
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/revoke.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN fs/jbd/revoke.c~jbd-update-locking-coments fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~jbd-update-locking-coments
+++ a/fs/jbd/revoke.c
@@ -55,6 +55,25 @@
  *			need do nothing.
  * RevokeValid set, Revoked set:
  *			buffer has been revoked.
+ *
+ * Locking rules:
+ * We keep two hash tables of revoke records. One hashtable belongs to the
+ * running transaction (is pointed to by journal->j_revoke), the other one
+ * belongs to the committing transaction. Accesses to the second hash table
+ * happen only from the kjournald and no other thread touches this table.  Also
+ * journal_switch_revoke_table() which switches which hashtable belongs to the
+ * running and which to the committing transaction is called only from
+ * kjournald. Therefore we need no locks when accessing the hashtable belonging
+ * to the committing transaction.
+ *
+ * All users operating on the hash table belonging to the running transaction
+ * have a handle to the transaction. Therefore they are safe from kjournald
+ * switching hash tables under them. For operations on the lists of entries in
+ * the hash table j_revoke_lock is used.
+ *
+ * Finally, also replay code uses the hash tables but at this moment noone else
+ * can touch them (filesystem isn't mounted yet) and hence no locking is
+ * needed.
  */
 
 #ifndef __KERNEL__
@@ -402,8 +421,6 @@ int journal_revoke(handle_t *handle, uns
  * the second time we would still have a pending revoke to cancel.  So,
  * do not trust the Revoked bit on buffers unless RevokeValid is also
  * set.
- *
- * The caller must have the journal locked.
  */
 int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 {
@@ -481,10 +498,7 @@ void journal_switch_revoke_table(journal
 /*
  * Write revoke records to the journal for all entries in the current
  * revoke hash, deleting the entries as we go.
- *
- * Called with the journal lock held.
  */
