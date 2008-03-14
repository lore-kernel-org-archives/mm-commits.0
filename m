From: akpm@linux-foundation.org
Subject: + keys-explicitly-include-required-slabh-header-file.patch added to -mm tree
Date: Fri, 14 Mar 2008 12:37:42 -0700
Message-ID: <200803141937.m2EJbgIN015860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbYCNTiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 15:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, dhowells@redhat.com


The patch titled
     keys: explicitly include required slab.h header file.
has been added to the -mm tree.  Its filename is
     keys-explicitly-include-required-slabh-header-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: explicitly include required slab.h header file.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since these two source files invoke kmalloc(), they should explicitly
include <linux/slab.h>.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/request_key.c      |    1 +
 security/keys/request_key_auth.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN security/keys/request_key.c~keys-explicitly-include-required-slabh-header-file security/keys/request_key.c
--- a/security/keys/request_key.c~keys-explicitly-include-required-slabh-header-file
+++ a/security/keys/request_key.c
@@ -16,6 +16,7 @@
 #include <linux/kmod.h>
 #include <linux/err.h>
 #include <linux/keyctl.h>
+#include <linux/slab.h>
 #include "internal.h"
 
 /*
diff -puN security/keys/request_key_auth.c~keys-explicitly-include-required-slabh-header-file security/keys/request_key_auth.c
--- a/security/keys/request_key_auth.c~keys-explicitly-include-required-slabh-header-file
+++ a/security/keys/request_key_auth.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch

