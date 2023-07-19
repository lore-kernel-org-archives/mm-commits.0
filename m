Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CB1C0015E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 20:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjGSUDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 16:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjGSUDi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 16:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3D81FF1
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 13:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06A4361805
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 20:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B212C433C8;
        Wed, 19 Jul 2023 20:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689797012;
        bh=JcfizMg90f2IpE0pbuUK93VaASFVIER23sFzXii7A0o=;
        h=Date:To:From:Subject:From;
        b=oDC+e4l2hKKhnXQENynQ7zbPjW4PdBgdaPTZ1C8Z1R9ejxZw5sJFS1kAJYF6/lZW+
         TIVcW0W6w207OlAVOzXiHTnAeUnqaImGLQrMtg0Gx6dlTnlbPfAkmsLGsmZQ6vwCyc
         ULtOT4QgGKwwotWYRPnrMI/e8UOfyf+Xv3AMcvqI=
Date:   Wed, 19 Jul 2023 13:03:31 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        sudeep.holla@arm.com, skhan@linuxfoundation.org,
        rostedt@goodmis.org, mingo@redhat.com, mhiramat@kernel.org,
        mark.rutland@arm.com, lpieralisi@kernel.org, hpa@zytor.com,
        dlatypov@google.com, davidgow@google.com,
        dave.hansen@linux.intel.com, brendan.higgins@linux.dev,
        bp@alien8.de, bhelgaas@google.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + genetlink-replace-custom-concatenate-implementation.patch added to mm-nonmm-unstable branch
Message-Id: <20230719200332.5B212C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: genetlink: replace custom CONCATENATE() implementation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     genetlink-replace-custom-concatenate-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/genetlink-replace-custom-concatenate-implementation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: genetlink: replace custom CONCATENATE() implementation
Date: Wed, 19 Jul 2023 00:11:47 +0300

Replace custom implementation of the macros from args.h.

Link: https://lkml.kernel.org/r/20230718211147.18647-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genl_magic_func.h   |   27 ++++++++++++++-------------
 include/linux/genl_magic_struct.h |    8 +++-----
 2 files changed, 17 insertions(+), 18 deletions(-)

--- a/include/linux/genl_magic_func.h~genetlink-replace-custom-concatenate-implementation
+++ a/include/linux/genl_magic_func.h
@@ -2,6 +2,7 @@
 #ifndef GENL_MAGIC_FUNC_H
 #define GENL_MAGIC_FUNC_H
 
+#include <linux/args.h>
 #include <linux/build_bug.h>
 #include <linux/genl_magic_struct.h>
 
@@ -23,7 +24,7 @@
 #define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
 	[tag_name] = { .type = NLA_NESTED },
 
