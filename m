From: akpm@linux-foundation.org
Subject: - pm-make-suspend_ops-static.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:49 -0700
Message-ID: <200710190340.l9J3enri012736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966067AbXJSDzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     PM: Make suspend_ops static
has been removed from the -mm tree.  Its filename was
     pm-make-suspend_ops-static.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: PM: Make suspend_ops static
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

The variable suspend_ops representing the set of global platform-specif=
ic
suspend-related operations, used by the PM core, need not be exported o=
utside
of kernel/power/main.c .  =A0Make it static.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    2 --
 kernel/power/main.c     |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/suspend.h~pm-make-suspend_ops-static include/li=
nux/suspend.h
--- a/include/linux/suspend.h~pm-make-suspend_ops-static
+++ a/include/linux/suspend.h
@@ -79,8 +79,6 @@ struct platform_suspend_ops {
 };
=20
 #ifdef CONFIG_SUSPEND
-extern struct platform_suspend_ops *suspend_ops;
-
 /**
  * suspend_set_ops - set platform dependent suspend operations
  * @ops: The new suspend operations to set.
diff -puN kernel/power/main.c~pm-make-suspend_ops-static kernel/power/m=
ain.c
--- a/kernel/power/main.c~pm-make-suspend_ops-static
+++ a/kernel/power/main.c
@@ -32,7 +32,7 @@ DEFINE_MUTEX(pm_mutex);
 /* This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
=20
-struct platform_suspend_ops *suspend_ops;
+static struct platform_suspend_ops *suspend_ops;
=20
 /**
  *	suspend_set_ops - Set the global suspend method table.
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
