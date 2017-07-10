From: akpm@linux-foundation.org
Subject: [patch 080/115] kernel/ksysfs.c: constify attribute_group
 structures.
Date: Mon, 10 Jul 2017 15:51:14 -0700
Message-ID: <20170710225114.byt4FRTbF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754957AbdGJWvP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arvind.yadav.cs@gmail.com, dyoung@redhat.com, hbathini@linux.vnet.ibm.com, keescook@chromium.org, mm-commits@vger.kernel.org, ptesarik@suse.com, rmk+kernel@arm.linux.org.uk, torvalds@linux-foundation.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: kernel/ksysfs.c: constify attribute_group structures.

attribute_groups are not supposed to change at runtime.  All functions
working with attribute_groups provided by <linux/sysfs.h> work with const
attribute_group.  So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   1120	    544	     16	   1680	    690	kernel/ksysfs.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   1160	    480	     16	   1656	    678	kernel/ksysfs.o

Link: http://lkml.kernel.org/r/aa224b3cc923fdbb3edd0c41b2c639c85408c9e8.1498737347.git.arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.vnet.ibm.com>
Cc: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ksysfs.c~kernel-ksysfs-constify-attribute_group-structures kernel/ksysfs.c
--- a/kernel/ksysfs.c~kernel-ksysfs-constify-attribute_group-structures
+++ a/kernel/ksysfs.c
@@ -234,7 +234,7 @@ static struct attribute * kernel_attrs[]
 	NULL
 };
 
-static struct attribute_group kernel_attr_group = {
+static const struct attribute_group kernel_attr_group = {
 	.attrs = kernel_attrs,
 };
 
_
