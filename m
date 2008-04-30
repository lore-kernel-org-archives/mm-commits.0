From: akpm@linux-foundation.org
Subject: - keys-explicitly-include-required-slabh-header-file.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:36 -0700
Message-ID: <200804300545.m3U5jaeu029519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735AbYD3Fq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     keys: explicitly include required slab.h header file.
has been removed from the -mm tree.  Its filename was
     keys-explicitly-include-required-slabh-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

