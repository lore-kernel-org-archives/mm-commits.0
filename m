Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A5DEEAA62
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbjINSvh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242184AbjINSvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:51:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228EB1FF1
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:47:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9345C433C7;
        Thu, 14 Sep 2023 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694717227;
        bh=YSRjohDDMXeQJmduefXfJoizND4pwTw6Zvrf1MOYXwE=;
        h=Date:To:From:Subject:From;
        b=tVIePWPn73MbYtRDTW6MMeycNGEVFFNF7eucUU6dZnDsHO2lBabkbTUBoExavqFdJ
         FBHV37Fe/V/aLrBLuHg7WeuC7KVLcitdPd5zrbsyUNBiIO7rpGVtZjpgFx+eOlrjAv
         6N1S7Fwm5AmmrSx8d0wrOoCrChffvb8fHIqgQy5M=
Date:   Thu, 14 Sep 2023 11:47:07 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        chenjiahao16@huawei.com, catalin.marinas@arm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_corec-remove-unnecessary-parameter-of-function.patch added to mm-nonmm-unstable branch
Message-Id: <20230914184707.B9345C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_core.c: remove unnecessary parameter of function
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_corec-remove-unnecessary-parameter-of-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_corec-remove-unnecessary-parameter-of-function.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: crash_core.c: remove unnecessary parameter of function
Date: Thu, 14 Sep 2023 11:31:34 +0800

Patch series "kdump: use generic functions to simplify crashkernel
reservation in arch", v3.

In the current arm64, crashkernel=,high support has been finished after
several rounds of posting and careful reviewing.  The code in arm64 which
parses crashkernel kernel parameters firstly, then reserve memory can be a
good example for other ARCH to refer to.

Whereas in x86_64, the code mixing crashkernel parameter parsing and
memory reserving is twisted, and looks messy.  Refactoring the code to
make it more readable maintainable is necessary.

Here, firstly abstract the crashkernel parameter parsing code into
parse_crashkernel() to make it be able to parse crashkernel=,high|low. 
Then abstract the crashkernel memory reserving code into a generic
function reserve_crashkernel_generic().  Finally, in ARCH which
crashkernel=,high support is needed, a simple arch_reserve_crashkernel()
can be added to call above two functions.  This can remove the duplicated
implmentation code in each ARCH, like arm64, x86_64 and riscv.

crashkernel=512M,high
crashkernel=512M,high crashkernel=256M,low
crashkernel=512M,high crashkernel=0M,low
crashkernel=0M,high crashkernel=256M,low
crashkernel=512M
crashkernel=512M@0x4f000000
crashkernel=1G-4G:256M,4G-64G:320M,64G-:576M
crashkernel=0M


This patch (of 9):

In all call sites of __parse_crashkernel(), the parameter 'name' is
hardcoded as "crashkernel=".  So remove the unnecessary parameter 'name',
add local varibale 'name' inside __parse_crashkernel() instead.

Link: https://lkml.kernel.org/r/20230914033142.676708-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20230914033142.676708-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/crash_core.c~crash_corec-remove-unnecessary-parameter-of-function
+++ a/kernel/crash_core.c
@@ -248,11 +248,11 @@ static int __init __parse_crashkernel(ch
 			     unsigned long long system_ram,
 			     unsigned long long *crash_size,
 			     unsigned long long *crash_base,
-			     const char *name,
 			     const char *suffix)
 {
 	char	*first_colon, *first_space;
 	char	*ck_cmdline;
+	char	*name = "crashkernel=";
 
 	BUG_ON(!crash_size || !crash_base);
 	*crash_size = 0;
@@ -290,7 +290,7 @@ int __init parse_crashkernel(char *cmdli
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel=", NULL);
+				NULL);
 }
 
 int __init parse_crashkernel_high(char *cmdline,
@@ -299,7 +299,7 @@ int __init parse_crashkernel_high(char *
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-				"crashkernel=", suffix_tbl[SUFFIX_HIGH]);
+				suffix_tbl[SUFFIX_HIGH]);
 }
 
 int __init parse_crashkernel_low(char *cmdline,
@@ -308,7 +308,7 @@ int __init parse_crashkernel_low(char *c
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-				"crashkernel=", suffix_tbl[SUFFIX_LOW]);
+				suffix_tbl[SUFFIX_LOW]);
 }
 
 /*
_

Patches currently in -mm which might be from bhe@redhat.com are

crash_corec-remove-unnecessary-parameter-of-function.patch
crash_core-change-the-prototype-of-function-parse_crashkernel.patch
crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch
crash_core-add-generic-function-to-do-reservation.patch
crash_core-move-crashk_res-definition-into-crash_corec.patch
x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code.patch
arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash_corec-remove-unneeded-functions.patch

