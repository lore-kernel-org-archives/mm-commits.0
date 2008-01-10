From: akpm@linux-foundation.org
Subject: + dont-error-on-higher-hz-values.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:02:50 -0800
Message-ID: <200801100702.m0A72Ugg010020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbYAJHDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:03:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, mingo@elte.hu, pavel@suse.cz


The patch titled
     don't #error on higher HZ values
has been added to the -mm tree.  Its filename is
     dont-error-on-higher-hz-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

tpm-fix-suspend-and-resume-failure.patch
git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
small-cleanups-for-scsi_hosth.patch
git-x86.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
remove-obsolete-sys-devices-power-state-docs.patch
dont-error-on-higher-hz-values.patch
