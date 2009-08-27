From: akpm@linux-foundation.org
Subject: + ima-allow-disabling-ima-at-runtime.patch added to -mm tree
Date: Wed, 26 Aug 2009 17:02:39 -0700
Message-ID: <200908270002.n7R02dwL017890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336AbZH0ADo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 20:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@redhat.com, eparis@redhat.com, jmorris@namei.org, zohar@us.ibm.com


The patch titled
     ima: allow disabling IMA at runtime
has been added to the -mm tree.  Its filename is
     ima-allow-disabling-ima-at-runtime.patch

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
Subject: ima: allow disabling IMA at runtime
From: Kyle McMartin <kyle@redhat.com>

Due to a memory leak in IMA that we're currently debugging in Fedora
rawhide, it would be nice to be able to disable that support at runtime. 
Currently it's only able to be built in, and there's no toggle to avoid
initializing it.

Provide one, in order to enhance debuggability.  If a user can reboot a
machine and edit its command line, one can do a far sight worse things
than disabling a security precaution.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 security/integrity/ima/ima_main.c   |   17 +++++++++++++++++
 2 files changed, 22 insertions(+)

diff -puN Documentation/kernel-parameters.txt~ima-allow-disabling-ima-at-runtime Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~ima-allow-disabling-ima-at-runtime
+++ a/Documentation/kernel-parameters.txt
@@ -927,6 +927,11 @@ and is between 256 and 4096 characters. 
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ima=		[IMA]
+			Format: { "0" | "1" }
+			0 -- disable IMA.
+			1 -- enable IMA. (default)
+
 	ima_audit=	[IMA]
 			Format: { "0" | "1" }
 			0 -- integrity auditing messages. (Default)
diff -puN security/integrity/ima/ima_main.c~ima-allow-disabling-ima-at-runtime security/integrity/ima/ima_main.c
--- a/security/integrity/ima/ima_main.c~ima-allow-disabling-ima-at-runtime
+++ a/security/integrity/ima/ima_main.c
@@ -339,10 +339,27 @@ int ima_bprm_check(struct linux_binprm *
 	return 0;
 }
 
+static int ima_disabled = 0;
+static int __init ima_enabled(char *str)
+{
+	unsigned long enabled;
+
+	if (!strict_strtoul(str, 0, &enabled))
+		ima_disabled = enabled ? 0 : 1;
+
+	return 1;
+}
+__setup("ima=", ima_enabled);
+
 static int __init init_ima(void)
 {
 	int error;
 
+	if (ima_disabled) {
+		pr_info("IMA disabled at user request.\n");
+		return 0;
+	}
+
 	ima_iintcache_init();
 	error = ima_init();
 	ima_initialized = 1;
_

Patches currently in -mm which might be from kyle@redhat.com are

origin.patch
ima-allow-disabling-ima-at-runtime.patch