-static struct nla_policy CONCAT_(GENL_MAGIC_FAMILY, _tla_nl_policy)[] = {
+static struct nla_policy CONCATENATE(GENL_MAGIC_FAMILY, _tla_nl_policy)[] = {
 #include GENL_MAGIC_INCLUDE_FILE
 };
 
@@ -209,7 +210,7 @@ static int s_name ## _from_attrs_for_cha
  * Magic: define op number to op name mapping				{{{1
  *									{{{2
  */
-static const char *CONCAT_(GENL_MAGIC_FAMILY, _genl_cmd_to_str)(__u8 cmd)
+static const char *CONCATENATE(GENL_MAGIC_FAMILY, _genl_cmd_to_str)(__u8 cmd)
 {
 	switch (cmd) {
 #undef GENL_op
@@ -235,7 +236,7 @@ static const char *CONCAT_(GENL_MAGIC_FA
 	.cmd = op_name,						\
 },
 
-#define ZZZ_genl_ops		CONCAT_(GENL_MAGIC_FAMILY, _genl_ops)
+#define ZZZ_genl_ops		CONCATENATE(GENL_MAGIC_FAMILY, _genl_ops)
 static struct genl_ops ZZZ_genl_ops[] __read_mostly = {
 #include GENL_MAGIC_INCLUDE_FILE
 };
@@ -248,32 +249,32 @@ static struct genl_ops ZZZ_genl_ops[] __
  * and provide register/unregister functions.
  *									{{{2
  */
-#define ZZZ_genl_family		CONCAT_(GENL_MAGIC_FAMILY, _genl_family)
+#define ZZZ_genl_family		CONCATENATE(GENL_MAGIC_FAMILY, _genl_family)
 static struct genl_family ZZZ_genl_family;
 /*
  * Magic: define multicast groups
  * Magic: define multicast group registration helper
  */
-#define ZZZ_genl_mcgrps		CONCAT_(GENL_MAGIC_FAMILY, _genl_mcgrps)
+#define ZZZ_genl_mcgrps		CONCATENATE(GENL_MAGIC_FAMILY, _genl_mcgrps)
 static const struct genl_multicast_group ZZZ_genl_mcgrps[] = {
 #undef GENL_mc_group
 #define GENL_mc_group(group) { .name = #group, },
 #include GENL_MAGIC_INCLUDE_FILE
 };
 
-enum CONCAT_(GENL_MAGIC_FAMILY, group_ids) {
+enum CONCATENATE(GENL_MAGIC_FAMILY, group_ids) {
 #undef GENL_mc_group
-#define GENL_mc_group(group) CONCAT_(GENL_MAGIC_FAMILY, _group_ ## group),
+#define GENL_mc_group(group) CONCATENATE(GENL_MAGIC_FAMILY, _group_ ## group),
 #include GENL_MAGIC_INCLUDE_FILE
 };
 
 #undef GENL_mc_group
 #define GENL_mc_group(group)						\
-static int CONCAT_(GENL_MAGIC_FAMILY, _genl_multicast_ ## group)(	\
+static int CONCATENATE(GENL_MAGIC_FAMILY, _genl_multicast_ ## group)(	\
 	struct sk_buff *skb, gfp_t flags)				\
 {									\
 	unsigned int group_id =						\
-		CONCAT_(GENL_MAGIC_FAMILY, _group_ ## group);		\
+		CONCATENATE(GENL_MAGIC_FAMILY, _group_ ## group);		\
 	return genlmsg_multicast(&ZZZ_genl_family, skb, 0,		\
 				 group_id, flags);			\
 }
@@ -289,8 +290,8 @@ static struct genl_family ZZZ_genl_famil
 #ifdef GENL_MAGIC_FAMILY_HDRSZ
 	.hdrsize = NLA_ALIGN(GENL_MAGIC_FAMILY_HDRSZ),
 #endif
-	.maxattr = ARRAY_SIZE(CONCAT_(GENL_MAGIC_FAMILY, _tla_nl_policy))-1,
-	.policy	= CONCAT_(GENL_MAGIC_FAMILY, _tla_nl_policy),
+	.maxattr = ARRAY_SIZE(CONCATENATE(GENL_MAGIC_FAMILY, _tla_nl_policy))-1,
+	.policy	= CONCATENATE(GENL_MAGIC_FAMILY, _tla_nl_policy),
 	.ops = ZZZ_genl_ops,
 	.n_ops = ARRAY_SIZE(ZZZ_genl_ops),
 	.mcgrps = ZZZ_genl_mcgrps,
@@ -299,12 +300,12 @@ static struct genl_family ZZZ_genl_famil
 	.module = THIS_MODULE,
 };
 
-int CONCAT_(GENL_MAGIC_FAMILY, _genl_register)(void)
+int CONCATENATE(GENL_MAGIC_FAMILY, _genl_register)(void)
 {
 	return genl_register_family(&ZZZ_genl_family);
 }
 
-void CONCAT_(GENL_MAGIC_FAMILY, _genl_unregister)(void)
+void CONCATENATE(GENL_MAGIC_FAMILY, _genl_unregister)(void)
 {
 	genl_unregister_family(&ZZZ_genl_family);
 }
--- a/include/linux/genl_magic_struct.h~genetlink-replace-custom-concatenate-implementation
+++ a/include/linux/genl_magic_struct.h
@@ -14,14 +14,12 @@
 # error "you need to define GENL_MAGIC_INCLUDE_FILE before inclusion"
 #endif
 
+#include <linux/args.h>
 #include <linux/genetlink.h>
 #include <linux/types.h>
 
-#define CONCAT__(a,b)	a ## b
-#define CONCAT_(a,b)	CONCAT__(a,b)
-
-extern int CONCAT_(GENL_MAGIC_FAMILY, _genl_register)(void);
-extern void CONCAT_(GENL_MAGIC_FAMILY, _genl_unregister)(void);
+extern int CONCATENATE(GENL_MAGIC_FAMILY, _genl_register)(void);
+extern void CONCATENATE(GENL_MAGIC_FAMILY, _genl_unregister)(void);
 
 /*
  * Extension of genl attribute validation policies			{{{2
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-count_args-and-concatenate-to-argsh.patch
x86-asm-replace-custom-count_args-concatenate-implementations.patch
arm64-smccc-replace-custom-count_args-concatenate-implementations.patch
genetlink-replace-custom-concatenate-implementation.patch

