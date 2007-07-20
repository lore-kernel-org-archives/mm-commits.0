From: akpm@linux-foundation.org
Subject: + fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:29:56 -0700
Message-ID: <200707200129.l6K1Tugq000726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38427 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761012AbXGTBbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, karim@opersys.com, mathieu.desnoyers@polymtl.ca, wilder@us.ibm.com, zanussi@us.ibm.com


The patch titled
     Fix a use after free bug in kernel->userspace relay file support
has been added to the -mm tree.  Its filename is
     fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix a use after free bug in kernel->userspace relay file support
From: Jesper Juhl <jesper.juhl@gmail.com>

Coverity spotted what looks like a real possible case of using a variable
after it has been freed.  The problem is in
kernel/relay.c::relay_open_buf()

If the code hits "goto free_buf;" it ends up in this code :

  free_buf:
    	relay_destroy_buf(buf);	<--- calls kfree() on 'buf'.
  free_name:
   	kfree(tmpname);
  end:
  	return buf;		<-- use after free of 'buf'.

I read through the callers and they all handle a NULL return from this
function as an error (and hitting the 'free_buf' label only happens on
failure to chan->cb->create_buf_file(), so that looks like a clear error to
me).

The patch simply sets 'buf' to NULL after the call to
relay_destroy_buf(buf); - as far as I can see that should take care of the
problem.

The patch also corrects a reference to a documentation file while
I was at it.

Note from Mathieu: the documentation reference change should have been
done in a separate patch, but I guess no one will really care.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: "David J. Wilder" <wilder@us.ibm.com>
Tested-by: "David J. Wilder" <wilder@us.ibm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Cc: Karim Yaghmour <karim@opersys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/relay.c~fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support kernel/relay.c
--- a/kernel/relay.c~fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support
+++ a/kernel/relay.c
@@ -1,7 +1,7 @@
 /*
  * Public API and common code for kernel->userspace relay file support.
  *
- * See Documentation/filesystems/relayfs.txt for an overview of relayfs.
+ * See Documentation/filesystems/relay.txt for an overview.
  *
  * Copyright (C) 2002-2005 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
  * Copyright (C) 1999-2005 - Karim Yaghmour (karim@opersys.com)
@@ -426,6 +426,7 @@ static struct rchan_buf *relay_open_buf(
 
 free_buf:
  	relay_destroy_buf(buf);
+ 	buf = NULL;
 free_name:
  	kfree(tmpname);
 end:
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-gfs2-nmw.patch
git-mtd.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
