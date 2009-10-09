From: akpm@linux-foundation.org
Subject: + cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch added to -mm tree
Date: Fri, 09 Oct 2009 16:16:51 -0700
Message-ID: <200910092316.n99NGpr7006906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761751AbZJIXRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 19:17:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, avi@redhat.com, davej@codemonkey.org.uk, eparis@redhat.com, jirislaby@gmail.com, mtosatti@redhat.com


The patch titled
     cpufreq: add cpufreq_get() stub for CONFIG_CPU_FREQ=n
has been added to the -mm tree.  Its filename is
     cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch

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
Subject: cpufreq: add cpufreq_get() stub for CONFIG_CPU_FREQ=n
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_CPU_FREQ is disabled, cpufreq_get() needs a stub.  Used by kvm
(although it looks like a bit of the kvm code could be omitted when
CONFIG_CPU_FREQ is disabled).

arch/x86/built-in.o: In function `kvm_arch_init':
(.text+0x10de7): undefined reference to `cpufreq_get'

(Needed in linux-next's KVM tree, but it's correct in 2.6.32).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Eric Paris <eparis@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/cpufreq.h~cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n
+++ a/include/linux/cpufreq.h
@@ -291,8 +291,15 @@ struct global_attr {
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
 
+#ifdef CONFIG_CPU_FREQ
 /* query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it */
 unsigned int cpufreq_get(unsigned int cpu);
+#else
+static inline unsigned int cpufreq_get(unsigned int cpu)
+{
+	return 0;
+}
+#endif
 
 /* query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it */
 #ifdef CONFIG_CPU_FREQ
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch
linux-next.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch

