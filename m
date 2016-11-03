From: akpm@linux-foundation.org
Subject: +
 sparc-implement-watchdog_nmi_enable-and-watchdog_nmi_disable.patch added to -mm tree
Date: Thu, 03 Nov 2016 16:46:43 -0700
Message-ID: <581bcc63.QSaM8yHTjH0tGLcJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933240AbcKCXqp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2016 19:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: babu.moger@oracle.com, andi@firstfloor.org, atomlin@redhat.com, baiyaowei@cmss.chinamobile.com, davem@davemloft.net, dzickus@redhat.com, hidehiro.kawai.ez@hitachi.com, jkosina@suse.cz, johunt@akamai.com, mingo@kernel.org, tj@kernel.org, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: implement watchdog_nmi_enable and watchdog_nmi_disable
has been added to the -mm tree.  Its filename is
     sparc-implement-watchdog_nmi_enable-and-watchdog_nmi_disable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-implement-watchdog_nmi_enable-and-watchdog_nmi_disable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-implement-watchdog_nmi_enable-and-watchdog_nmi_disable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Babu Moger <babu.moger@oracle.com>
Subject: sparc: implement watchdog_nmi_enable and watchdog_nmi_disable

Implement functions watchdog_nmi_enable and watchdog_nmi_disable to
enable/disable nmi watchdog.  Sparc uses arch specific nmi watchdog
handler.  Currently, we do not have a way to enable/disable nmi watchdog
dynamically.  With these patches we can enable or disable arch specific
nmi watchdogs using proc or sysctl interface.

Example commands.
To enable: echo 1 >  /proc/sys/kernel/nmi_watchdog
To disable: echo 0 >  /proc/sys/kernel/nmi_watchdog

It can also achieved using the sysctl parameter kernel.nmi_watchdog

Link: http://lkml.kernel.org/r/1478034826-43888-4-git-send-email-babu.moger@oracle.com
Signed-off-by: Babu Moger <babu.moger@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Josh Hunt <johunt@akamai.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/nmi.c |   44 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff -puN arch/sparc/kernel/nmi.c~sparc-implement-watchdog_nmi_enable-and-watchdog_nmi_disable arch/sparc/kernel/nmi.c
--- a/arch/sparc/kernel/nmi.c~sparc-implement-watchdog_nmi_enable-and-watchdog_nmi_disable
+++ a/arch/sparc/kernel/nmi.c
@@ -42,7 +42,7 @@ static int panic_on_timeout;
  */
 atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
 EXPORT_SYMBOL(nmi_active);
-
+static int nmi_init_done;
 static unsigned int nmi_hz = HZ;
 static DEFINE_PER_CPU(short, wd_enabled);
 static int endflag __initdata;
@@ -153,6 +153,8 @@ static void report_broken_nmi(int cpu, i
 
 void stop_nmi_watchdog(void *unused)
 {
+	if (!__this_cpu_read(wd_enabled))
+		return;
 	pcr_ops->write_pcr(0, pcr_ops->pcr_nmi_disable);
 	__this_cpu_write(wd_enabled, 0);
 	atomic_dec(&nmi_active);
@@ -207,6 +209,9 @@ error:
 
 void start_nmi_watchdog(void *unused)
 {
+	if (__this_cpu_read(wd_enabled))
+		return;
+
 	__this_cpu_write(wd_enabled, 1);
 	atomic_inc(&nmi_active);
 
@@ -259,6 +264,8 @@ int __init nmi_init(void)
 		}
 	}
 
+	nmi_init_done = 1;
+
 	return err;
 }
 
@@ -270,3 +277,38 @@ static int __init setup_nmi_watchdog(cha
 	return 0;
 }
 __setup("nmi_watchdog=", setup_nmi_watchdog);
+
+/*
+ * sparc specific NMI watchdog enable function.
+ * Enables watchdog if it is not enabled already.
+ */
+int watchdog_nmi_enable(unsigned int cpu)
+{
+	if (atomic_read(&nmi_active) == -1) {
+		pr_warn("NMI watchdog cannot be enabled or disabled\n");
+		return -1;
+	}
+
+	/*
+	 * watchdog thread could start even before nmi_init is called.
+	 * Just Return in that case. Let nmi_init finish the init
+	 * process first.
+	 */
+	if (!nmi_init_done)
+		return 0;
+
+	smp_call_function_single(cpu, start_nmi_watchdog, NULL, 1);
+
+	return 0;
+}
+/*
+ * sparc specific NMI watchdog disable function.
+ * Disables watchdog if it is not disabled already.
+ */
+void watchdog_nmi_disable(unsigned int cpu)
+{
+	if (atomic_read(&nmi_active) == -1)
+		pr_warn_once("NMI watchdog cannot be enabled or disabled\n");
+	else
+		smp_call_function_single(cpu, stop_nmi_watchdog, NULL, 1);
+}
_

Patches currently in -mm which might be from babu.moger@oracle.com are

watchdog-move-shared-definitions-to-nmih.patch
watchdog-move-hardlockup-detector-to-separate-file.patch
sparc-implement-watchdog_nmi_enable-and-watchdog_nmi_disable.patch

