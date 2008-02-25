From: akpm@linux-foundation.org
Subject: + smack-make-smk_cipso_doi-and-smk_unlbl_ambient.patch added to -mm tree
Date: Mon, 25 Feb 2008 13:52:13 -0800
Message-ID: <200802252153.m1PLr9Px021488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498AbYBYVxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 16:53:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: casey@schaufler-ca.com


The patch titled
     smack: make smk_cipso_doi() and smk_unlbl_ambient()
has been added to the -mm tree.  Its filename is
     smack-make-smk_cipso_doi-and-smk_unlbl_ambient.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smack: make smk_cipso_doi() and smk_unlbl_ambient()
From: Casey Schaufler <casey@schaufler-ca.com>

The functions smk_cipso_doi and smk_unlbl_ambient are not used outside
smackfs.c and should hence be static.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smackfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/smack/smackfs.c~smack-make-smk_cipso_doi-and-smk_unlbl_ambient security/smack/smackfs.c
--- a/security/smack/smackfs.c~smack-make-smk_cipso_doi-and-smk_unlbl_ambient
+++ a/security/smack/smackfs.c
@@ -338,7 +338,7 @@ static const struct file_operations smk_
 /**
  * smk_cipso_doi - initialize the CIPSO domain
  */
-void smk_cipso_doi(void)
+static void smk_cipso_doi(void)
 {
 	int rc;
 	struct cipso_v4_doi *doip;
@@ -371,7 +371,7 @@ void smk_cipso_doi(void)
 /**
  * smk_unlbl_ambient - initialize the unlabeled domain
  */
-void smk_unlbl_ambient(char *oldambient)
+static void smk_unlbl_ambient(char *oldambient)
 {
 	int rc;
 	struct netlbl_audit audit_info;
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

smack-make-smk_cipso_doi-and-smk_unlbl_ambient.patch
