From: akpm@linux-foundation.org
Subject: [merged]
 param-initialize-store-function-to-null-if-not-available.patch removed from -mm tree
Date: Fri, 09 Jan 2015 12:32:15 -0800
Message-ID: <54b03acf.MmOr6syJKOlzqxSY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbAIUcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 15:32:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, keescook@chromium.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: param: initialize store function to NULL if not available
has been removed from the -mm tree.  Its filename was
     param-initialize-store-function-to-null-if-not-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rusty Russell <rusty@rustcorp.com.au>
Subject: param: initialize store function to NULL if not available

I rebased Kees' 'param: do not set store func without write perm' on top
of my 'params: cleanup sysfs allocation'.  However, my patch uses krealloc
which doesn't zero memory, leaving .store unset.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/params.c~param-initialize-store-function-to-null-if-not-available kernel/params.c
--- a/kernel/params.c~param-initialize-store-function-to-null-if-not-available
+++ a/kernel/params.c
@@ -648,6 +648,8 @@ static __modinit int add_sysfs_param(str
 	/* Do not allow runtime DAC changes to make param writable. */
 	if ((kp->perm & (S_IWUSR | S_IWGRP | S_IWOTH)) != 0)
 		mk->mp->attrs[mk->mp->num].mattr.store = param_attr_store;
+	else
+		mk->mp->attrs[mk->mp->num].mattr.store = NULL;
 	mk->mp->attrs[mk->mp->num].mattr.attr.name = (char *)name;
 	mk->mp->attrs[mk->mp->num].mattr.attr.mode = kp->perm;
 	mk->mp->num++;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

init-remove-config_init_fallback.patch
linux-next.patch

