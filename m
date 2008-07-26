From: akpm@linux-foundation.org
Subject: - video-stifbc-make-2-functions-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:28 -0700
Message-ID: <200807262118.m6QLIS4Y020095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758054AbYGZVSh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     video/stifb.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     video-stifbc-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video/stifb.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global functions static:
- stifb_init_fb()
- stifb_init()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/stifb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/stifb.c~video-stifbc-make-2-functions-static drivers/video/stifb.c
--- a/drivers/video/stifb.c~video-stifbc-make-2-functions-static
+++ a/drivers/video/stifb.c
@@ -1078,8 +1078,7 @@ static struct fb_ops stifb_ops = {
  *  Initialization
  */
 
-int __init
-stifb_init_fb(struct sti_struct *sti, int bpp_pref)
+static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 {
 	struct fb_fix_screeninfo *fix;
 	struct fb_var_screeninfo *var;
@@ -1315,8 +1314,7 @@ static int stifb_disabled __initdata;
 int __init
 stifb_setup(char *options);
 
-int __init
-stifb_init(void)
+static int __init stifb_init(void)
 {
 	struct sti_struct *sti;
 	struct sti_struct *def_sti;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

