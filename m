From: akpm@linux-foundation.org
Subject: + dynamic-debug-move-ddebug_remove_module-down-into-free_module.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:34:48 -0700
Message-ID: <201007212134.o6LLYmEh016472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758256Ab0GUVfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, stable@kernel.org, trenn@suse.de


The patch titled
     dynamic debug: move ddebug_remove_module() down into free_module()
has been added to the -mm tree.  Its filename is
     dynamic-debug-move-ddebug_remove_module-down-into-free_module.patch

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
Subject: dynamic debug: move ddebug_remove_module() down into free_module()
From: Jason Baron <jbaron@redhat.com>

The command

	echo "file ec.c +p" >/sys/kernel/debug/dynamic_debug/control

causes an oops.

Move the call to ddebug_remove_module() down into free_module().  In this
way it should be called from all error paths.  Currently, we are missing
the remove if the module init routine fails.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Reported-by: Thomas Renninger <trenn@suse.de>
Tested-by: Thomas Renninger <trenn@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/module.c~dynamic-debug-move-ddebug_remove_module-down-into-free_module kernel/module.c
--- a/kernel/module.c~dynamic-debug-move-ddebug_remove_module-down-into-free_module
+++ a/kernel/module.c
@@ -787,7 +787,6 @@ SYSCALL_DEFINE2(delete_module, const cha
 
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
-	ddebug_remove_module(mod->name);
 
 	free_module(mod);
 	return 0;
@@ -1550,6 +1549,9 @@ static void free_module(struct module *m
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
+	/* Remove dynamic debug info */
+	ddebug_remove_module(mod->name);
+
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
_

Patches currently in -mm which might be from jbaron@redhat.com are

dynamic-debug-move-ddebug_remove_module-down-into-free_module.patch
linux-next.patch

