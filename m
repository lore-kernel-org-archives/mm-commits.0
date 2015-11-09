From: akpm@linux-foundation.org
Subject: [merged] module-export-param_free_charp.patch removed from -mm
 tree
Date: Mon, 09 Nov 2015 11:44:58 -0800
Message-ID: <5640f7ba.gNUSgWlxodfkadbd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbbKITo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, rusty@rustcorp.com.au, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: module: export param_free_charp()
has been removed from the -mm tree.  Its filename was
     module-export-param_free_charp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: module: export param_free_charp()

Change the param_free_charp() function from static to exported.

It is used by zswap in the next patch ("zswap: use charp for zswap param
strings").

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleparam.h |    1 +
 kernel/params.c             |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/moduleparam.h~module-export-param_free_charp include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~module-export-param_free_charp
+++ a/include/linux/moduleparam.h
@@ -386,6 +386,7 @@ extern int param_get_ullong(char *buffer
 extern const struct kernel_param_ops param_ops_charp;
 extern int param_set_charp(const char *val, const struct kernel_param *kp);
 extern int param_get_charp(char *buffer, const struct kernel_param *kp);
+extern void param_free_charp(void *arg);
 #define param_check_charp(name, p) __param_check(name, p, char *)
 
 /* We used to allow int as well as bool.  We're taking that away! */
diff -puN kernel/params.c~module-export-param_free_charp kernel/params.c
--- a/kernel/params.c~module-export-param_free_charp
+++ a/kernel/params.c
@@ -325,10 +325,11 @@ int param_get_charp(char *buffer, const
 }
 EXPORT_SYMBOL(param_get_charp);
 
-static void param_free_charp(void *arg)
+void param_free_charp(void *arg)
 {
 	maybe_kfree_parameter(*((char **)arg));
 }
+EXPORT_SYMBOL(param_free_charp);
 
 const struct kernel_param_ops param_ops_charp = {
 	.set = param_set_charp,
_

Patches currently in -mm which might be from ddstreet@ieee.org are


