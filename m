From: akpm@linux-foundation.org
Subject: [merged] kstrtox-simpler-code-in-_kstrtoull.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:37 -0700
Message-ID: <201104181758.p3IHwmVD016087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab1DRSDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kstrtox: simpler code in _kstrtoull()
has been removed from the -mm tree.  Its filename was
     kstrtox-simpler-code-in-_kstrtoull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kstrtox: simpler code in _kstrtoull()
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN lib/kstrtox.c~kstrtox-simpler-code-in-_kstrtoull lib/kstrtox.c
--- a/lib/kstrtox.c~kstrtox-simpler-code-in-_kstrtoull
+++ a/lib/kstrtox.c
@@ -49,12 +49,9 @@ static int _kstrtoull(const char *s, uns
 			val = *s - '0';
 		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
 			val = _tolower(*s) - 'a' + 10;
-		else if (*s == '\n') {
-			if (*(s + 1) == '\0')
-				break;
-			else
-				return -EINVAL;
-		} else
+		else if (*s == '\n' && *(s + 1) == '\0')
+			break;
+		else
 			return -EINVAL;
 
 		if (val >= base)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
lib-add-kstrto_from_user.patch
kstrtox-convert-fs-proc.patch
proc-constify-status-array.patch
proc-stat-use-defined-macro-kmalloc_max_size.patch
sysctl-add-proc_dointvec_bool-handler.patch

