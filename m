From: akpm@linux-foundation.org
Subject: [merged] documentation-configfs-examples-crash-fix.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:33 -0700
Message-ID: <201105271955.p4RJtc55017474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756826Ab1E0T4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, joel.becker@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: configfs examples crash fix
has been removed from the -mm tree.  Its filename was
     documentation-configfs-examples-crash-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: configfs examples crash fix
From: Jiri Slaby <jslaby@suse.cz>

When configfs_register_subsystem() fails, we unregister too many
subsystems in configfs_example_init.  Decrement i by one to not unregister
non-registered subsystem.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/configfs/configfs_example_explicit.c |    6 ++----
 Documentation/filesystems/configfs/configfs_example_macros.c   |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN Documentation/filesystems/configfs/configfs_example_explicit.c~documentation-configfs-examples-crash-fix Documentation/filesystems/configfs/configfs_example_explicit.c
--- a/Documentation/filesystems/configfs/configfs_example_explicit.c~documentation-configfs-examples-crash-fix
+++ a/Documentation/filesystems/configfs/configfs_example_explicit.c
@@ -464,9 +464,8 @@ static int __init configfs_example_init(
 	return 0;
 
 out_unregister:
-	for (; i >= 0; i--) {
+	for (i--; i >= 0; i--)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 
 	return ret;
 }
@@ -475,9 +474,8 @@ static void __exit configfs_example_exit
 {
 	int i;
 
-	for (i = 0; example_subsys[i]; i++) {
+	for (i = 0; example_subsys[i]; i++)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 }
 
 module_init(configfs_example_init);
diff -puN Documentation/filesystems/configfs/configfs_example_macros.c~documentation-configfs-examples-crash-fix Documentation/filesystems/configfs/configfs_example_macros.c
--- a/Documentation/filesystems/configfs/configfs_example_macros.c~documentation-configfs-examples-crash-fix
+++ a/Documentation/filesystems/configfs/configfs_example_macros.c
@@ -427,9 +427,8 @@ static int __init configfs_example_init(
 	return 0;
 
 out_unregister:
-	for (; i >= 0; i--) {
+	for (i--; i >= 0; i--)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 
 	return ret;
 }
@@ -438,9 +437,8 @@ static void __exit configfs_example_exit
 {
 	int i;
 
-	for (i = 0; example_subsys[i]; i++) {
+	for (i = 0; example_subsys[i]; i++)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 }
 
 module_init(configfs_example_init);
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

