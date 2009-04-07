From: akpm@linux-foundation.org
Subject: [merged] kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:26 -0700
Message-ID: <200904071907.n37J7QG4011284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbZDGTqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:46:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     kprobes: support kretprobe and jprobe per-probe disabling
has been removed from the -mm tree.  Its filename was
     kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: support kretprobe and jprobe per-probe disabling
From: Masami Hiramatsu <mhiramat@redhat.com>

Add disable/enable_kretprobe() and disable/enable_jprobe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt |   16 ++++++++++------
 include/linux/kprobes.h   |   17 +++++++++++++++++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff -puN Documentation/kprobes.txt~kprobes-support-kretprobe-and-jprobe-per-probe-disabling Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~kprobes-support-kretprobe-and-jprobe-per-probe-disabling
+++ a/Documentation/kprobes.txt
@@ -365,21 +365,25 @@ probes) in the specified array, they cle
 incorrect probes. However, other probes in the array are
 unregistered correctly.
 
-4.7 disable_kprobe
+4.7 disable_*probe
 
 #include <linux/kprobes.h>
 int disable_kprobe(struct kprobe *kp);
+int disable_kretprobe(struct kretprobe *rp);
+int disable_jprobe(struct jprobe *jp);
 
-Temporarily disables the specified kprobe. You can enable it again by using
-enable_kprobe(). You must specify the kprobe which has been registered.
+Temporarily disables the specified *probe. You can enable it again by using
+enable_*probe(). You must specify the probe which has been registered.
 
-4.8 enable_kprobe
+4.8 enable_*probe
 
 #include <linux/kprobes.h>
 int enable_kprobe(struct kprobe *kp);
+int enable_kretprobe(struct kretprobe *rp);
+int enable_jprobe(struct jprobe *jp);
 
-Enables kprobe which has been disabled by disable_kprobe(). You must specify
-the kprobe which has been registered.
+Enables *probe which has been disabled by disable_*probe(). You must specify
+the probe which has been registered.
 
 5. Kprobes Features and Limitations
 
diff -puN include/linux/kprobes.h~kprobes-support-kretprobe-and-jprobe-per-probe-disabling include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-support-kretprobe-and-jprobe-per-probe-disabling
+++ a/include/linux/kprobes.h
@@ -371,4 +371,21 @@ static inline int enable_kprobe(struct k
 	return -ENOSYS;
 }
 #endif /* CONFIG_KPROBES */
+static inline int disable_kretprobe(struct kretprobe *rp)
+{
+	return disable_kprobe(&rp->kp);
+}
+static inline int enable_kretprobe(struct kretprobe *rp)
+{
+	return enable_kprobe(&rp->kp);
+}
+static inline int disable_jprobe(struct jprobe *jp)
+{
+	return disable_kprobe(&jp->kp);
+}
+static inline int enable_jprobe(struct jprobe *jp)
+{
+	return enable_kprobe(&jp->kp);
+}
+
 #endif /* _LINUX_KPROBES_H */
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

