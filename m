From: akpm@linux-foundation.org
Subject: + fbcon-uninline-four-foo_update_attr-functions.patch added to -mm tree
Date: Wed, 30 Jun 2010 12:34:55 -0700
Message-ID: <201006301934.o5UJYtSo022234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755566Ab0F3Te5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 15:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com


The patch titled
     fbcon: uninline four foo_update_attr() functions
has been added to the -mm tree.  Its filename is
     fbcon-uninline-four-foo_update_attr-functions.patch

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
Subject: fbcon: uninline four foo_update_attr() functions
From: Denys Vlasenko <vda.linux@googlemail.com>

This patch uninlines four similar functions, foo_update_attr(), in four
fbcon-related files.

These functions contain loops, two of theam have _nested_ loops, and they
have more than one callsite each.  I think they should not be inlined.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/bitblit.c   |    2 +-
 drivers/video/console/fbcon_ccw.c |    2 +-
 drivers/video/console/fbcon_cw.c  |    2 +-
 drivers/video/console/fbcon_ud.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/console/bitblit.c~fbcon-uninline-four-foo_update_attr-functions drivers/video/console/bitblit.c
--- a/drivers/video/console/bitblit.c~fbcon-uninline-four-foo_update_attr-functions
+++ a/drivers/video/console/bitblit.c
@@ -22,7 +22,7 @@
 /*
  * Accelerated handlers.
  */
-static inline void update_attr(u8 *dst, u8 *src, int attribute,
+static void update_attr(u8 *dst, u8 *src, int attribute,
 			       struct vc_data *vc)
 {
 	int i, offset = (vc->vc_font.height < 10) ? 1 : 2;
diff -puN drivers/video/console/fbcon_ccw.c~fbcon-uninline-four-foo_update_attr-functions drivers/video/console/fbcon_ccw.c
--- a/drivers/video/console/fbcon_ccw.c~fbcon-uninline-four-foo_update_attr-functions
+++ a/drivers/video/console/fbcon_ccw.c
@@ -22,7 +22,7 @@
  * Rotation 270 degrees
  */
 
-static inline void ccw_update_attr(u8 *dst, u8 *src, int attribute,
+static void ccw_update_attr(u8 *dst, u8 *src, int attribute,
 				  struct vc_data *vc)
 {
 	int i, j, offset = (vc->vc_font.height < 10) ? 1 : 2;
diff -puN drivers/video/console/fbcon_cw.c~fbcon-uninline-four-foo_update_attr-functions drivers/video/console/fbcon_cw.c
--- a/drivers/video/console/fbcon_cw.c~fbcon-uninline-four-foo_update_attr-functions
+++ a/drivers/video/console/fbcon_cw.c
@@ -22,7 +22,7 @@
  * Rotation 90 degrees
  */
 
-static inline void cw_update_attr(u8 *dst, u8 *src, int attribute,
+static void cw_update_attr(u8 *dst, u8 *src, int attribute,
 				  struct vc_data *vc)
 {
 	int i, j, offset = (vc->vc_font.height < 10) ? 1 : 2;
diff -puN drivers/video/console/fbcon_ud.c~fbcon-uninline-four-foo_update_attr-functions drivers/video/console/fbcon_ud.c
--- a/drivers/video/console/fbcon_ud.c~fbcon-uninline-four-foo_update_attr-functions
+++ a/drivers/video/console/fbcon_ud.c
@@ -22,7 +22,7 @@
  * Rotation 180 degrees
  */
 
-static inline void ud_update_attr(u8 *dst, u8 *src, int attribute,
+static void ud_update_attr(u8 *dst, u8 *src, int attribute,
 				  struct vc_data *vc)
 {
 	int i, offset = (vc->vc_font.height < 10) ? 1 : 2;
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

modpost-support-objects-with-more-than-64k-sections.patch
fbcon-deinline-large-static-function-get_color.patch
fbcon-uninline-four-foo_update_attr-functions.patch

