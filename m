From: akpm@linux-foundation.org
Subject: - make-marker_debug-static.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:34 -0700
Message-ID: <200805010931.m419VYUV030884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758007AbYEAJcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     make marker_debug static
has been removed from the -mm tree.  Its filename was
     make-marker_debug-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make marker_debug static
From: Adrian Bunk <bunk@kernel.org>

With the needlessly global marker_debug being static gcc can optimize the
unused code away.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/marker.c~make-marker_debug-static kernel/marker.c
--- a/kernel/marker.c~make-marker_debug-static
+++ a/kernel/marker.c
@@ -29,7 +29,7 @@ extern struct marker __start___markers[]
 extern struct marker __stop___markers[];
 
 /* Set to 1 to enable marker debug output */
-const int marker_debug;
+static const int marker_debug;
 
 /*
  * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch

