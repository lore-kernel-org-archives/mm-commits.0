From: akpm@linux-foundation.org
Subject: [merged] include-linux-c2porth-remove-wrong-and-never-used-macros.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:13 -0700
Message-ID: <201105252029.p4PKTacG014855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932583Ab1EYUsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanlong.gao@gmail.com, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     include/linux/c2port.h: remove wrong and never used macros
has been removed from the -mm tree.  Its filename was
     include-linux-c2porth-remove-wrong-and-never-used-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/c2port.h: remove wrong and never used macros
From: Wanlong Gao <wanlong.gao@gmail.com>

The macro to_class_dev() uses the deprecated structure class_device, and
the c2port_device has no member named class in the definition of the macro
to_c2port_device.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/c2port.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/c2port.h~include-linux-c2porth-remove-wrong-and-never-used-macros include/linux/c2port.h
--- a/include/linux/c2port.h~include-linux-c2porth-remove-wrong-and-never-used-macros
+++ a/include/linux/c2port.h
@@ -60,9 +60,6 @@ struct c2port_ops {
  * Exported functions
  */
 
-#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
-#define to_c2port_device(obj) container_of((obj), struct c2port_device, class)
