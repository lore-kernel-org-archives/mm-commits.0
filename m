From: akpm@linux-foundation.org
Subject: + filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-fix.patch added to -mm tree
Date: Mon, 02 Feb 2009 14:04:26 -0800
Message-ID: <200902022204.n12M4Q26017316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbZBBWFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 17:05:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sandeen@redhat.com, t-sato@yk.jp.nec.com


The patch titled
     sysrq: emergency thaw only if CONFIG_BLOCK enabled
has been added to the -mm tree.  Its filename is
     filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-fix.patch

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
Subject: sysrq: emergency thaw only if CONFIG_BLOCK enabled
From: Randy Dunlap <randy.dunlap@oracle.com>

sysrq's new emergency_thaw_all() is only available when CONFIG_BLOCK=y:

drivers/char/sysrq.c:351: error: implicit declaration of function 'emergency_thaw_all'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/char/sysrq.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-fix drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-fix
+++ a/drivers/char/sysrq.c
@@ -346,6 +346,7 @@ static struct sysrq_key_op sysrq_moom_op
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
+#ifdef CONFIG_BLOCK
 static void sysrq_handle_thaw(int key, struct tty_struct *tty)
 {
 	emergency_thaw_all();
@@ -356,6 +357,7 @@ static struct sysrq_key_op sysrq_thaw_op
 	.action_msg	= "Emergency Thaw of all frozen filesystems",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
+#endif
 
 static void sysrq_handle_kill(int key, struct tty_struct *tty)
 {
@@ -409,7 +411,11 @@ static struct sysrq_key_op *sysrq_key_ta
 	NULL,				/* g */
 	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
+#ifdef CONFIG_BLOCK
 	&sysrq_thaw_op,			/* j */
+#else
+	NULL,				/* j */
+#endif
 	&sysrq_SAK_op,			/* k */
 #ifdef CONFIG_SMP
 	&sysrq_showallcpus_op,		/* l */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-general-listsopenfabricsorg-is-moderated.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

