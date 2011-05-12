From: akpm@linux-foundation.org
Subject: + documentation-configfs-examples-crash-fix.patch added to -mm tree
Date: Thu, 12 May 2011 12:49:34 -0700
Message-ID: <201105121949.p4CJnYxu029609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757573Ab1ELTtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 15:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, joel.becker@oracle.com


The patch titled
     Documentation: configfs examples crash fix
has been added to the -mm tree.  Its filename is
     documentation-configfs-examples-crash-fix.patch

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
Subject: Documentation: configfs examples crash fix
From: Jiri Slaby <jslaby@suse.cz>

When configfs_register_subsystem() fails, we unregister too many
subsystems in configfs_example_init.  Decrement i by one to not unregister
non-registered subsystem.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/configfs/configfs_example_explicit.c |    2 +-
 Documentation/filesystems/configfs/configfs_example_macros.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/configfs/configfs_example_explicit.c~documentation-configfs-examples-crash-fix Documentation/filesystems/configfs/configfs_example_explicit.c
--- a/Documentation/filesystems/configfs/configfs_example_explicit.c~documentation-configfs-examples-crash-fix
+++ a/Documentation/filesystems/configfs/configfs_example_explicit.c
@@ -464,7 +464,7 @@ static int __init configfs_example_init(
 	return 0;
 
 out_unregister:
-	for (; i >= 0; i--) {
+	for (i--; i >= 0; i--) {
 		configfs_unregister_subsystem(example_subsys[i]);
 	}
 
diff -puN Documentation/filesystems/configfs/configfs_example_macros.c~documentation-configfs-examples-crash-fix Documentation/filesystems/configfs/configfs_example_macros.c
--- a/Documentation/filesystems/configfs/configfs_example_macros.c~documentation-configfs-examples-crash-fix
+++ a/Documentation/filesystems/configfs/configfs_example_macros.c
@@ -427,7 +427,7 @@ static int __init configfs_example_init(
 	return 0;
 
 out_unregister:
-	for (; i >= 0; i--) {
+	for (i--; i >= 0; i--) {
 		configfs_unregister_subsystem(example_subsys[i]);
 	}
 
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
documentation-configfs-examples-crash-fix.patch
mm-extract-exe_file-handling-from-procfs.patch
coredump-add-support-for-exe_file-in-core-name.patch
coredump-use-get_task_comm-for-%e-filename-format.patch
coredump-use-task-comm-instead-of-unknown.patch
coredump-escape-in-hostname-and-comm.patch

