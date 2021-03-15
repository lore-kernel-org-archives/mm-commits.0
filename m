Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E86C433E6
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B67A664F4F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhCOVe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 17:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhCOVeo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 17:34:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDAD264F37;
        Mon, 15 Mar 2021 21:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615844084;
        bh=cogHBMYWuDGErGdmcD8SaL+9888Z6b2YdBecOxdaG2s=;
        h=Date:From:To:Subject:From;
        b=Yd72CmX9I0oZhONVkczICzFnafKXO46MuIZjjihcVFVqRP/8Z4NDXcLojFjvZhz9w
         AW540p2AUk1k5aiUPe78EtupUKo0tLEtSjMR//t1QiG+yYRYkvD4bL4xs00bXFwome
         66zCpaNDmBZ6VTJKNsSyTDKTSrMPNWBIW9WPH/g4=
Date:   Mon, 15 Mar 2021 14:34:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org
Subject:  + ia64-fix-format-strings-for-err_inject.patch added to
 -mm tree
Message-ID: <20210315213443.-lZ8ikkxs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix format strings for err_inject
has been added to the -mm tree.  Its filename is
     ia64-fix-format-strings-for-err_inject.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-format-strings-for-err_inject.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-format-strings-for-err_inject.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: fix format strings for err_inject

Fix warning with %lx / u64 mismatch:

  arch/ia64/kernel/err_inject.c: In function 'show_resources':
  arch/ia64/kernel/err_inject.c:62:22: warning:
    format '%lx' expects argument of type 'long unsigned int',
    but argument 3 has type 'u64' {aka 'long long unsigned int'}
     62 |  return sprintf(buf, "%lx
", name[cpu]);   \
        |                      ^~~~~~~

Link: https://lkml.kernel.org/r/20210313104312.1548232-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/err_inject.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/arch/ia64/kernel/err_inject.c~ia64-fix-format-strings-for-err_inject
+++ a/arch/ia64/kernel/err_inject.c
@@ -59,7 +59,7 @@ show_##name(struct device *dev, struct d
 		char *buf)						\
 {									\
 	u32 cpu=dev->id;						\
-	return sprintf(buf, "%lx\n", name[cpu]);			\
+	return sprintf(buf, "%llx\n", name[cpu]);			\
 }
 
 #define store(name)							\
@@ -86,9 +86,9 @@ store_call_start(struct device *dev, str
 
 #ifdef ERR_INJ_DEBUG
 	printk(KERN_DEBUG "pal_mc_err_inject for cpu%d:\n", cpu);
-	printk(KERN_DEBUG "err_type_info=%lx,\n", err_type_info[cpu]);
-	printk(KERN_DEBUG "err_struct_info=%lx,\n", err_struct_info[cpu]);
-	printk(KERN_DEBUG "err_data_buffer=%lx, %lx, %lx.\n",
+	printk(KERN_DEBUG "err_type_info=%llx,\n", err_type_info[cpu]);
+	printk(KERN_DEBUG "err_struct_info=%llx,\n", err_struct_info[cpu]);
+	printk(KERN_DEBUG "err_data_buffer=%llx, %llx, %llx.\n",
 			  err_data_buffer[cpu].data1,
 			  err_data_buffer[cpu].data2,
 			  err_data_buffer[cpu].data3);
@@ -117,8 +117,8 @@ store_call_start(struct device *dev, str
 
 #ifdef ERR_INJ_DEBUG
 	printk(KERN_DEBUG "Returns: status=%d,\n", (int)status[cpu]);
-	printk(KERN_DEBUG "capabilities=%lx,\n", capabilities[cpu]);
-	printk(KERN_DEBUG "resources=%lx\n", resources[cpu]);
+	printk(KERN_DEBUG "capabilities=%llx,\n", capabilities[cpu]);
+	printk(KERN_DEBUG "resources=%llx\n", resources[cpu]);
 #endif
 	return size;
 }
@@ -131,7 +131,7 @@ show_virtual_to_phys(struct device *dev,
 			char *buf)
 {
 	unsigned int cpu=dev->id;
-	return sprintf(buf, "%lx\n", phys_addr[cpu]);
+	return sprintf(buf, "%llx\n", phys_addr[cpu]);
 }
 
 static ssize_t
@@ -145,7 +145,7 @@ store_virtual_to_phys(struct device *dev
 	ret = get_user_pages_fast(virt_addr, 1, FOLL_WRITE, NULL);
 	if (ret<=0) {
 #ifdef ERR_INJ_DEBUG
-		printk("Virtual address %lx is not existing.\n",virt_addr);
+		printk("Virtual address %llx is not existing.\n", virt_addr);
 #endif
 		return -EINVAL;
 	}
@@ -163,7 +163,7 @@ show_err_data_buffer(struct device *dev,
 {
 	unsigned int cpu=dev->id;
 
-	return sprintf(buf, "%lx, %lx, %lx\n",
+	return sprintf(buf, "%llx, %llx, %llx\n",
 			err_data_buffer[cpu].data1,
 			err_data_buffer[cpu].data2,
 			err_data_buffer[cpu].data3);
@@ -178,13 +178,13 @@ store_err_data_buffer(struct device *dev
 	int ret;
 
 #ifdef ERR_INJ_DEBUG
-	printk("write err_data_buffer=[%lx,%lx,%lx] on cpu%d\n",
+	printk("write err_data_buffer=[%llx,%llx,%llx] on cpu%d\n",
 		 err_data_buffer[cpu].data1,
 		 err_data_buffer[cpu].data2,
 		 err_data_buffer[cpu].data3,
 		 cpu);
 #endif
-	ret=sscanf(buf, "%lx, %lx, %lx",
+	ret = sscanf(buf, "%llx, %llx, %llx",
 			&err_data_buffer[cpu].data1,
 			&err_data_buffer[cpu].data2,
 			&err_data_buffer[cpu].data3);
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-mca-allocate-early-mca-with-gfp_atomic.patch
ia64-fix-format-strings-for-err_inject.patch

