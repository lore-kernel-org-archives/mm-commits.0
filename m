From: akpm@google.com
Subject: [merged] kmod-prevent-kmod_loop_msg-overflow-in-__request_module.patch removed from -mm tree
Date: Wed, 05 Oct 2011 12:12:35 -0700
Message-ID: <201110051912.p95JCbbM030219@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538Ab1JETNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 15:13:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: prevent kmod_loop_msg overflow in __request_module()
has been removed from the -mm tree.  Its filename was
     kmod-prevent-kmod_loop_msg-overflow-in-__request_module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: kmod: prevent kmod_loop_msg overflow in __request_module()

Due to post-increment in condition of kmod_loop_msg in __request_module(),
the system log can be spammed by much more than 5 instances of the
'runaway loop' message if the number of events triggering it makes the
kmod_loop_msg to overflow.

Fix that by making sure we never increment it past the threshold.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/kmod.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/kmod.c~kmod-prevent-kmod_loop_msg-overflow-in-__request_module kernel/kmod.c
--- a/kernel/kmod.c~kmod-prevent-kmod_loop_msg-overflow-in-__request_module
+++ a/kernel/kmod.c
@@ -114,10 +114,12 @@ int __request_module(bool wait, const ch
 	atomic_inc(&kmod_concurrent);
 	if (atomic_read(&kmod_concurrent) > max_modprobes) {
 		/* We may be blaming an innocent here, but unlikely */
-		if (kmod_loop_msg++ < 5)
+		if (kmod_loop_msg < 5) {
 			printk(KERN_ERR
 			       "request_module: runaway loop modprobe %s\n",
 			       module_name);
+			kmod_loop_msg++;
+		}
 		atomic_dec(&kmod_concurrent);
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
binfmt_elf-fix-pie-execution-with-randomization-disabled.patch

