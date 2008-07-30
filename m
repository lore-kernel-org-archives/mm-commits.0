From: akpm@linux-foundation.org
Subject: - drivers-video-release-mutex-in-error-handling-code.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:36 -0700
Message-ID: <200807301914.m6UJEawd010920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbYG3TPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, krzysztof.h1@wp.pl, santiago@crfreenet.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video: release mutex in error handling code
has been removed from the -mm tree.  Its filename was
     drivers-video-release-mutex-in-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video: release mutex in error handling code
From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c    |    9 +++------
 drivers/video/vt8623fb.c |    9 +++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/video/arkfb.c~drivers-video-release-mutex-in-error-handling-code drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~drivers-video-release-mutex-in-error-handling-code
+++ a/drivers/video/arkfb.c
@@ -1126,11 +1126,8 @@ static int ark_pci_resume (struct pci_de
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
 
-	if (par->ref_count == 0) {
-		mutex_unlock(&(par->open_lock));
-		release_console_sem();
-		return 0;
-	}
+	if (par->ref_count == 0)
+		goto fail;
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
@@ -1143,8 +1140,8 @@ static int ark_pci_resume (struct pci_de
 	arkfb_set_par(info);
 	fb_set_suspend(info, 0);
 
-	mutex_unlock(&(par->open_lock));
 fail:
+	mutex_unlock(&(par->open_lock));
 	release_console_sem();
 	return 0;
 }
diff -puN drivers/video/vt8623fb.c~drivers-video-release-mutex-in-error-handling-code drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~drivers-video-release-mutex-in-error-handling-code
+++ a/drivers/video/vt8623fb.c
@@ -853,11 +853,8 @@ static int vt8623_pci_resume(struct pci_
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
 
-	if (par->ref_count == 0) {
-		mutex_unlock(&(par->open_lock));
-		release_console_sem();
-		return 0;
-	}
+	if (par->ref_count == 0)
+		goto fail;
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
@@ -870,8 +867,8 @@ static int vt8623_pci_resume(struct pci_
 	vt8623fb_set_par(info);
 	fb_set_suspend(info, 0);
 
-	mutex_unlock(&(par->open_lock));
 fail:
+	mutex_unlock(&(par->open_lock));
 	release_console_sem();
 
 	return 0;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
git-infiniband.patch
drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch
net-ieee80211-adjust-error-handling.patch

