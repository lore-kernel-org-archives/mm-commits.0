From: akpm@linux-foundation.org
Subject: + module-export-param_free_charp.patch added to -mm tree
Date: Wed, 16 Sep 2015 15:30:44 -0700
Message-ID: <55f9ed94.BL23LQG0h+qnaO+x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbIPWap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Sep 2015 18:30:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, rusty@rustcorp.com.au, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: module: export param_free_charp()
has been added to the -mm tree.  Its filename is
     module-export-param_free_charp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/module-export-param_free_charp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/module-export-param_free_charp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

module-export-param_free_charp.patch
zswap-use-charp-for-zswap-param-strings.patch
zpool-remove-redundant-zpool-type-string-const-ify-zpool_get_type.patch

