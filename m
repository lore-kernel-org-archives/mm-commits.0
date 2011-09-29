From: akpm@google.com
Subject: + kmod-prevent-kmod_loop_msg-overflow-in-__request_module.patch added to -mm tree
Date: Thu, 29 Sep 2011 14:31:41 -0700
Message-ID: <201109292131.p8TLVfVv008870@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab1I2Vcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2011 17:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, rusty@rustcorp.com.au


The patch titled
     Subject: kmod: prevent kmod_loop_msg overflow in __request_module()
has been added to the -mm tree.  Its filename is
     kmod-prevent-kmod_loop_msg-overflow-in-__request_module.patch

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
From: Jiri Kosina <jkosina@suse.cz>
Subject: kmod: prevent kmod_loop_msg overflow in __request_module()

Due to post-decrement in condition of kmod_loop_msg in __request_module(),
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
Subject: Subject: kmod: prevent kmod_loop_msg overflow in __request_module()

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
kmod-prevent-kmod_loop_msg-overflow-in-__request_module.patch
binfmt_elf-fix-pie-execution-with-randomization-disabled.patch

