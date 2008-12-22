From: akpm@linux-foundation.org
Subject: + smackfs-check-for-allocation-failures-in-smk_set_access.patch added to -mm tree
Date: Mon, 22 Dec 2008 15:29:13 -0800
Message-ID: <200812222329.mBMNTDX1028555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbYLVXbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 18:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergio@larces.uece.br, casey@schaufler-ca.com, darwish.07@gmail.com, jmorris@namei.org


The patch titled
     smackfs: check for allocation failures in smk_set_access()
has been added to the -mm tree.  Its filename is
     smackfs-check-for-allocation-failures-in-smk_set_access.patch

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
Subject: smackfs: check for allocation failures in smk_set_access()
From: Sergio Luis <sergio@larces.uece.br>

While adding a new subject/object pair to smack_list, smk_set_access()
didn't check the return of kzalloc().

This patch changes smk_set_access() to return 0 or -ENOMEM, based on
kzalloc()'s return.  It also updates its caller, smk_write_load(), to
check for smk_set_access()'s return, given it is no longer a void return
function.

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smackfs.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN security/smack/smackfs.c~smackfs-check-for-allocation-failures-in-smk_set_access security/smack/smackfs.c
--- a/security/smack/smackfs.c~smackfs-check-for-allocation-failures-in-smk_set_access
+++ a/security/smack/smackfs.c
@@ -206,11 +206,15 @@ static int smk_open_load(struct inode *i
  * the subject/object pair and replaces the access that was
  * there. If the pair isn't found add it with the specified
  * access.
+ *
+ * Returns 0 if nothing goes wrong or -ENOMEM if it fails
+ * during the allocation of the new pair to add.
  */
-static void smk_set_access(struct smack_rule *srp)
+static int smk_set_access(struct smack_rule *srp)
 {
 	struct smk_list_entry *sp;
 	struct smk_list_entry *newp;
+	int ret = 0;
 
 	mutex_lock(&smack_list_lock);
 
@@ -223,14 +227,20 @@ static void smk_set_access(struct smack_
 
 	if (sp == NULL) {
 		newp = kzalloc(sizeof(struct smk_list_entry), GFP_KERNEL);
+		if (newp == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
 		newp->smk_rule = *srp;
 		newp->smk_next = smack_list;
 		smack_list = newp;
 	}
 
+out:
 	mutex_unlock(&smack_list_lock);
 
-	return;
+	return ret;
 }
 
 /**
@@ -330,8 +340,10 @@ static ssize_t smk_write_load(struct fil
 		goto out;
 	}
 
-	smk_set_access(&rule);
-	rc = count;
+	rc = smk_set_access(&rule);
+
+	if (!rc)
+		rc = count;
 
 out:
 	kfree(data);
_

Patches currently in -mm which might be from sergio@larces.uece.br are

smackfs-check-for-allocation-failures-in-smk_set_access.patch

