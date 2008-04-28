From: akpm@linux-foundation.org
Subject: - i2o-remove-static-inline-forward-declarations.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:57 -0700
Message-ID: <200804282156.m3SLuvc7018285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964937AbYD1V5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     i2o: remove static inline forward declarations
has been removed from the -mm tree.  Its filename was
     i2o-remove-static-inline-forward-declarations.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: i2o: remove static inline forward declarations
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Nothing in between of them and the later declaration with body
needs them.

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/i2o.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/i2o.h~i2o-remove-static-inline-forward-declarat=
ions include/linux/i2o.h
--- a/include/linux/i2o.h~i2o-remove-static-inline-forward-declarations
+++ a/include/linux/i2o.h
@@ -613,14 +613,9 @@ struct i2o_sys_tbl {
 extern struct list_head i2o_controllers;
=20
 /* Message functions */
-static inline struct i2o_message *i2o_msg_get(struct i2o_controller *)=
;
 extern struct i2o_message *i2o_msg_get_wait(struct i2o_controller *, i=
nt);
-static inline void i2o_msg_post(struct i2o_controller *, struct i2o_me=
ssage *);
-static inline int i2o_msg_post_wait(struct i2o_controller *,
-				    struct i2o_message *, unsigned long);
 extern int i2o_msg_post_wait_mem(struct i2o_controller *, struct i2o_m=
essage *,
 				 unsigned long, struct i2o_dma *);
-static inline void i2o_flush_reply(struct i2o_controller *, u32);
=20
 /* IOP functions */
 extern int i2o_status_get(struct i2o_controller *);
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch
fs-coda-remove-static-inline-forward-declarations.patch
smbh-uses-struct-timespec-but-didnt-include-linux-timeh.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
