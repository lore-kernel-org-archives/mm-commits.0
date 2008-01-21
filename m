From: akpm@linux-foundation.org
Subject: - dont-error-on-higher-hz-values.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:14:32 -0800
Message-ID: <200801212314.m0LNEWmO025004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761155AbYAUXTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, mingo@elte.hu, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     don't #error on higher HZ values
has been removed from the -mm tree.  Its filename was
     dont-error-on-higher-hz-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: don't #error on higher HZ values
From: Pavel Machek <pavel@ucw.cz>

For some crazy reason (trying to work around hw problem in i810) I wanted
to use HZ around 4000.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/jiffies.h~dont-error-on-higher-hz-values include/linux/jiffies.h
--- a/include/linux/jiffies.h~dont-error-on-higher-hz-values
+++ a/include/linux/jiffies.h
@@ -29,6 +29,12 @@
 # define SHIFT_HZ	9
 #elif HZ >= 768 && HZ < 1536
 # define SHIFT_HZ	10
+#elif HZ >= 1536 && HZ < 3072
+# define SHIFT_HZ	11
+#elif HZ >= 3072 && HZ < 6144
+# define SHIFT_HZ	12
+#elif HZ >= 6144 && HZ < 12288
+# define SHIFT_HZ	13
 #else
 # error You lose.
 #endif
_

Patches currently in -mm which might be from pavel@ucw.cz are

git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-sched.patch
small-cleanups-for-scsi_hosth.patch
git-x86.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
