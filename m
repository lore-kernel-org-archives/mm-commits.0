From: akpm@linux-foundation.org
Subject: + typo-fixes-errror-error.patch added to -mm tree
Date: Fri, 20 Jul 2007 12:01:30 -0700
Message-ID: <200707201901.l6KJ1URP011279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761672AbXGTTBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com, jeff@garzik.org, schwidefsky@de.ibm.com, sds@tycho.nsa.gov


The patch titled
     Typo fixes errror -> error
has been added to the -mm tree.  Its filename is
     typo-fixes-errror-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Typo fixes errror -> error
From: Gabriel Craciunescu <nix.or.die@googlemail.com>

Typo fixes errror -> error

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skfp/pmf.c         |    2 +-
 drivers/s390/block/dasd_eckd.c |    4 ++--
 security/selinux/ss/services.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/skfp/pmf.c~typo-fixes-errror-error drivers/net/skfp/pmf.c
--- a/drivers/net/skfp/pmf.c~typo-fixes-errror-error
+++ a/drivers/net/skfp/pmf.c
@@ -575,7 +575,7 @@ void smt_add_para(struct s_smc *smc, str
 	int		sp_len ;
 
 	/*
-	 * skip if errror
+	 * skip if error
 	 */
 	if (pcon->pc_err)
 		return ;
diff -puN drivers/s390/block/dasd_eckd.c~typo-fixes-errror-error drivers/s390/block/dasd_eckd.c
--- a/drivers/s390/block/dasd_eckd.c~typo-fixes-errror-error
+++ a/drivers/s390/block/dasd_eckd.c
@@ -555,7 +555,7 @@ dasd_eckd_read_conf(struct dasd_device *
 			if (conf_data == NULL) {
 				MESSAGE(KERN_WARNING, "%s", "No configuration "
 					"data retrieved");
-				continue;	/* no errror */
+				continue;	/* no error */
 			}
 			if (conf_len != sizeof (struct dasd_eckd_confdata)) {
 				MESSAGE(KERN_WARNING,
@@ -564,7 +564,7 @@ dasd_eckd_read_conf(struct dasd_device *
 					conf_len,
 					sizeof (struct dasd_eckd_confdata));
 				kfree(conf_data);
-				continue;	/* no errror */
+				continue;	/* no error */
 			}
 			/* save first valid configuration data */
 			if (!conf_data_saved){
diff -puN security/selinux/ss/services.c~typo-fixes-errror-error security/selinux/ss/services.c
--- a/security/selinux/ss/services.c~typo-fixes-errror-error
+++ a/security/selinux/ss/services.c
@@ -792,7 +792,7 @@ int security_context_to_sid(char *sconte
  * @scontext: security context
  * @scontext_len: length in bytes
  * @sid: security identifier, SID
- * @def_sid: default SID to assign on errror
+ * @def_sid: default SID to assign on error
  *
  * Obtains a SID associated with the security context that
  * has the string representation specified by @scontext.
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

origin.patch
broken-lilo-check-on-make-install.patch
typo-fixes-errror-error.patch
